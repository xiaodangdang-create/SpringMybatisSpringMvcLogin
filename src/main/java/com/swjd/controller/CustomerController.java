package com.swjd.controller;

import com.swjd.bean.Customer;
import com.swjd.service.CustomerImpl;
import com.swjd.service.CustomerService;
import com.swjd.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/customerController")
public class CustomerController {
    @Autowired
    CustomerService customerService;
    @Autowired
    UserService userService;

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

    //去新增页面
    @RequestMapping("/toAdd")
    public String toAdd(Model model){
        Customer customer=new Customer();
        model.addAttribute("customer",customer);
        return "add";
    }

    //做新增的方法
    @RequestMapping("/doAdd")
    public String doAdd(Customer customer, HttpSession session){
        //因为用户添加日期
        Date date=new Date();
        SimpleDateFormat format=new SimpleDateFormat("yyyy-MM-dd");
        String dateStr=format.format(date);
        customer.setCustomerDate(dateStr);

        //获取session里面存的登录名
        String uname=session.getAttribute("activeName").toString();
        int uid=userService.findUserId(uname);
        customer.setCustomerCreateId(uid);
        customer.setCustomerUserId(uid);

        //调用添加的方法
        int jg=customerService.addCustomer(customer);
        if (jg>0){
            return "redirect:/customerController/findForSearch";
        }else {
            return "redirect:/toAdd";
        }
    }
    //批量删除
    @RequestMapping("/doDelete")
    public String doDelete(@RequestParam("selectCustomerId") String[] selectCustomerId){
       /* System.out.println(selectCustomerId);
        */
       for (int i=0;i<selectCustomerId.length;i++){
           System.out.println("你好"+i);
       }
        int result=customerService.deleteCustomer(selectCustomerId);
        if (result>0){
            return "redirect:/customerController/findForSearch";
        }else {
            return "redirect:/customerController/findForSearch";
        }
    }

    /*修改*/
    @RequestMapping("/toUpdate")
    public String toUpdate(@RequestParam("selectCustomerId") int selectCustomerId,Model model){
        //调用单个查询的方法
        Customer customer=customerService.findById(selectCustomerId);
        model.addAttribute("customer",customer);
        return "update";
    }

    /*做修改*/
    @RequestMapping("/doUpdate")
    public String doUpdate(Customer customer){
        int result=customerService.updateCustomer(customer);
        if (result>0){
            return "redirect:/customerController/findForSearch";
        }else {
            return "redirect:/customerController/findForSearch";
        }
    }

}

