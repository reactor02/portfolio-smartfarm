# 작업지시 회차(Cycle) 반복 생산 — 구현 결과 보고서

- 작성일: 2026-06-08
- 브랜치: `claude/blissful-heyrovsky-6af73b`
- 관련 계획: `~/.claude/plans/concurrent-brewing-sprout.md`

## 1. 배경 / 문제

작업지시 생산을 공정별 라우팅 상태머신(`work_process`/`work_process_lot`)으로 전환한 뒤,
**한 작업지시에서 라우팅을 여러 번 돌리는("회차") 시나리오가 표현되지 않는 구멍**이 있었다.

- `work_process`가 `(order_num, process_num)`당 1행뿐 → 전 공정 완료 시 더 진행할 방법이 없어,
  부분 배치(지시 100 중 40만 생산) 후 **나머지를 이어서 생산 불가(stuck)**.
- 억지로 공정을 리셋해 2회차를 돌리면: 완제품 수량 **덮어쓰기**(누적 안 됨), `lot_relation` **중복**,
  `work_process_lot`의 **회차 구분 불가**로 추적이 깨짐.

## 2. 설계 결정 (사용자 선택)

1. **완제품 LOT = 단일 LOT 누적** — 작업시작 때 만든 product_lot 1개에 회차 수량을 더한다.
2. **배치수량(input_qty) = 회차마다 재입력** — 각 회차 첫 투입에서 1~최대생산량으로 새로 확정.
3. **다음 회차 = 수동 버튼** — 현재 회차 전 공정 완료 + `current_qty < order_qty`일 때만 노출.

각 회차는 공정 행을 리셋하지 않고 **새 `work_process` 행 집합(cycle_no=N)을 INSERT**한다.
회차별 소모자재는 그 회차 행의 `work_process_num`을 통해 `work_process_lot`에 귀속 → 회차별 추적 보존.

## 3. 변경 사항

### DB 스키마 (라이브 적용 완료)
- `ALTER TABLE work_process ADD (cycle_no NUMBER DEFAULT 1 NOT NULL)` — 스크립트 `db/alter_work_process_cycle.sql`.
- ojdbc8 JDBC로 적용·검증 완료. 기존 행은 `DEFAULT 1`로 1회차 처리, 컬럼 미참조 코드도 후방호환.

### 매퍼 `src/main/resources/mybatis/mappers/order.xml`
- `insertWorkProcess`(+cycle_no), `getWorkProcesses`(cycle_no SELECT + `ORDER BY cycle_no, flow`)
- 신규 `getCurrentCycleNo`, `getCurrentCycleProcessLots`, `resetInputQty`
- `setWorkProcessStatus` — 현재 회차(`MAX(cycle_no)`)만 갱신(이전 회차 오염 방지)
- `finalizeProductLot`·`setCurrentQty` — 누적형(`NVL(x,0)+#{qty}`)
- `getWorkProcessLots` — cycle_no 포함, 회차순 정렬

### 매퍼 `src/main/resources/mybatis/mappers/lot.xml`
- `insertLotRelation` — 멱등화(`WHERE NOT EXISTS`)로 계보 중복/추적 트리 뻥튀기 방지
- `getLotHistory`의 `[2]` 생산 블록 — `work_process` 조인으로 **회차×공정 단계 펼침**
  (`status_col`=공정상태, `flow_order`=cycle_no*1000+flow)

### 자바
- `WorkDAO`/`WorkDAOImpl` — 신규 메서드 3종
- `WorkService`/`WorkServiceImpl` — `startNextCycle`(게이트: 진행+활성공정없음+미달),
  `completeProcess`가 현재 회차 자재만 계보 연결, `getActionState`에 `canNextCycle`/`currentCycleNo`,
  `ensureWorkProcesses`/`insertCycleProcesses`로 회차 행 생성
- `WorkController` — `POST /work/{id}/next-cycle`

### 화면
- `workDetail.jsp` — allDone 분기에 `canNextCycle`이면 "다음 회차 생산" 버튼 + 진행률 안내
- `workDetail.js` — `nextCycle()` (POST → reload), 버튼 바인딩 (인라인 금지 규칙 준수)

## 4. 검증 결과

### 단위/BDD (JDK11 + Mockito 2.28.2, mock 기반)
- **신규 `WorkCycleServiceTest` — 10 PASS**
  정상경로(다음회차 노출/시작/누적/현재회차 계보) + 실패케이스(NULL·존재안함, 경계값 off-by-one,
  중복제출/레이스=활성공정 존재, 수량충족 거부)
- **기존 `WorkProcessServiceTest` — 17 PASS** (회귀 무손상; 계보연결 변경에 맞춰 스텁 1곳 수정)

### 통합 E2E (실제 Oracle, 트랜잭션 후 ROLLBACK — 데이터 무오염) — **16/16 PASS**
| 항목 | 결과 |
|---|---|
| 한글 status 인코딩 왕복(JDBC) | PASS |
| getCurrentCycleNo 1→2 | PASS |
| 공정 상태 전이(대기→진행→완료) | PASS |
| getCurrentCycleProcessLots 현재 회차 한정 | PASS |
| getWorkProcesses 6행 회차순 정렬 | PASS |
| **회차 격리: cycle2 갱신 시 cycle1 완료 행 보존** | PASS |
| finalizeProductLot 누적(300→320, 0→20) | PASS |
| insertLotRelation 멱등(2회 삽입 후 1건) | PASS |
| getLotHistory[2] 회차 펼침(flow_order 1001→2003) | PASS |
| ROLLBACK 후 work_process/LOT 원상복구 | PASS |

## 5. 남은 항목 / 참고

- **브라우저 UI E2E 미수행**: 본 프로젝트는 외부 Tomcat 배포형(war)이라 자동 구동 대신
  데이터 계층 통합 E2E(위)로 대체. 화면 클릭 흐름(버튼 노출→다음 회차→누적 표시)은
  앱 구동 후 육안 확인 권장.
- **테스트 파일 위치**: 미추적(untracked) 관례. 신규 `WorkCycleServiceTest.java`는 워크트리,
  수정된 `WorkProcessServiceTest.java`는 main 체크아웃에 존재 — 머지 시 동기화 필요.
- 테스트 컴파일: DTO(@Data)는 명시적으로 나열해야 lombok 동작(-sourcepath 끌림은 처리 제외).
