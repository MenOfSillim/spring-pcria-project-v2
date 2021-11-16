//package com.example.pcria;
//
//import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
//
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//
//public class LoginCheckInterceptor extends HandlerInterceptorAdapter {
//
//    @Override
//    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
//        String uri = request.getRequestURI();
//        String[] uriArr = uri.split("/");
//
//        if(uri.equals("/")) {
//            return true;
//        } else if(uriArr[1].equals("resources")) {
//            return true;
//        }
//
//        boolean isLogout = SecurityUtils.isLogout(request);
//
//        switch(uriArr[1]) {
//            case ViewRef.URI_USER:
//                switch(uriArr[2]) {
//                    case "login":
//                        if(!isLogout) {
//                            response.sendRedirect("/main/seat");
//                            return false;
//                        }
//                }
//                break;
//            case ViewRef.URI_MAIN:
//                if(isLogout) {
//                    response.sendRedirect("/access/login");
//                    return false;
//                }
//        }
//        return true;
//    }
//}
