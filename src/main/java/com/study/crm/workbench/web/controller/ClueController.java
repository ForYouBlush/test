package com.study.crm.workbench.web.controller;

import com.study.crm.settings.domain.User;
import com.study.crm.utils.DateTimeUtil;
import com.study.crm.utils.PrintJson;
import com.study.crm.utils.UUIDUtil;
import com.study.crm.vo.PaginationVO;
import com.study.crm.workbench.domain.Activity;
import com.study.crm.workbench.domain.Clue;
import com.study.crm.workbench.domain.ClueRemark;
import com.study.crm.workbench.domain.Tran;
import com.study.crm.workbench.service.ActivityService;
import com.study.crm.workbench.service.ClueService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/workbench/clue")
public class ClueController {
    @Resource
    private ClueService clueService;
    @Resource
    private ActivityService activityService;
    @RequestMapping("/getUserList.do")
    public void getUserList(HttpServletResponse response){
        List<User> userList=clueService.getUserList();
        //把userlist解析为字符串并输出
        PrintJson.printJsonObj(response,userList);
    }



    @RequestMapping(value = "/pageList.do")
    @ResponseBody
    public void getPageList(HttpServletResponse response, Integer pageNo,
                            Integer pageSize, Clue clue) {
        //获取跳过的记录条数
        Integer skipNum=(pageNo-1)*pageSize;
        Map<String,Object> map=new HashMap<>();
        map.put("clue",clue);
        map.put("skipNum",skipNum);
        map.put("pageSize",pageSize);
        PaginationVO vo=clueService.getPageList(map);
        PrintJson.printJsonObj(response,vo);
    }


    @RequestMapping("/saveClue.do")
    public void saveClue(HttpServletRequest request,HttpServletResponse response, Clue clue){
        clue.setId(UUIDUtil.getUUID());
        clue.setCreateBy(((User)request.getSession().getAttribute("user")).getName());
        clue.setCreateTime(DateTimeUtil.getSysTime());
        boolean success=clueService.saveClue(clue);
        //把userlist解析为字符串并输出
        PrintJson.printJsonFlag(response,success);
    }
    @RequestMapping("/deleteClue.do")
    public void deleteClue(HttpServletResponse response, @RequestParam("id[]") String[] ids){
       boolean success=clueService.deleteClue(ids);
       PrintJson.printJsonFlag(response,success);
    }
    @RequestMapping("/deleteClueById.do")
    public void deleteClueById(HttpServletResponse response,String id){
        boolean success=clueService.deleteClueById(id);
        PrintJson.printJsonFlag(response,success);
    }
    @RequestMapping("/edit.do")
    public void editClue(HttpServletResponse response, String id){
        Map<String,Object> map=clueService.getUsersAndClue(id);
        PrintJson.printJsonObj(response,map);
    }
    @RequestMapping("/updateClue.do")
    public void updateClue(HttpServletRequest request,HttpServletResponse response, Clue clue){
        clue.setEditBy(((User)request.getSession().getAttribute("user")).getName());
        clue.setEditTime(DateTimeUtil.getSysTime());
       boolean success=clueService.updateClue(clue);
       PrintJson.printJsonFlag(response,success);
    }
    @RequestMapping("/detail.do")
    @ResponseBody
    public ModelAndView detail( String id){
        ModelAndView mv=new ModelAndView();
       Clue clue=clueService.getClueById(id);
        mv.addObject("c",clue);
        mv.setViewName("/workbench/clue/detail.jsp");
        return mv;
    }
    @RequestMapping("/showActivity.do")
    public void showActivity(HttpServletResponse response, String id){
        List<Activity> activityList=clueService.getActivitysById(id);
        PrintJson.printJsonObj(response,activityList);
    }
    @RequestMapping(value = "/remark.do")
    @ResponseBody
    public void remark(HttpServletResponse response,String id)  {
        List<ClueRemark> clueRemarks=clueService.getRemark(id);
        PrintJson.printJsonObj(response,clueRemarks);
    }
    @RequestMapping(value = "/deleteRemark.do")
    @ResponseBody
    public void deleteRemark(HttpServletResponse response, String id) {
        boolean success=clueService.deleteRemark(id);
        PrintJson.printJsonFlag(response,success);
    }
    @RequestMapping(value = "/updateRemark.do")
    @ResponseBody
    public void updateRemark(HttpServletRequest request,HttpServletResponse response,ClueRemark cr) {
        cr.setEditTime(DateTimeUtil.getSysTime());
        cr.setEditFlag("1");
        cr.setEditBy(((User)request.getSession().getAttribute("user")).getName());
        boolean success=clueService.updateRemark(cr);
        Map<String,Object> map=new HashMap<>();
        map.put("success",success);
        map.put("cr",cr);
        PrintJson.printJsonObj(response,map);
    }

