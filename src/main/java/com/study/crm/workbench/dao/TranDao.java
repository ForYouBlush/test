package com.study.crm.workbench.dao;

import com.study.crm.workbench.domain.Tran;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface TranDao {

    int save(Tran t);

    Integer getTotalByCondition(Map<String, Object> map);

    List<Tran> getTranListByCondition(Map<String, Object> map);

    int deleteTranByIds(String[] ids);

    Tran getTranById(String id);

    int changeStage(Tran t);
}
