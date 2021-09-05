package com.study.crm.settings.web.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.study.crm.settings.domain.User;
import com.study.crm.settings.service.UserService;
import com.study.crm.settings.service.impl.UserServiceImpl;
import com.study.crm.utils.DateTimeUtil;
import com.study.crm.utils.MD5Util;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/user")
public class UserController {
    @Resource
    private UserService userService;
    @RequestMapping(value = "/login.do")
    public void login(HttpServletRequest request, HttpServletResponse response,
                      String loginAct, String loginPwd) throws IOException {
        String msg="";
        boolean success=false;
        String address=request.getRemoteAddr();
        PrintWriter out=response.getWriter();
        Map<String,Object> map=new HashMap<>();
        loginPwd= MD5Util.getMD5(loginPwd);
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);
        User user=userService.login(map);
        String currentTime= DateTimeUtil.getSysTime();
        if (user!=null){
            //账号密码正确
            if (currentTime.compareTo(user.getExpireTime())<0){
                //账号没有失效
                if ("1".equals(user.getLockState())){
                    //账号没有被锁定
                    if (user.getAllowIps().contains(address)){
                        //该账号ip允许访问
                        request.getSession().setAttribute("user",user);
                        success=true;
                    }else {
                        msg="该ip不允许访问";
                    }
                }else {
                    msg="账号已锁定";
                }
            }else {
                msg="账号已失效";
            }
        }else {
            msg="账号或密码错误";
        }
        Map map1=new HashMap();
        map1.put("success",success);
        map1.put("msg",msg);
        ObjectMapper om=new ObjectMapper();
        String json=om.writeValueAsString(map1);
        out.print(json);
        out.flush();
        out.close();
    }
}
