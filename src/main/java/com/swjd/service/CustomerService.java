package com.swjd.service;

import com.swjd.bean.Customer;


import java.util.List;
import java.util.Map;


public interface CustomerService {
    public abstract List<Customer> selectAll();

    //条件分页
    public abstract List<Customer> findForSearch(Map<String,String> map);

    //总计录数
    public abstract int findForCount(Map<String,String> map);

    //新增
    public abstract int addCustomer(Customer customer);

    //批量删除的方法
    public abstract int deleteCustomer(String[] ids);

    //单个查询
    public abstract Customer findById(int id);

    //修改
    public abstract int updateCustomer(Customer customer);
}
