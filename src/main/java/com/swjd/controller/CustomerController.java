package com.swjd.controller;

import com.swjd.bean.Customer;
import com.swjd.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/customerController")
public class CustomerController {
    @Autowired
    CustomerService customerService;

    @RequestMapping("/toIndex")
    public String a(Model model){
        List<Customer> list=new ArrayList<>();
        list=customerService.selectAll();
        Customer customer=new Customer();
        model.addAttribute("list",list);
        model.addAttribute("customer",customer);
        return "index";
    }
    @RequestMapping("/findForSearch")
    public String findForSearch(@RequestParam Map<String,String> param, Model model, ModelMap modelMap){
      //第三次（查按条件查出来的数据的第二页）
        //拿第二次输入的条件
        String customerName=param.get("customerName");
        String customerId=param.get("customerId");
        if (customerId==null||customerId.equals("")){
            customerId="0";
        }
        String customerSourse=param.get("customerSourse");
        String customerDateBegin=param.get("customerDateBegin");
        model.addAttribute("customerDateBegin",customerDateBegin);
        String customerDateEnd=param.get("customerDateEnd");
        model.addAttribute("customerDateEnd",customerDateEnd);



       //第二次进来（param就已经有内容）



        //第一次
        //每页显示的数据条数
        String rows="5";
        param.put("rows",rows);
        //查询出来的数据
        List<Customer> list=customerService.findForSearch(param);
        //总条数
        int totalRows=customerService.findForCount(param);
        //当前页数
        String pageNum=param.get("pageNum");
        if (pageNum==null){
            pageNum="1";
        }

        //总页数
        int totalPage=0;
        if (totalRows%Integer.parseInt(rows)==0){
            totalPage=totalRows/Integer.parseInt(rows);
        }else {
            totalPage=totalRows/Integer.parseInt(rows)+1;
        }

        modelMap.put("list",list);
        modelMap.put("totalRows",totalRows);
        modelMap.put("totalPage",totalPage);
        modelMap.put("pageNum",pageNum);
        Customer customer=new Customer();
        customer.setCustomerName(customerName);
        customer.setCustomerId(Integer.parseInt(customerId));
        customer.setCustomerSourse(customerSourse);
        model.addAttribute("customer",customer);
        return "index";
    }
}

