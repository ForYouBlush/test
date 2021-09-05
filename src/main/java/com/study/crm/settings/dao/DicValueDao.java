package com.study.crm.settings.dao;

import com.study.crm.settings.domain.DicValue;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DicValueDao {
    List<DicValue> getValueByType(String code);
}
