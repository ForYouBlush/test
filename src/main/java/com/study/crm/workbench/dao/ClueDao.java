package com.study.crm.workbench.dao;

import com.study.crm.workbench.domain.Activity;
import com.study.crm.workbench.domain.Clue;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface ClueDao {


    Integer getTotalByCondition(Map<String, Object> map);

    List<Clue> getActivityListByCondition(Map<String,Object> map);

    int saveClue(Clue clue);

    int deleteClueByIds(String[] ids);

    Clue getClueById(String id);

    int updateClue(Clue clue);

    Clue detail(String id);

    List<Activity> getActivityListByid(String id);

    Clue getByid(String clueId);

    int delete(String clueId);

}
