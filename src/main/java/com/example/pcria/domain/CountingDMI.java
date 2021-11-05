package com.example.pcria.domain;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class CountingDMI extends FoodVO {
    private int totalPayment;
    private List<CountingDMI> countingList;
    private int total_quantity;
    private int total_price;
    private String food_request;
    private int u_no;
    private String payTime;

}
