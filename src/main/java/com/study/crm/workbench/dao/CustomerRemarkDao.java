package com.study.crm.workbench.dao;

import com.study.crm.workbench.domain.CustomerRemark;
import org.springframework.stereotype.Repository;

@Repository
public interface CustomerRemarkDao {

    int save(CustomerRemark customerRemark);
}
