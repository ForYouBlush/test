package com.study.crm.workbench.web.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.study.crm.settings.domain.User;
import com.study.crm.settings.service.UserService;
import com.study.crm.utils.DateTimeUtil;
import com.study.crm.utils.MD5Util;
import com.study.crm.utils.PrintJson;
import com.study.crm.utils.UUIDUtil;
import com.study.crm.vo.PaginationVO;
import com.study.crm.workbench.domain.Activity;
import com.study.crm.workbench.domain.ActivityRemark;
import com.study.crm.workbench.service.ActivityService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
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
@RequestMapping("/workbench")
public class ActivityController {
    @Resource
    private ActivityService activityService;
    @RequestMapping(value = "/activity/getUserList.do")
    @ResponseBody
    public void getUserList( HttpServletResponse response){
            List<User> userList=activityService.getUserList();
            //把userlist解析为字符串并输出
            PrintJson.printJsonObj(response,userList);
    }

    @RequestMapping(value = "/activity/save.do")
    @ResponseBody
    public void save(HttpServletRequest request, HttpServletResponse response, Activity activity){
        activity.setCreateBy(((User)request.getSession().getAttribute("user")).getName());
        activity.setId(UUIDUtil.getUUID());
        activity.setCreateTime(DateTimeUtil.getSysTime());
        boolean success=activityService.save(activity);
        PrintJson.printJsonFlag(response,success);
    }

    @RequestMapping(value = "/activity/pageList.do")
    @ResponseBody
    public void getPageList(HttpServletResponse response, Integer pageNo,
                         Integer pageSize,Activity activity) {
        //获取跳过的记录条数
        Integer skipNum=(pageNo-1)*pageSize;
        Map<String,Object> map=new HashMap<>();
//        map.put("name",name);
//        map.put("owner",owner);
//        map.put("startDate",startDate);
//        map.put("endDate",endDate);
        map.put("activity",activity);
        map.put("skipNum",skipNum);
        map.put("pageSize",pageSize);
        PaginationVO vo=activityService.getPageList(map);
        PrintJson.printJsonObj(response,vo);
    }
    @RequestMapping(value = "/activity/delete.do")
    @ResponseBody
    public void getPageList(HttpServletResponse response,@RequestParam("param[]") String[] ids) {
        boolean success=activityService.delete(ids);
        PrintJson.printJsonFlag(response,success);
    }


    @RequestMapping(value = "/activity/edit.do")
    @ResponseBody
    public void getUserAndActivity(HttpServletResponse response,String id) {
       Map<String,Object> map=activityService.getUserAndActivity(id);
       PrintJson.printJsonObj(response,map);
    }


    @RequestMapping(value = "/activity/update.do")
    @ResponseBody
    public void update(HttpServletRequest request, HttpServletResponse response, Activity activity)  {
        activity.setEditBy(((User)request.getSession().getAttribute("user")).getName());
        activity.setEditTime(DateTimeUtil.getSysTime());
        boolean success=activityService.update(activity);
        PrintJson.printJsonFlag(response,success);
    }

    @RequestMapping(value = "/activity/detail.do")
    public ModelAndView detail(String id)  {
        ModelAndView mv=new ModelAndView();
        Activity a=activityService.getDetail(id);
        mv.addObject("a",a);
        mv.setViewName("/workbench/activity/detail.jsp");
        return mv;
    }

    @RequestMapping(value = "/activity/remark.do")
    @ResponseBody
    public void remark(HttpServletResponse response,String id)  {
        List<ActivityRemark> arList=activityService.getRemark(id);
        PrintJson.printJsonObj(response,arList);
    }

    @RequestMapping(value = "/activity/deleteRemark.do")
    @ResponseBody
    public void deleteRemark(HttpServletResponse response, String id) {
        boolean success=activityService.deleteRemark(id);
        PrintJson.printJsonFlag(response,success);
    }
    @RequestMapping(value = "/activity/updateRemark.do")
    @ResponseBody
    public void updateRemark(HttpServletRequest request,HttpServletResponse response,ActivityRemark ar) {
        ar.setEditTime(DateTimeUtil.getSysTime());
        ar.setEditFlag("1");
        ar.setEditBy(((User)request.getSession().getAttribute("user")).getName());
        boolean success=activityService.updateRemark(ar);
        Map<String,Object> map=new HashMap<>();
        map.put("success",success);
        map.put("ar",ar);
        PrintJson.printJsonObj(response,map);
    }
    @RequestMapping(value = "/activity/saveRemark.do")
    @ResponseBody
    public void saveRemark(HttpServletRequest request,HttpServletResponse response,ActivityRemark ar) {
        ar.setCreateTime(DateTimeUtil.getSysTime());
        ar.setId(UUIDUtil.getUUID());
        ar.setEditFlag("0");
        ar.setCreateBy(((User)request.getSession().getAttribute("user")).getName());
        boolean success=activityService.saveRemark(ar);
        Map<String,Object> map=new HashMap<>();
        map.put("success",success);
        map.put("ar",ar);
        PrintJson.printJsonObj(response,map);
    }
}
