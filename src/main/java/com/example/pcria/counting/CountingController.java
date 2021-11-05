package com.example.pcria.counting;

import com.example.pcria.SecurityUtils;
import com.example.pcria.access.AccessService;
import com.example.pcria.domain.AccessVO;
import com.example.pcria.domain.CountingDMI;
import com.example.pcria.domain.CountingVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/count")
public class CountingController {

    @Autowired
    private CountingService couService;

    @Autowired
    private AccessService accService;

    @RequestMapping(value = "/time", method = RequestMethod.POST)
    public String time(CountingVO param, HttpSession hs, RedirectAttributes ra) {
        param.setU_no(SecurityUtils.getLoginUserPk(hs));

        AccessVO vo = new AccessVO();
        vo = accService.userInfo(param, hs);
        String msg = "";
        if(vo.getU_wallet() < param.getU_wallet()) {
            msg = "잔액이 부족합니다.";
            ra.addFlashAttribute("msg", msg);
            return "redirect:/main/usageTime";
        }

        int result = couService.updTime(param);
        if(result != 1) {
            msg = "결제에 실패했습니다.";
            ra.addFlashAttribute("msg", msg);
        }
        return "redirect:/main/usageTime";
    }

    @RequestMapping(value = "/ajaxDiscTime", method = RequestMethod.POST)
    public @ResponseBody
    String discTimeAjax(@RequestBody CountingVO param, HttpSession hs) {
        AccessVO loginUser = accService.userInfo(param, hs);
        param.setU_no(loginUser.getU_no());

        // 시간을 하나의 문자열로 변환
        String time = loginUser.getU_time();
        String timeArr[] = time.split(":");
        time = timeArr[0] + timeArr[1] + timeArr[2];

        int curr_time = Integer.parseInt(time);
        if(curr_time % 10000 == 0) {
            param.setU_time("4100"); // 정각일 경우 59분으로 감소
        } else {
            param.setU_time("100"); // 정각이 아닐 경우 1분 감소
        }
        int result = couService.discTime(param);
        loginUser = accService.userInfo(param, hs); // 감소한 시간을 넣기위한 갱신
        return loginUser.getU_time();
    }

    @RequestMapping(value = "/coinAjax", method = RequestMethod.POST)
    public @ResponseBody AccessVO coinAjax(@RequestBody CountingVO param, HttpSession hs) {
        int u_no = SecurityUtils.getLoginUserPk(hs);
        param.setU_no(u_no);

        int result = couService.updWallet(param);

        AccessVO vo = new AccessVO();
        vo = accService.userInfo(param, hs);

        return vo;
    }

    @RequestMapping(value = "/foodAjax", method = RequestMethod.POST)
    public @ResponseBody int foodAjax(@RequestBody CountingDMI param, HttpSession hs, RedirectAttributes ra) {
//		System.out.println("총 계산 금액 : "+param.getTotalPayment());
//		System.out.println("요청 사항 : "+param.getFood_request());

        int moneyToTime = param.getTotalPayment() * 5 / 100;
        int hour = moneyToTime / 60 * 10000;
        int minute = (moneyToTime % 60) * 100;
        int timePayment = hour + minute; // 구매할 음식을 시간으로 환산
        System.out.println("금액을 시간으로 환산 : " + timePayment);

        AccessVO vo = new AccessVO(); // 세션이 아닌 DB에 담긴 유저 정보를 확인하기 위함
        int u_no = SecurityUtils.getLoginUserPk(hs);
        vo.setU_no(u_no);
        vo = accService.userInfo(vo, hs);

        String time = vo.getU_time();
        String timeArr[] = time.split(":");
        time = timeArr[0] + timeArr[1] + timeArr[2];
        int curr_time = Integer.parseInt(time); // 현재 잔여 시간

        String msg = "";
        String str_time = "";

        if(curr_time < timePayment) {
            msg = "잔여 시간이 부족합니다";
            ra.addAttribute("msg", msg);
            return 2;
        } else {
            if(curr_time % 10000 < timePayment % 10000) {
                timePayment += 4000;
                System.out.println("경우 1 : " + timePayment);
                str_time = String.valueOf(timePayment);
                param.setPayTime(str_time);
            } else {
                str_time = String.valueOf(timePayment);
                System.out.println("경우 2 : " + timePayment);
                param.setPayTime(str_time); // 정각이 아닐 경우 1분 감소
            }
        }

        for (int j = 0; j < param.getCountingList().size(); j++) {
            param.getCountingList().get(j).setU_no(u_no);
//			System.out.print("seq : "+param.getCountingList().get(j).getSeq()+",");
//			System.out.print("i_f : "+param.getCountingList().get(j).getI_f()+",");
//			System.out.print("f_name : "+param.getCountingList().get(j).getF_name()+",");
//			System.out.print("total_quantity : "+param.getCountingList().get(j).getTotal_quantity()+",");
//			System.out.print("total_price : "+param.getCountingList().get(j).getTotal_price());
//			System.out.println();

//			if(vo.getU_wallet() < param.getTotalPayment()) {
//				msg = "잔액이 부족합니다";
//				ra.addAttribute("msg", msg);
//				return 2;
//			}

            int result = couService.selFood(param.getCountingList().get(j));
            if(result == 0) { // 처음 구매하는 음식
                couService.newFood(param.getCountingList().get(j));
            } else if(result == 1) { // 구매한적 있는 음식
                couService.addFood(param.getCountingList().get(j));
            }
        }

        param.setU_no(u_no);
        int result = couService.payFood(param);

        return result;
    }
}
