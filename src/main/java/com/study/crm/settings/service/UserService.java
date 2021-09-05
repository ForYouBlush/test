package com.study.crm.settings.service;

import com.study.crm.settings.domain.User;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public interface UserService {
    User login(Map<String,Object> map);
}
