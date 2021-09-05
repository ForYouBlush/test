package com.study.crm.workbench.service.impl;

import com.study.crm.settings.dao.UserDao;
import com.study.crm.settings.domain.User;
import com.study.crm.utils.DateTimeUtil;
import com.study.crm.utils.UUIDUtil;
import com.study.crm.vo.PaginationVO;
import com.study.crm.workbench.dao.*;
import com.study.crm.workbench.domain.*;
import com.study.crm.workbench.service.ClueService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ClueServiceImpl implements ClueService {
    @Resource
    private ClueDao clueDao;
    @Resource
    private UserDao userDao;
    @Resource
    private ClueActivityRelationDao clueActivityRelationDao;
    @Resource
    private ActivityDao activityDao;
    @Resource
    private ContactsDao contactsDao;
    @Resource
    private CustomerDao customerDao;
    @Resource
    private TranDao tranDao;
    @Resource
    private TranHistoryDao tranHistoryDao;
    @Resource
    private ContactsActivityRelationDao contactsActivityRelationDao;
    @Resource
    private ContactsRemarkDao contactsRemarkDao;
    @Resource
    private ClueRemarkDao clueRemarkDao;
    @Resource
    private CustomerRemarkDao customerRemarkDao;


    @Override
    public List<User> getUserList() {
        List<User> userList=userDao.getUserList();
        return userList;
    }

    @Override
    public PaginationVO getPageList(Map<String, Object> map) {
        //获取总记录条数
        Integer total=clueDao.getTotalByCondition(map);
        //获取记录列表
        List<Clue> clueList=clueDao.getActivityListByCondition(map);
        //放入到vo中
        PaginationVO vo=new PaginationVO();
        vo.setDataList(clueList);
        vo.setTotal(total);
        return vo;
    }

    @Override
    public boolean saveClue(Clue clue) {
        boolean flag=false;
        int count=clueDao.saveClue(clue);
        if (count==1){
            flag=true;
        }
        return flag;
    }

    @Override
    public boolean deleteClue(String[] ids) {
        boolean flag=false;
        int count=clueDao.deleteClueByIds(ids);
        if (count==ids.length){
            flag=true;
        }
        return flag;
    }

    @Override
    public Map<String, Object> getUsersAndClue(String id) {
        List<User> userList=userDao.getUserList();
        Clue clue=clueDao.getClueById(id);
        Map<String,Object> map=new HashMap<>();
        map.put("userList",userList);
        map.put("clueList",clue);
        return map;
    }

    @Override
    public boolean updateClue(Clue clue) {
        boolean flag=false;
        int count=clueDao.updateClue(clue);
        if (count==1){
            flag=true;
        }
        return flag;
    }

    @Override
    public Clue getClueById(String id) {
        Clue clue=clueDao.detail(id);
        return clue;
    }

    @Override
    public List<Activity> getActivitysById(String id) {
        List<Activity> activityList=clueDao.getActivityListByid(id);
        return activityList;
    }

    @Override
    public boolean deleteRelationById(String id) {
        boolean flag=false;
        int count=clueActivityRelationDao.deleteRelationById(id);
        if (count==1){
            flag=true;
        }
        return flag;
    }

    @Override
    public List<Activity> showActivityNotInClueId(String id) {
        List<Activity> activityList=activityDao.showActivityNotInClueId(id);
        return activityList;
    }

    @Override
    public List<Activity> showActivityByNameNotInClueId(String name, String cid) {
        List<Activity> activityList=activityDao.showActivityByNameNotInClueId(name,cid);
        return activityList;
    }

    @Override
    public boolean bindActivity(String[] aid,String cid) {
        boolean flag=false;
        for (int i = 0; i <aid.length ; i++) {
            ClueActivityRelation clueActivityRelation=new ClueActivityRelation();
            clueActivityRelation.setActivityId(aid[i]);
            clueActivityRelation.setClueId(cid);
            clueActivityRelation.setId(UUIDUtil.getUUID());
            int count=clueActivityRelationDao.save(clueActivityRelation);
            if (count==1){
                flag=true;
            }
        }
        return flag;
    }

    @Override
    public boolean convert(String clueId, Tran t, String createBy) {
        String createTime= DateTimeUtil.getSysTime();

        boolean flag=true;

//        （1）通过线索id获取线索对象（线索当中封装了线索的信息）
        Clue c = clueDao.getByid(clueId);

//        （2）通过线索对象提取客户信息，当该客户不存在的时候，新建客户（根据公司的名称精确匹配，判断该客户是否存在）

        String company = c.getCompany();
        Customer cus = customerDao.getCustomerByName(company);
        if(cus==null){

//            说明以前没有这个客户 需要新建一个
            cus=new Customer();
            cus.setId(UUIDUtil.getUUID());
            cus.setAddress(c.getAddress());
            cus.setWebsite(c.getWebsite());
            cus.setPhone(c.getPhone());
            cus.setOwner(c.getOwner());
            cus.setNextContactTime(c.getNextContactTime());
            cus.setName(company);
            cus.setDescription(c.getDescription());
            cus.setCreateTime(createTime);
            cus.setCreateBy(createBy);
            cus.setContactSummary(c.getContactSummary());

//            添加客户
            int Count1 = customerDao.save(cus);
            if(Count1!=1)
            {
                flag=false;
            }
        }

//        （3）通过线索对象提取联系人信息，保存联系人(经过第二步之后客户对象已经有了，将来在处理其他表的时候，如果要使用客户的id，直接使用cus.id就可以了)
        Contacts con=new Contacts();
        con.setId(UUIDUtil.getUUID());
        con.setSource(c.getSource());
        con.setOwner(c.getOwner());
        con.setNextContactTime(c.getNextContactTime());
        con.setMphone(c.getMphone());
        con.setJob(c.getJob());
        con.setFullname(c.getFullname());
        con.setEmail(c.getEmail());
        con.setEditTime(c.getEditTime());
        con.setDescription(c.getDescription());
        con.setCustomerId(cus.getId());
        con.setCreateTime(createTime);
        con.setCreateBy(createBy);
        con.setContactSummary(c.getContactSummary());
        con.setAppellation(c.getAppellation());
        con.setAddress(c.getAddress());
//        添加联系人
        int Count2 = contactsDao.save(con);
        if(Count2 !=1){
            flag=false;
        }
//        经过第三步处理后，联系人的信息我们已经拥有了，将来在处理其他表的时候，如果要使用到联系人的id 直接使用con.getId

//        （4）线索备注转换到客户备注以及联系人备注
//        查询出与该线索关联的备注信息列表
        List<ClueRemark> clueRemarkList = clueRemarkDao.getListByClueId(clueId);
        //            取出每一条线索的备注
        for (ClueRemark clueRemark:clueRemarkList) {

//            取出备注信息
            String noteContent = clueRemark.getNoteContent();

//            创建客户备注对象，添加客户备注
            CustomerRemark customerRemark = new CustomerRemark();
            customerRemark.setId(UUIDUtil.getUUID());
            customerRemark.setCreateBy(createBy);
            customerRemark.setCreateTime(createTime);
            customerRemark.setCustomerId(cus.getId());
            customerRemark.setEditFlag("0");
            customerRemark.setNoteContent(noteContent);
            int Count3 = customerRemarkDao.save(customerRemark);
            if (Count3 != 1) {
                flag = false;
            }


//            创建联系人备注对象，添加联系人
            ContactsRemark contactsRemark = new ContactsRemark();
            contactsRemark.setId(UUIDUtil.getUUID());
            contactsRemark.setCreateBy(createBy);
            contactsRemark.setCreateTime(createTime);
            contactsRemark.setContactsId(con.getId());
            contactsRemark.setEditFlag("0");
            contactsRemark.setNoteContent(noteContent);
            int Count4 = contactsRemarkDao.save(contactsRemark);
            if (Count4 != 1) {
                flag = false;
            }
        }

//            （5）”线索和市场活动“ 的关系转换到”联系人和市场活动的关系“
//            查询出该条线索关联的市场活动，查询与市场活动的关联关系列表
        List<ClueActivityRelation> clueActivityRelationList = clueActivityRelationDao.getListByClueId(clueId);
//            遍历出每一条与市场活动关联的关联关系记录
        for(ClueActivityRelation clueActivityRelation :clueActivityRelationList){

//                从每一条遍历出来的记录中取出关联的市场活动id
            String activityId=clueActivityRelation.getActivityId();

            /*创建联系人与市场活动的关联关系对象 让第三步生成的联系人与市场活动做关联*/
            ContactsActivityRelation contactsActivityRelation =new ContactsActivityRelation();
            contactsActivityRelation.setId(UUIDUtil.getUUID());
            contactsActivityRelation.setActivityId(activityId);
            contactsActivityRelation.setContactsId(con.getId());
//                添加联系人与市场活动的关联关系
            int Count5 = contactsActivityRelationDao.save(contactsActivityRelation);
            if(Count5!=1){
                flag=false;
            }

        }

//            如果有创建交易需求，创建一条交易
        if(t!=null){

//            t对象在controller里面已经封装好的信息如下
//            id moner name expecteDate stage activityId createBy createTime，
//            可以通过第一步生成的c对象，取出一些信息，继续完成对t对象的封装
            t.setSource(c.getSource());
            t.setOwner(c.getOwner());
            t.setNextContactTime(c.getNextContactTime());
            t.setDescription(c.getDescription());
            t.setCustomerId(cus.getId());
            t.setContactSummary(c.getContactSummary());
            t.setContactsId(con.getId());
//            添加交易
            int Count6 = tranDao.save(t);
            if(Count6 != 1){
                flag = false;
            }

//        （7）如果创建了交易，则创建一条交易下的交易历史
            TranHistory tranHistory = new TranHistory();
            tranHistory.setId(UUIDUtil.getUUID());
            tranHistory.setCreateTime(createTime);
            tranHistory.setExpectedDate(t.getExpectedDate());
            tranHistory.setMoney(t.getMoney());
            tranHistory.setStage(t.getStage());
            tranHistory.setTranId(t.getId());
            tranHistory.setCreateBy(createBy);

//            添加交易历史
            int Count7 = tranHistoryDao.save(tranHistory);
            if(Count7!=1){
                flag=false;
            }
        }

//        (8)删除线索备注
        for (ClueRemark clueRemark:clueRemarkList) {

            int Count8 = clueRemarkDao.delete(clueRemark);
            if(Count8!=1){
                flag=false;
            }

        }

//        （9）删除线索和市场活动的关系
        for(ClueActivityRelation clueActivityRelation :clueActivityRelationList){


            int Count9=clueActivityRelationDao.delete(clueActivityRelation);
            if(Count9!=1){
                flag=false;
            }

        }

//        （10）删除线索
        int Count10 = clueDao.delete(clueId);
        if(Count10!=1){
            flag=false;
        }

        return flag;
    }

    @Override
    public boolean deleteClueById(String id) {
        boolean flag=false;
        int count=clueDao.delete(id);
        if (count==1){
            flag=true;
        }
        return flag;
    }

    @Override
    public List<ClueRemark> getRemark(String id) {
        List<ClueRemark> clueRemarks=clueRemarkDao.getListByClueId(id);
        return clueRemarks;
    }

    @Override
    public boolean deleteRemark(String id) {
        boolean flag=false;
        int count=clueRemarkDao.deleteRemarkById(id);
        if (count==1){
            flag=true;
        }
        return flag;
    }

    @Override
    public boolean updateRemark(ClueRemark cr) {
        boolean flag=false;
        int count=clueRemarkDao.updateRemark(cr);
        if (count==1){
            flag=true;
        }
        return flag;
    }

    @Override
    public boolean saveRemark(ClueRemark cr) {
        boolean flag=false;
        int count=clueRemarkDao.saveRemark(cr);
        if (count==1){
            flag=true;
        }
        return flag;
    }

}
