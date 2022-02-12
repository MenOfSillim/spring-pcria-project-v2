package com.example.pcria;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;

@Slf4j
@Controller
public class IndexController {

    @RequestMapping("/")
    public String index(HttpServletRequest req) {
        if (Const.realPath == null) {
            Const.realPath = req.getServletContext().getRealPath("");
            log.info(">> real path check :: {}", Const.realPath);
        }
        log.info(">> IndexController 경유");

        return "redirect:/access/login";
    }

    @RequestMapping("log-demo")
    @ResponseBody
    public String logDemo(HttpServletRequest request) {
        System.out.println("IndexController.logDemo");
        return "OK";
    }
}
