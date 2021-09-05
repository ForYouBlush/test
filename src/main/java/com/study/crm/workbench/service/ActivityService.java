package com.study.crm.workbench.service;

import com.study.crm.settings.domain.User;
import com.study.crm.vo.PaginationVO;
import com.study.crm.workbench.domain.Activity;
import com.study.crm.workbench.domain.ActivityRemark;

import java.util.List;
import java.util.Map;

public interface ActivityService {
    List<User> getUserList();

    boolean save(Activity activity);

    PaginationVO getPageList(Map<String, Object> map);

    boolean delete(String[] ids);

    Map<String, Object> getUserAndActivity(String id);

    boolean update(Activity activity);

    Activity getDetail(String id);

    List<ActivityRemark> getRemark(String id);

    boolean deleteRemark(String id);

    boolean updateRemark(ActivityRemark ar);

    boolean saveRemark(ActivityRemark ar);

    List<Activity> getActivityList();

    List<Activity> getActivityListByName(String name);
}
