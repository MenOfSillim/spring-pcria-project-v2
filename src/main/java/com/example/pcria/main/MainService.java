package com.example.pcria.main;

import com.example.pcria.FileUtils;
import com.example.pcria.SecurityUtils;
import com.example.pcria.domain.AccessVO;
import com.example.pcria.domain.FoodVO;
import com.example.pcria.domain.SeatDMI;
import com.example.pcria.mapper.MainMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.servlet.http.HttpSession;
import java.io.File;
import java.util.List;
import java.util.UUID;

@Slf4j
@Service
public class MainService {

    @Autowired
    private MainMapper mapper;

    public List<FoodVO> selFoodList(FoodVO param) {
        List<FoodVO> list = null;
        if (param.getChk() == 7) {
            list = mapper.selPopularFoodList(param);
        } else {
            list = mapper.selFoodList(param);
        }
        return list;
    }

    public List<SeatDMI> selSeat() {
        return mapper.selSeat();
    }

    //seat 관련 service
    public int insSeat(SeatDMI param) {
        return mapper.insSeat(param);
    }

    public int updSeat(SeatDMI param) {
        return mapper.updSeat(param);
    }

    public int delSeat(AccessVO param) {
        return mapper.delSeat(param);
    }

    public AccessVO selLoginUserSeat(int u_no) {
        return mapper.selLoginUserSeat(u_no);
    }

    //profile 관련 service
    public AccessVO ajaxSelMyInfo(int u_no) {
        return mapper.ajaxSelMyInfo(u_no);
    }

    //profile 관련 service
    public List<FoodVO> ajaxSelMyOrderList(int u_no) {
        return mapper.ajaxSelMyOrderList(u_no);
    }

    //profile 관련 service
    public int updProfile(MultipartHttpServletRequest mreq, AccessVO param, HttpSession hs) {
        AccessVO loginUser = SecurityUtils.getLoginUser(hs);
        param.setU_no(loginUser.getU_no());

        MultipartFile multipartFile = mreq.getFile("profile_img");
        String originFileNm = multipartFile.getOriginalFilename();

        String savePath = mreq.getServletContext().getRealPath("resources") + "/img/u_profile/user/" + loginUser.getU_no() + "/";
        log.info(">> webapp :: {}", savePath);
        String absolutePath = new File("src/main/resources/static/img/u_profile/user/" + loginUser.getU_no()).getAbsolutePath();

        File file = new File(absolutePath);

        if (!file.exists()) {
            boolean wasSuccessful = file.mkdirs();
            if (!wasSuccessful) log.error(">> file : was not successful");
        }

        if (!param.getU_password().equals("")) {
            String salt = SecurityUtils.generateSalt();
            String cryptPw = SecurityUtils.getEncrypt(param.getU_password(), salt);
            param.setU_password(cryptPw);
            param.setSalt(salt);
        }

        if (originFileNm.trim() != null && originFileNm.trim() != "") {
            File prev_file = new File(absolutePath + "/" + loginUser.getU_profile());
            if (prev_file.exists()) prev_file.delete();
            String ext = FileUtils.getExt(originFileNm);
            String saveFileNm = UUID.randomUUID() + ext;
            try {
                multipartFile.transferTo(new File(absolutePath + "/" + saveFileNm));
                param.setU_profile(saveFileNm);
                loginUser.setU_profile(param.getU_profile());
                log.info(">> 파일 등록 성공 :: {}", saveFileNm);
            } catch (Exception e) {
                log.error("파일 등록 실패");
            }
        }
        int result;
        result = mapper.updProfile(param);
        loginUser.setU_birth(param.getU_birth());
        loginUser.setU_name(param.getU_name());
        return result;
    }
}
