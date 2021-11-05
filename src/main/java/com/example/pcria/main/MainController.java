package com.example.pcria.main;

import com.example.pcria.Const;
import com.example.pcria.SecurityUtils;
import com.example.pcria.access.AccessService;
import com.example.pcria.domain.AccessVO;
import com.example.pcria.domain.FoodVO;
import com.example.pcria.domain.SeatDMI;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/main")
public class MainController {

    @Autowired
    private MainService service;

    @Autowired
    private AccessService accService;

    @RequestMapping(value = "/seat", method = RequestMethod.GET)
    public String seat(Model model, HttpSession hs, AccessVO param) {

        model.addAttribute("data", accService.userInfo(param, hs));
        model.addAttribute(Const.MENU_ID, "seat");
        model.addAttribute(Const.VIEW, "main/seat");
        model.addAttribute(Const.CSS, "main/seat");

        return "/template/mainTemplate";
    }
    @RequestMapping(value = "/usageTime", method = RequestMethod.GET)
    public String usageTime(Model model, HttpSession hs, AccessVO param) {

        model.addAttribute("data", accService.userInfo(param, hs));
        model.addAttribute(Const.MENU_ID, "usageTime");
        model.addAttribute(Const.VIEW, "main/usageTime");
        model.addAttribute(Const.CSS, "main/usageTime");

        return "/template/mainTemplate";
    }
    @RequestMapping(value = "/food", method = RequestMethod.GET)
    public String food(Model model) {

        model.addAttribute(Const.MENU_ID, "foodOrder");
        model.addAttribute(Const.FOOD_MENU_ID, "chk_8");
        model.addAttribute(Const.VIEW, "main/food");
        model.addAttribute(Const.CSS, "main/food");

        return "/template/mainTemplate";
    }
    @RequestMapping(value = "/foodAjax", method = RequestMethod.GET, produces = "application/json; charset=utf8")
    public @ResponseBody
    List<FoodVO> foodAjax(FoodVO param, HttpSession hs) {
        return service.selFoodList(param);
    }

    @RequestMapping(value = "/ajaxSelSeat", method = RequestMethod.GET, produces = "application/json; charset=utf8")
    public @ResponseBody
    SeatDMI ajaxSelSeat(HttpSession hs) {
        SeatDMI seatDMI = new SeatDMI();
        int u_no = SecurityUtils.getLoginUserPk(hs);
        seatDMI.setAjaxSelSeat(service.selSeat());
        //내가 예약한 좌석값 가져오기
        for (int i = 0; i < seatDMI.getAjaxSelSeat().size(); i++) {
            if(seatDMI.getAjaxSelSeat().get(i).getU_no() == u_no) {
                seatDMI.setMyS_no(seatDMI.getAjaxSelSeat().get(i).getS_no());
                seatDMI.setMyS_occupied(seatDMI.getAjaxSelSeat().get(i).getS_occupied());
                seatDMI.setMyS_val(seatDMI.getAjaxSelSeat().get(i).getS_val());
            }
        }
        return seatDMI;
    }
    @RequestMapping(value = "/ajaxUpdSeat", method = RequestMethod.POST)
    public @ResponseBody int ajaxUpdSeat(@RequestBody SeatDMI param, HttpSession hs) {
        param.setU_no(SecurityUtils.getLoginUserPk(hs));
        //로그인 세션에 넣기
        AccessVO loginUser = SecurityUtils.getLoginUser(hs);
        loginUser.setS_occupied(param.getS_occupied());
        loginUser.setS_no(param.getS_no());
        if(param.getMyUpdInsChk() == 1) {
            loginUser.setMyUpdInsChk(1);
            service.updSeat(param);
            return 1;
        }else if(param.getMyUpdInsChk() == 0){
            service.insSeat(param);
            loginUser.setMyUpdInsChk(1);
            return 2;
        }else {
            return 3;
        }
    }
    //프로필 처음 입장 시 등록일자, 수정일자, 사용금액 등 가져오기
    @RequestMapping(value = "/ajaxSelMyInfo", method = RequestMethod.GET, produces = "application/json; charset=utf8")
    public @ResponseBody AccessVO ajaxSelMyInfo(HttpSession hs) {
        return service.ajaxSelMyInfo(SecurityUtils.getLoginUserPk(hs));
    }
    //프로필 처음 입장 시 현재까지 주문 내역 가져오기
    @RequestMapping(value = "/ajaxSelMyOrderList", method = RequestMethod.GET, produces = "application/json; charset=utf8")
    public @ResponseBody List<FoodVO> ajaxSelMyOrderList(HttpSession hs) {
        return service.ajaxSelMyOrderList(SecurityUtils.getLoginUserPk(hs));
    }

    @RequestMapping(value = "/profile", method = RequestMethod.GET)
    public String profile(Model model) {

        model.addAttribute(Const.MENU_ID, "profile");
        model.addAttribute(Const.VIEW, "main/profile");
        model.addAttribute(Const.CSS, "main/profile");

        return "/template/mainTemplate";
    }

    @RequestMapping(value = "/profile", method = RequestMethod.POST)
    public String profile(MultipartHttpServletRequest mreq, AccessVO param , HttpSession hs, RedirectAttributes ra) {
        ra.addFlashAttribute("result", service.updProfile(mreq, param, hs));
        return "redirect:/main/profile";

    }
}
