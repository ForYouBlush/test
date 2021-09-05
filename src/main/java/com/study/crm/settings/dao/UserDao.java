package com.study.crm.settings.dao;

import com.study.crm.settings.domain.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;
@Repository
public interface UserDao {
    User queryUser(Map<String,Object> map);

    List<User> getUserList();
}
