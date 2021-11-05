package com.example.pcria.domain;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AccessVO {
    private int u_no;
    private String u_id;
    private String u_name;
    private String u_password;
    private String u_birth;
    private int u_wallet;
    private String u_time;
    private String salt;

    //seat에서 사용하는 것들
    private int myUpdInsChk;
    private int s_no;
    private int s_occupied;

    //mypage에서 사용하는 것들
    private String u_profile;

    private String r_dt;
    private String m_dt;
    private String u_repassword;
    private String u_totalTime;
    private int u_totalPayment;
}
