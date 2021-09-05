package com.study.crm.settings.service.impl;

import com.study.crm.settings.dao.DicTypeDao;
import com.study.crm.settings.dao.DicValueDao;
import com.study.crm.settings.domain.DicType;
import com.study.crm.settings.domain.DicValue;
import com.study.crm.settings.service.DicService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class DicServiceImpl implements DicService {
    @Resource
    private DicTypeDao dicTypeDao;
    @Resource
    private DicValueDao dicValueDao;

    @Override
    public Map<String, List<DicValue>> getAll() {
        Map<String,  List<DicValue>> map=new HashMap<>();
        List<String> list=dicTypeDao.getType();
        for (String code:list
             ) {
            List<DicValue> list2=dicValueDao.getValueByType(code);
            map.put(code+"List",list2);
        }
        return map;
    }
}
