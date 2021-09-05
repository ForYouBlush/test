package com.study.crm.settings.dao;

import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DicTypeDao {
    List<String> getType();
}
