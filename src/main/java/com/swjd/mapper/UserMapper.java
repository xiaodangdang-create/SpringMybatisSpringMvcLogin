package com.swjd.mapper;

import com.swjd.bean.User;

public interface UserMapper {
    public abstract User findUserByUnamePwd(User user);
    //登录名查询id
    public abstract int findUserId(String userName);
}
