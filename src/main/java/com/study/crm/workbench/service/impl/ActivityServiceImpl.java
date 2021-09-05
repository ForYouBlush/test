package com.study.crm.workbench.service.impl;

import com.study.crm.settings.dao.UserDao;
import com.study.crm.settings.domain.User;
import com.study.crm.vo.PaginationVO;
import com.study.crm.workbench.dao.ActivityDao;
import com.study.crm.workbench.dao.ActivityRemarkDao;
import com.study.crm.workbench.domain.Activity;
import com.study.crm.workbench.domain.ActivityRemark;
import com.study.crm.workbench.service.ActivityService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ActivityServiceImpl implements ActivityService {
    @Resource
    private UserDao userdao;
    @Resource
    private ActivityDao activityDao;
    @Resource
    private ActivityRemarkDao activityRemarkDao;
    @Override
    public List<User> getUserList() {
        List<User> userList=userdao.getUserList();
        return userList;
    }

    @Override
    public boolean save(Activity activity) {
        boolean flag=true;
        int count=activityDao.saveActivity(activity);
        if (count!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public PaginationVO getPageList(Map<String, Object> map) {
        //获取总记录条数
        Integer total=activityDao.getTotalByCondition(map);
        //获取记录列表
        List<Activity> activityList=activityDao.getActivityListByCondition(map);
        //放入到vo中
        PaginationVO vo=new PaginationVO();
        vo.setDataList(activityList);
        vo.setTotal(total);
        return vo;
    }

    @Override
    public boolean delete(String[] ids) {
        boolean flag=true;
        //查询需要删除的备注的数量
        int count1=activityRemarkDao.getCountById(ids);
        //删除备注，返回受到影响的记录条数（实际删除的数量）
        int count2=activityRemarkDao.deleteById(ids);
        if (count1!=count2){
            flag=false;
        }
        //删除市场活动
        int count3=activityDao.deleteByid(ids);
        if (count3!=ids.length){
            flag=false;
        }
        return flag;
    }

    @Override
    public Map<String, Object> getUserAndActivity(String id) {
        //获取userList
        List<User> userList=userdao.getUserList();
        //获取Activity单条
        Activity activity=activityDao.getActivityById(id);
        Map<String,Object> map=new HashMap<>();
        map.put("a",activity);
        map.put("userList",userList);
        return map;
    }

    @Override
    public boolean update(Activity activity) {
        boolean flag=true;
        int count=activityDao.updateActivity(activity);
        if (count!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public Activity getDetail(String id) {
        Activity a=activityDao.getDetail(id);
        return a;
    }

    @Override
    public List<ActivityRemark> getRemark(String id) {
        List<ActivityRemark> arList=activityRemarkDao.getRemark(id);
        return arList;
    }

    @Override
    public boolean deleteRemark(String id) {
        boolean flag=false;
        int count=activityRemarkDao.deleteRemarkById(id);
        if (count==1){
            flag=true;
        }
        return flag;
    }

    @Override
    public boolean updateRemark(ActivityRemark ar) {
        boolean flag=false;
        int count=activityRemarkDao.updateRemark(ar);
        if (count==1){
            flag=true;
        }
        return flag;
    }

    @Override
    public boolean saveRemark(ActivityRemark ar) {
        boolean flag=false;
        int count=activityRemarkDao.saveRemark(ar);
        if (count==1){
            flag=true;
        }
        return flag;
    }

    @Override
    public List<Activity> getActivityList() {
        List<Activity> activityList=activityDao.getAll();
        return activityList;
    }

    @Override
    public List<Activity> getActivityListByName(String name) {
        List<Activity> activityList=activityDao.getActivityListByName(name);
        return activityList;
    }
}
