package kr.or.smartfarm.lot;

import java.util.List;

import kr.or.smartfarm.prod.SelectOptionDTO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class LotServiceImpl implements LotService {

    @Autowired
    private LotDAO dao;

    @Autowired
    private LotRelationDAO relationDao;

    @Override
    public List<LotDTO> getList(LotPageDTO page) {
        int startRow = (page.getPage() - 1) * page.getSize() + 1;
        int endRow   =  page.getPage()      * page.getSize();
        page.setStartRow(startRow);
        page.setEndRow(endRow);

        List<LotDTO> list = dao.getList(page);

        if (list != null && !list.isEmpty()) {
            int totalCount = list.get(0).getTotal_count();
            int totalPages = (int) Math.ceil((double) totalCount / page.getSize());
            int startPage  = (((page.getPage() - 1) / page.getBlockSize()) * page.getBlockSize()) + 1;
            int endPage    = Math.min(startPage + page.getBlockSize() - 1, totalPages);

            page.setTotalCount(totalCount);
            page.setTotalPages(totalPages);
            page.setStartPage(startPage);
            page.setEndPage(endPage);
        }
        return list;
    }

    @Override
    public LotDTO selectOne(String lot_code) {
        return dao.getSelectOne(lot_code);
    }

    @Override
    public List<SelectOptionDTO> getItemOptions() {
        return dao.getItemOptions();
    }

    @Override
    public List<LotRelationDTO> getMaterialsByChildLot(int lot_num) {
        return relationDao.getMaterialsByChildLot(lot_num);
    }

    @Override
    public List<LotRelationDTO> getParentsByLot(int lot_num) {
        return relationDao.getParentsByLot(lot_num);
    }
}
