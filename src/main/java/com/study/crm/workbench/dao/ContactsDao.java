package com.study.crm.workbench.dao;

import com.study.crm.workbench.domain.Contacts;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ContactsDao {

    int save(Contacts con);

    List<Contacts> getAll();

    List<Contacts> getContactsLikeName(String name);
}
