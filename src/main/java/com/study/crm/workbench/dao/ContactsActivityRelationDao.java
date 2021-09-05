package com.study.crm.workbench.dao;

import com.study.crm.workbench.domain.ContactsActivityRelation;
import org.springframework.stereotype.Repository;

@Repository
public interface ContactsActivityRelationDao {

    int save(ContactsActivityRelation contactsActivityRelation);
}
