package com.example.pcria.domain;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class  FoodVO {
    private int seq;
    private int i_f;
    private int f_price;
    private String f_pic;
    private String f_name;
    private int chk;

    //프로필 정보 관련 조회
    private int total_quantity;
}
