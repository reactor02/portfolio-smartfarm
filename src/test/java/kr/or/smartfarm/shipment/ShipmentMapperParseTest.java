package kr.or.smartfarm.shipment;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.io.InputStream;

import org.apache.ibatis.builder.xml.XMLMapperBuilder;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.Configuration;
import org.junit.BeforeClass;
import org.junit.Test;

/**
 * shipment.xml 매퍼 "파싱" 검증 (DB 불필요).
 *
 * <p>DAO 단위 테스트(ShipmentServiceImplTest)는 DAO를 mock 으로 대체하므로
 * 실제 매퍼 XML 은 전혀 검증되지 않는다. 이 테스트는 MyBatis {@link Configuration}에
 * shipment.xml 을 직접 로드하여,</p>
 * <ul>
 *   <li>XML 자체가 문법 오류 없이 파싱되는지(빌드 단계에서 예외가 나면 실패),</li>
 *   <li>DAOImpl 이 호출하는 statement id 가 실제로 등록돼 있는지(id 오타 검출)</li>
 * </ul>
 * <p>를 검증한다. 실제 SQL 실행이 아니므로 DB/데이터는 필요 없다.</p>
 */
public class ShipmentMapperParseTest {

    private static final String NS = "kr.or.smartfarm.shipment.";
    private static Configuration cfg;

    @BeforeClass
    public static void parseMapperOnce() throws Exception {
        // 클래스패스에서 매퍼 XML 로드 → MyBatis 가 DTD 를 내장 리졸버로 처리(오프라인 OK)
        String resource = "mybatis/mappers/shipment.xml";
        cfg = new Configuration();
        try (InputStream is = Resources.getResourceAsStream(resource)) {
            XMLMapperBuilder builder =
                    new XMLMapperBuilder(is, cfg, resource, cfg.getSqlFragments());
            builder.parse(); // XML 문법/구조 오류가 있으면 여기서 예외 → 테스트 실패
        }
    }

    @Test
    public void shipment_xml이_문법오류없이_파싱된다() {
        // parse() 가 성공했고 statement 가 1개 이상 등록됐다면 파싱 성공
        assertTrue("등록된 statement 가 있어야 한다",
                cfg.getMappedStatementNames().size() > 0);
    }

    @Test
    public void getLotExpiry_statement가_등록돼있다() {
        assertTrue(cfg.hasStatement(NS + "getLotExpiry"));
        assertNotNull(cfg.getMappedStatement(NS + "getLotExpiry"));
    }

    @Test
    public void getShipmentLotExpiries_statement가_등록돼있다() {
        assertTrue(cfg.hasStatement(NS + "getShipmentLotExpiries"));
        assertNotNull(cfg.getMappedStatement(NS + "getShipmentLotExpiries"));
    }

    @Test
    public void getLotItemType_statement가_등록돼있다() {
        assertTrue(cfg.hasStatement(NS + "getLotItemType"));
        assertNotNull(cfg.getMappedStatement(NS + "getLotItemType"));
    }

    @Test
    public void countShipmentLotByLotNum_statement가_등록돼있다() {
        assertTrue(cfg.hasStatement(NS + "countShipmentLotByLotNum"));
        assertNotNull(cfg.getMappedStatement(NS + "countShipmentLotByLotNum"));
    }

    @Test
    public void selectShippableLots_statement가_등록돼있다() {
        // resultType의 FQN(ShippableLotDTO)까지 파싱 단계에서 클래스 로딩되어야 통과
        assertTrue(cfg.hasStatement(NS + "selectShippableLots"));
        assertNotNull(cfg.getMappedStatement(NS + "selectShippableLots"));
    }

    @Test
    public void selectLotForConfirm_statement가_등록돼있다() {
        assertTrue(cfg.hasStatement(NS + "selectLotForConfirm"));
        assertNotNull(cfg.getMappedStatement(NS + "selectLotForConfirm"));
    }
}
