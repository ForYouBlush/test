package com.study.crm.workbench.dao;

import com.study.crm.workbench.domain.ClueRemark;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ClueRemarkDao {

    List<ClueRemark> getListByClueId(String clueId);

    int delete(ClueRemark clueRemark);

    int deleteRemarkById(String id);

    int updateRemark(ClueRemark cr);

    int saveRemark(ClueRemark cr);
}
