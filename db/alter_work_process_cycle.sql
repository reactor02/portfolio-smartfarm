-- 작업지시 회차(Cycle) 반복 생산: work_process 에 회차 번호 컬럼 추가
-- 각 회차마다 공정 행 집합을 새로 INSERT (cycle_no = 1,2,3...) 하여
-- 회차별 소모자재(work_process_lot)를 work_process_num 으로 추적 가능하게 한다.
-- 기존 행은 DEFAULT 1 로 자동 1회차 처리.
ALTER TABLE work_process ADD (cycle_no NUMBER DEFAULT 1 NOT NULL);
