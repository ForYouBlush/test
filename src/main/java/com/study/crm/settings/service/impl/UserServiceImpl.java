package com.study.crm.settings.service.impl;

import com.study.crm.settings.dao.UserDao;
import com.study.crm.settings.domain.User;
import com.study.crm.settings.service.UserService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

@Service
public class UserServiceImpl implements UserService {
    @Resource
    private UserDao userDao;

    @Override
    public User login(Map<String, Object> map) {
        User user=userDao.queryUser(map);
        return user;
    }
}
