package com.study.crm.web.filter;

import com.study.crm.settings.domain.User;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class LoginFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest request= (HttpServletRequest) servletRequest;
        String path=request.getServletPath();
        HttpServletResponse response= (HttpServletResponse) servletResponse;
        HttpSession session=request.getSession();
        User user = (User) session.getAttribute("user");
        if ("/login.jsp".equals(path)||"/user/login.do".equals(path)){
            filterChain.doFilter(servletRequest,servletResponse);
        }else {
            if (user==null){
                response.sendRedirect(request.getContextPath()+"/login.jsp");
            }
            filterChain.doFilter(servletRequest,servletResponse);
        }
    }

    @Override
    public void destroy() {

    }
}
