package com.study.crm.web.listener;

import com.study.crm.settings.domain.DicValue;
import com.study.crm.settings.service.DicService;
import com.study.crm.settings.service.impl.DicServiceImpl;
import com.study.crm.utils.ServiceFactory;
import com.study.crm.workbench.service.ClueService;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.*;

public class SysInitListener implements ServletContextListener {
    private DicService dicService;
    @Override
    public void contextInitialized(ServletContextEvent event) {
        //加载数据字典
        ServletContext servletContext=event.getServletContext();
        dicService= WebApplicationContextUtils.getWebApplicationContext(servletContext).getBean(DicService.class);
       Map<String, List<DicValue>> map=dicService.getAll();
        Set<String> set=map.keySet();
        for (String key:set
             ) {
            List<DicValue> dicValue=map.get(key);
            servletContext.setAttribute(key,dicValue);
        }


        //加载properties文件存放到上下文对象中
        ResourceBundle resourceBundle=ResourceBundle.getBundle("conf/Stage2Possibility");
        Enumeration<String> keys = resourceBundle.getKeys();
        Map<String,String> pmap=new HashMap<>();
        while (keys.hasMoreElements()){
            String key=keys.nextElement();
            String value=resourceBundle.getString(key);
            pmap.put(key,value);
        }
        servletContext.setAttribute("pmap",pmap);
    }

    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent) {

    }
}
