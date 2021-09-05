package com.study.crm.web.interceptor;

import com.study.crm.settings.domain.User;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class URLInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        System.out.println("拦截器。。。");
        return true;
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
        System.out.println("拦截器。。。");
        String path=request.getServletPath();
        HttpSession session = request.getSession();
        User user= (User) session.getAttribute("user");
        System.out.println(path);
        if ("/login.jsp".equals(path)||"/user/login.do".equals(path)){

        }
        else if (user==null){
            response.sendRedirect(request.getContextPath()+"/index.jsp");
        }

    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
        System.out.println("123");
    }
}
