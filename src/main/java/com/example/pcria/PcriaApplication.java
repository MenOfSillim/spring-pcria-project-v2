package com.example.pcria;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@MapperScan(value = {"com.example.pcria.mapper"})
@SpringBootApplication
public class PcriaApplication {

    public static void main(String[] args) {
        SpringApplication.run(PcriaApplication.class, args);
    }

}
