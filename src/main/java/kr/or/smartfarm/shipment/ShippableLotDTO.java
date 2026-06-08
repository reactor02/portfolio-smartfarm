package kr.or.smartfarm.shipment;

import lombok.Data;

/**
 * 출하 가능 LOT 전송 객체.
 *
 * <p>shipment.xml의 {@code selectShippableLots} 결과를 담는다.
 * 해당 쿼리는 유통기한이 SYSDATE보다 미래이고(type 검사 포함) 품목 타입이
 * 'PRODUCT'인 LOT 행만 SELECT 하므로, 이 DTO 목록은 곧 "출하 가능한 LOT"이다.
 * 컬럼명과 필드명이 동일(snake_case)하여 별도 alias 없이 매핑된다.</p>
 */
@Data
public class ShippableLotDTO {
    private int    lot_num;
    private String lot_code;
    private String expiry_date;   // TO_CHAR 'YYYY-MM-DD'
    private String type;
    private int    current_qty;   // 보유 수량 (출하수량 입력 상한)
    private int    item_num;       // 품목 번호
    private String lot_date;       // 생성일 (FIFO 정렬 기준, TO_CHAR 문자열)
}
