package com.swjd.service;

import com.swjd.bean.Customer;
import com.swjd.mapper.CustomerMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class CustomerImpl implements CustomerService{
    @Autowired
    CustomerMapper customerMapper;


    @Override
    public List<Customer> selectAll() {
        return customerMapper.getAll();
    }

    @Override
    public List<Customer> findForSearch(Map<String, String> map) {
        //当前是第几页
       String pageNum= map.get("pageNum");

       //获取每页的条数
        String rows=map.get("rows");
        int row=Integer.parseInt(rows);
        //如果没有收到page表示这是第一次访问（第一页）
        if (pageNum==null||pageNum.equals("")){
            pageNum="1";
        }
        int pageNum1=Integer.parseInt(pageNum);
        //计算开始的下标
        int start=(pageNum1-1)*row;
        return customerMapper.findForSearch(map,start,row);
    }

    @Override
    public int findForCount(Map<String, String> map) {
        return customerMapper.findForCount(map);
    }
}
