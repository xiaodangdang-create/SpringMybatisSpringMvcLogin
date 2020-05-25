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
}
