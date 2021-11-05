package com.example.pcria;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;

@Controller
public class IndexController {
    @RequestMapping("/")
    public String index(HttpServletRequest req) {
        if (Const.realPath == null) {
            Const.realPath = req.getServletContext().getRealPath("");
            System.out.println(Const.realPath);
        }
        System.out.println("IndexController");
        return "redirect:/access/login";
    }
}
