package com.example.pcria;

import org.mindrot.jbcrypt.BCrypt;
import com.example.pcria.domain.AccessVO;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public class SecurityUtils {

    public static int getLoginUserPk(HttpServletRequest request) {
        return getLoginUserPk(request.getSession());
    }

    public static int getLoginUserPk(HttpSession hs) {
        AccessVO loginUser = (AccessVO)hs.getAttribute(Const.LOGIN_USER);
        return loginUser == null ? 0 : loginUser.getU_no();
    }

    public static AccessVO getLoginUser(HttpServletRequest request) {
        HttpSession hs = request.getSession();
        return (AccessVO)hs.getAttribute(Const.LOGIN_USER);
    }
    public static AccessVO getLoginUser(HttpSession hs) {
        return (AccessVO) hs.getAttribute(Const.LOGIN_USER);
    }

    public static boolean isLogout(HttpServletRequest request) {
        return getLoginUser(request) == null;
    }

    public static String generateSalt() {
        return BCrypt.gensalt();
    }

    public static String getEncrypt(String pw, String salt) {
        return BCrypt.hashpw(pw, salt);
    }
}