    @RequestMapping(value = "/saveRemark.do")
    @ResponseBody
    public void saveRemark(HttpServletRequest request,HttpServletResponse response,ClueRemark cr) {
        cr.setCreateTime(DateTimeUtil.getSysTime());
        cr.setId(UUIDUtil.getUUID());
        cr.setEditFlag("0");
        cr.setCreateBy(((User)request.getSession().getAttribute("user")).getName());
        boolean success=clueService.saveRemark(cr);
        Map<String,Object> map=new HashMap<>();
        map.put("success",success);
        map.put("cr",cr);
        PrintJson.printJsonObj(response,map);
    }
    @RequestMapping("/unbind.do")
    public void unbind(HttpServletResponse response, String id){
        boolean success=clueService.deleteRelationById(id);
        PrintJson.printJsonFlag(response,success);
    }
    @RequestMapping("/showActivityNotInClueId.do")
    public void showActivityNotInClueId(HttpServletResponse response, String id){
        List<Activity> activityList=clueService.showActivityNotInClueId(id);
        PrintJson.printJsonObj(response,activityList);
    }

    @RequestMapping("/showActivityByNameNotInClueId.do")
    public void showActivityByNameNotInClueId(HttpServletResponse response, String name,String cid){
        List<Activity> activityList=clueService.showActivityByNameNotInClueId(name,cid);
        PrintJson.printJsonObj(response,activityList);
    }
    @RequestMapping("/bindActivity.do")
    public void bindActivity(HttpServletResponse response,@RequestParam("aid[]") String[] aid,String cid){
        boolean success=clueService.bindActivity(aid,cid);
        PrintJson.printJsonFlag(response,success);
    }
    @RequestMapping("/getActivityList.do")
    public void getActivityList(HttpServletResponse response){
        List<Activity> activityList=activityService.getActivityList();
        PrintJson.printJsonObj(response,activityList);
    }
    @RequestMapping("/getActivityListByName.do")
    public void getActivityListByName(HttpServletResponse response,String name){
        List<Activity> activityList=activityService.getActivityListByName(name);
        PrintJson.printJsonObj(response,activityList);
    }
    @RequestMapping("/convert.do")
    @ResponseBody
    public ModelAndView convert(String clueId,HttpServletRequest request){
        Tran t=null;
        ModelAndView mv=new ModelAndView();
        String createBy=((User)request.getSession().getAttribute("user")).getName();
        String flag=request.getParameter("flag");
        if("a".equals(flag)){
//            接受交易表单中的数据
            t=new Tran();
            String money=request.getParameter("money");
            String name=request.getParameter("name");
            String expectedDate=request.getParameter("expectedDate");
            String stage=request.getParameter("stage");
            String activityId=request.getParameter("activityId");
            String id=UUIDUtil.getUUID();
            String createTime= DateTimeUtil.getSysTime();
            t.setId(id);
            t.setCreateTime(createTime);
            t.setCreateBy(createBy);
            t.setMoney(money);
            t.setName(name);
            t.setExpectedDate(expectedDate);
            t.setStage(stage);
            t.setActivityId(activityId);
        }
        /*业务层传递的参数
         * 1.必须传递的参数clueId，有了这个后我们才知道转换哪条记录
         * 2.必须传递参数t，因为在线索转换的过程中，有可能会临时创建一笔交易（业务层的t也有可能是null）*/
        boolean flag1=clueService.convert(clueId,t,createBy);
        if(flag1)
        {
            mv.setViewName("redirect:/workbench/clue/index.jsp");
        }
        mv.addObject(flag1);
        return mv;
    }
}
