package com.example.pcria.domain;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class SeatDMI extends SeatVO{
    private int myS_no;
    private int myS_occupied;
    private int myUpdInsChk;
    private String myS_val;
    private String u_time;

    private List<SeatDMI> ajaxSelSeat;

}
