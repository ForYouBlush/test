package com.study.crm.workbench.service;

import com.study.crm.settings.domain.User;
import com.study.crm.vo.PaginationVO;
import com.study.crm.workbench.domain.Activity;
import com.study.crm.workbench.domain.Contacts;
import com.study.crm.workbench.domain.Tran;
import com.study.crm.workbench.domain.TranHistory;

import java.util.List;
import java.util.Map;

public interface TransactionService {
    List<User> getUserList();

    List<String> getCustomerName(String name);

    List<Activity> showActivityList();

    List<Activity> showActivityByName(String name);

    List<Contacts> showContactsList();

    List<Contacts> showContactsByName(String name);

    boolean save(Tran tran, String customerName);

    PaginationVO getPageList(Map<String, Object> map);

    boolean deleteTranByIds(String[] ids);

    Tran getTranById(String id);

    Tran detail(String id);

    List<TranHistory> getHistoryListByTranId(String tranId);

    boolean changeStage(Tran t);
}
