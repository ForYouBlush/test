package com.study.crm.workbench.dao;

import com.study.crm.workbench.domain.Activity;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface ActivityDao {

    int saveActivity(Activity activity);

    Integer getTotalByCondition(Map<String, Object> map);

    List<Activity> getActivityListByCondition(Map<String, Object> map);

    int deleteByid(String[] ids);

    Activity getActivityById(String id);

    int updateActivity(Activity activity);

    Activity getDetail(String id);

    List<Activity> showActivityNotInClueId(String id);

    List<Activity> showActivityByNameNotInClueId(@Param("name") String name, @Param("cid") String cid);

    List<Activity> getAll();

    List<Activity> getActivityListByName(String name);

    List<Activity> showActivityList();

    List<Activity> getActivityListLikeName(String name);
}
