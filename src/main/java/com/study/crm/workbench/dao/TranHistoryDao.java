package com.study.crm.workbench.dao;

import com.study.crm.workbench.domain.TranHistory;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TranHistoryDao {

    int save(TranHistory tranHistory);

    List<TranHistory> getHistoryListByTranId(String tranId);
}
