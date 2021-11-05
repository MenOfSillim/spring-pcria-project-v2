package com.example.pcria.counting;

import com.example.pcria.domain.CountingDMI;
import com.example.pcria.domain.CountingVO;
import com.example.pcria.mapper.CountingMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CountingService {

    @Autowired
    private CountingMapper mapper;

    public int selFood(CountingDMI param) {
        CountingDMI dbFood = mapper.selFood(param);
        if(dbFood == null) { // 해당 음식 시킨적 없음 - insert
            return 0;
        } // 해당 음식 시킨적 있음 - update
        return 1;
    }

    // 시간 구매
    public int updTime(CountingVO param) {
        return mapper.updTime(param);
    }

    // 시간 차감
    public int discTime(CountingVO param) {
        return mapper.discTime(param);
    }

    // 잔액 충전
    public int updWallet(CountingVO param) {
        return mapper.updWallet(param);
    }

    // 음식 구매
    public int payFood(CountingDMI param) {
        int result = mapper.payFood(param);
        return result;
    }

    // 처음 시키는 음식
    public int newFood(CountingDMI param) {
        return mapper.newFood(param);
    }

    // 늘 먹던 음식
    public int addFood(CountingDMI param) {
        return mapper.addFood(param);
    }
}
