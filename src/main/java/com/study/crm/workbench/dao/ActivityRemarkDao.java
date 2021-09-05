package com.study.crm.workbench.dao;

import com.study.crm.workbench.domain.ActivityRemark;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ActivityRemarkDao {
    int getCountById(String[] ids);

    int deleteById(String[] ids);

    List<ActivityRemark> getRemark(String id);

    int deleteRemarkById(String id);

    int updateRemark(ActivityRemark ar);

    int saveRemark(ActivityRemark ar);
}
