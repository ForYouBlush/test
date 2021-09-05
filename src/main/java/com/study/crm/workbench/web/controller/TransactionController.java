package com.study.crm.workbench.web.controller;

import com.study.crm.settings.domain.User;
import com.study.crm.settings.service.UserService;
import com.study.crm.utils.DateTimeUtil;
import com.study.crm.utils.PrintJson;
import com.study.crm.utils.UUIDUtil;
import com.study.crm.vo.PaginationVO;
import com.study.crm.workbench.domain.*;
import com.study.crm.workbench.service.TransactionService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/workbench/transaction")
public class TransactionController {
    @Resource
    private TransactionService transactionService;
    @RequestMapping("/add.do")
    public ModelAndView add(){
        ModelAndView mv=new ModelAndView();
        List<User> userList=transactionService.getUserList();
        mv.addObject("userList",userList);
        mv.setViewName("/workbench/transaction/save.jsp");
        return mv;
    }
    @RequestMapping("/getCustomerName.do")
    public void getCustomerName(HttpServletResponse response,String name){
        List<String> stringList=transactionService.getCustomerName(name);
        PrintJson.printJsonObj(response,stringList);
    }
    @RequestMapping("/showActivityList.do")
    public void showActivityList(HttpServletResponse response){
        List<Activity> activityList=transactionService.showActivityList();
        PrintJson.printJsonObj(response,activityList);
    }
    @RequestMapping("/showActivityByName.do")
    public void showActivityByNameNotInClueId(HttpServletResponse response, String name){
        List<Activity> activityList=transactionService.showActivityByName(name);
        PrintJson.printJsonObj(response,activityList);
    }
    @RequestMapping("/showContactsList.do")
    public void showContactsList(HttpServletResponse response){
        List<Contacts> contactsList=transactionService.showContactsList();
        PrintJson.printJsonObj(response,contactsList);
    }
    @RequestMapping("/showContactsByName.do")
    public void showContactsByName(HttpServletResponse response, String name){
        List<Contacts> contactsList=transactionService.showContactsByName(name);
        PrintJson.printJsonObj(response,contactsList);
    }
    @RequestMapping("/save.do")
    public ModelAndView save(HttpServletRequest request,Tran tran, String customerName){
        ModelAndView mv=new ModelAndView();
        tran.setId(UUIDUtil.getUUID());
        tran.setCreateBy(((User)request.getSession().getAttribute("user")).getName());
        tran.setCreateTime(DateTimeUtil.getSysTime());
        boolean success=transactionService.save(tran,customerName);
        if (success){
            mv.setViewName("redirect:/workbench/transaction/index.jsp");
        }
        return mv;
    }
    @RequestMapping(value = "/pageList.do")
    @ResponseBody
    public void getPageList(HttpServletRequest request,HttpServletResponse response, Integer pageNo,
                            Integer pageSize,Tran tran) {
        //获取跳过的记录条数
        Integer skipNum=(pageNo-1)*pageSize;
        Map<String,Object> map=new HashMap<>();
        map.put("tran",tran);
        System.out.println("============"+request.getParameter("contactsName"));
        map.put("customerName",request.getParameter("customerName"));
        map.put("contactsName",request.getParameter("contactsName"));
        map.put("skipNum",skipNum);
        map.put("pageSize",pageSize);
        PaginationVO vo=transactionService.getPageList(map);
        PrintJson.printJsonObj(response,vo);
    }
    @RequestMapping("/deleteTran.do")
    public void deleteTran(HttpServletResponse response, @RequestParam("id[]")String[] ids){
        boolean success=transactionService.deleteTranByIds(ids);
        PrintJson.printJsonFlag(response,success);
    }
    @RequestMapping("/edit.do")
    public ModelAndView edit(String id){
        ModelAndView mv=new ModelAndView();
        List<User> userList=transactionService.getUserList();
        Tran tran=transactionService.getTranById(id);
        mv.addObject("userList",userList);
        mv.addObject("tran",tran);
        mv.setViewName("/workbench/transaction/edit.jsp");
        return mv;
    }
    @RequestMapping("/detail.do")
    public ModelAndView detail(HttpServletRequest request,String id){
        ModelAndView mv=new ModelAndView();
        Tran tran=transactionService.detail(id);
        Map<String,String> pmap= (Map<String, String>) request.getServletContext().getAttribute("pmap");
        String stage=tran.getStage();
        tran.setPossibility(pmap.get(stage));
        mv.addObject("t",tran);
        mv.setViewName("/workbench/transaction/detail.jsp");
        return mv;
    }
    @RequestMapping("/getHistoryListByTranId.do")
    public void getHistoryListByTranId(HttpServletRequest request,HttpServletResponse response ,String tranId){
        List<TranHistory> tranHistoryList=transactionService.getHistoryListByTranId(tranId);
        Map<String,String> pmap= (Map<String, String>) request.getServletContext().getAttribute("pmap");
        for (TranHistory th:tranHistoryList
             ) {
            String stage=th.getStage();
            th.setPossibility(pmap.get(stage));
        }
        PrintJson.printJsonObj(response,tranHistoryList);
    }
    @RequestMapping("/changeStage.do")
    public void changeStage(HttpServletRequest request,HttpServletResponse response,Tran t ){
        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        t.setEditBy(editBy);
        t.setEditTime(editTime);
        ServletContext application = request.getSession().getServletContext();
        Map<String ,String> pMap = (Map<String, String>) application.getAttribute("pmap");
        String possibility = pMap.get(t.getStage());
        t.setPossibility(possibility);
        boolean flag = transactionService.changeStage(t);
        Map<String ,Object> map=new HashMap<>();
        map.put("success",flag);
        map.put("t",t);
        PrintJson.printJsonObj(response,map);
    }
}
