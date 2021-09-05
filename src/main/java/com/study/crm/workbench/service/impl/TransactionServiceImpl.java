package com.study.crm.workbench.service.impl;

import com.study.crm.settings.dao.UserDao;
import com.study.crm.settings.domain.User;
import com.study.crm.utils.DateTimeUtil;
import com.study.crm.utils.UUIDUtil;
import com.study.crm.vo.PaginationVO;
import com.study.crm.workbench.dao.*;
import com.study.crm.workbench.domain.*;
import com.study.crm.workbench.service.TransactionService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class TransactionServiceImpl implements TransactionService {
    @Resource
    UserDao userDao;
    @Resource
    CustomerDao customerDao;
    @Resource
    ActivityDao activityDao;
    @Resource
    ContactsDao contactsDao;
    @Resource
    TranDao tranDao;
    @Resource
    TranHistoryDao tranHistoryDao;
    @Override
    public List<User> getUserList() {
        List<User> userList=userDao.getUserList();
        return userList;
    }

    @Override
    public List<String> getCustomerName(String name) {
        List<String> stringList=customerDao.getCustomerLikeName(name);
        return stringList;
    }

    @Override
    public List<Activity> showActivityList() {
        List<Activity> activityList=activityDao.showActivityList();
        return activityList;
    }

    @Override
    public List<Activity> showActivityByName(String name) {
        List<Activity> activityList=activityDao.getActivityListLikeName(name);
        return activityList;
    }

    @Override
    public List<Contacts> showContactsList() {
        List<Contacts> contactsList=contactsDao.getAll();
        return contactsList;
    }

    @Override
    public List<Contacts> showContactsByName(String name) {
        List<Contacts> contactsList=contactsDao.getContactsLikeName(name);
        return contactsList;
    }

    @Override
    @Transactional
    public boolean save(Tran tran, String customerName) {
        boolean flag=false;
        //通过name获取客户id
        if (!"".equals(customerName)){

            Customer customer=customerDao.getCustomerByName(customerName);
            if (customer==null){
                customer=new Customer();
                customer.setName(customerName);
                customer.setId(UUIDUtil.getUUID());
                customer.setCreateBy(tran.getCreateBy());
                customer.setOwner(tran.getOwner());
                customer.setNextContactTime(tran.getNextContactTime());
                customer.setCreateTime(tran.getCreateTime());
                customerDao.save(customer);
            }
            tran.setCustomerId(customer.getId());
        }
        //添加交易
        tranDao.save(tran);
        //添加交易历史
        TranHistory tranHistory=new TranHistory();
        tranHistory.setCreateBy(tran.getCreateBy());
        tranHistory.setId(UUIDUtil.getUUID());
        tranHistory.setCreateTime(tran.getCreateTime());
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setStage(tran.getStage());
        tranHistory.setTranId(tran.getId());
        int count=tranHistoryDao.save(tranHistory);
        if (count==1){
            flag=true;
        }
        return flag;
    }

    @Override
    public PaginationVO getPageList(Map<String, Object> map) {
        //获取总记录条数
        Integer total=tranDao.getTotalByCondition(map);
        //获取记录列表
        List<Tran> tranList=tranDao.getTranListByCondition(map);
        //放入到vo中
        PaginationVO vo=new PaginationVO();
        vo.setDataList(tranList);
        vo.setTotal(total);
        return vo;
    }

    @Override
    public boolean deleteTranByIds(String[] ids) {
        boolean flag=false;
        int count=tranDao.deleteTranByIds(ids);
        if (count==ids.length){
            flag=true;
        }
        return flag;
    }

    @Override
    public Tran getTranById(String id) {
        Tran tran=tranDao.getTranById(id);
        return tran;
    }

    @Override
    public Tran detail(String id) {
        Tran tran=tranDao.getTranById(id);
        return tran;
    }

    @Override
    public List<TranHistory> getHistoryListByTranId(String tranId) {
        List<TranHistory> tranHistoryList=tranHistoryDao.getHistoryListByTranId(tranId);
        return tranHistoryList;
    }

    @Override
    public boolean changeStage(Tran t) {
        boolean flag =  true;

        int Count1 = tranDao.changeStage(t);

        if(Count1!=1){
            flag=false;
        }
//        交易阶段改变后，生成一条交易历史
        TranHistory th = new TranHistory();
        th.setId(UUIDUtil.getUUID());
        th.setCreateBy(t.getEditBy());
        th.setCreateTime(DateTimeUtil.getSysTime());
        th.setExpectedDate(t.getExpectedDate());
        th.setMoney(t.getMoney());
        th.setTranId(t.getId());
        th.setStage(t.getStage());
        th.setPossibility(t.getPossibility());

//        添加交易历史
        int Count2 = tranHistoryDao.save(th);
        if (Count2!=1){
            flag = false;
        }
        return flag;
    }
}
