package com.study.crm.workbench.service;

import com.study.crm.settings.domain.User;
import com.study.crm.vo.PaginationVO;
import com.study.crm.workbench.domain.Activity;
import com.study.crm.workbench.domain.Clue;
import com.study.crm.workbench.domain.ClueRemark;
import com.study.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface ClueService {
    List<User> getUserList();

    PaginationVO getPageList(Map<String, Object> map);

    boolean saveClue(Clue clue);

    boolean deleteClue(String[] ids);

    Map<String, Object> getUsersAndClue(String id);

    boolean updateClue(Clue clue);

    Clue getClueById(String id);

    List<Activity> getActivitysById(String id);

    boolean deleteRelationById(String id);

    List<Activity> showActivityNotInClueId(String id);

    List<Activity> showActivityByNameNotInClueId(String name, String cid);

    boolean bindActivity(String[] aid,String cid);

    boolean convert(String clueId, Tran t, String createBy);

    boolean deleteClueById(String id);

    List<ClueRemark> getRemark(String id);

    boolean deleteRemark(String id);

    boolean updateRemark(ClueRemark cr);

    boolean saveRemark(ClueRemark cr);
}
