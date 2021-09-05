package com.study.crm.workbench.dao;

import com.study.crm.workbench.domain.ContactsRemark;
import org.springframework.stereotype.Repository;

@Repository
public interface ContactsRemarkDao {

    int save(ContactsRemark contactsRemark);
}
