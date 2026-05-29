package kr.or.smartfarm.prod;

import lombok.Data;

/**
 * 드롭다운(select) 옵션용 공용 DTO.
 *
 * <p>담당자/생산계획/품목/시설 등 각종 selectbox 옵션을 {num, name, type}
 * 형태로 통일해 담는다. (Lombok {@code @Data})</p>
 */
@Data
public class SelectOptionDTO {
    private int num;       // 옵션 값(PK)
    private String name;   // 화면 표시 라벨
    private String type;   // 분류(품목 type 등, 옵션에 따라 미사용)
}