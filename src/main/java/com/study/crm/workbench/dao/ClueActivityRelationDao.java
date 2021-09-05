package com.study.crm.workbench.dao;

import com.study.crm.workbench.domain.ClueActivityRelation;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ClueActivityRelationDao {


    int deleteRelationById(String id);

    int save(ClueActivityRelation clueActivityRelation);

    List<ClueActivityRelation> getListByClueId(String clueId);

    int delete(ClueActivityRelation clueActivityRelation);
}
