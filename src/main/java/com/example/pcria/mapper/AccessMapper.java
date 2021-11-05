package com.example.pcria.mapper;

import com.example.pcria.domain.AccessVO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface AccessMapper {
    public AccessVO selUser(AccessVO param);
    public int insUser(AccessVO param);
}
