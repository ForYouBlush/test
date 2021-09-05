package com.study.crm.workbench.dao;

import com.study.crm.workbench.domain.Contacts;
import com.study.crm.workbench.domain.Customer;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CustomerDao {

    Customer getCustomerByName(String company);

    int save(Customer cus);

    List<String> getCustomerLikeName(String name);


}
