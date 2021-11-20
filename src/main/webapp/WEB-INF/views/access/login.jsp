<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login</title>
    <link rel="stylesheet" type="text/css" href="/css/${css}.css">
</head>
<body>
<div id="container">
    <div class="wrap">
        <div class="background"></div>
        <div class="rightPartition">
            <div class="logo_img"><img alt="logo" src="/img/login/PCria_logo.png"></div>
            <div class="form-wrap">
                <div class="button-wrap">
                    <div id="btn"></div>
                    <button type="button" class="togglebtn" onclick="login()">로그인</button>
                    <button type="button" class="togglebtn" onclick="register()">회원가입</button>
                </div>
                <form action="/access/login" id="login" method="post" class="input-group">
                    <div class="msg">${msg}</div>
                    <input type="text" class="input-field" name="u_id" placeholder="아이디를 입력하세요" required>
                    <input type="password" class="input-field" name="u_password" placeholder="비밀번호를 입력하세요" required>
                    <input type='submit' value="로그인" class="submit">
                </form>
                <form action="/access/join" id="register" name="frm2" method="post" class="input-group register" onsubmit="return test_chk()">
                    <div id="idChkResult" class="msg"></div>
                    <div>
                        <input type="text" class="input-field" name="u_id" id="u_id" placeholder="아이디를 입력하세요" required onkeyup="changeId()">
                        <button type="button" onclick="chkId(u_id)">중복 확인</button>
                        <input type="hidden" id="chk_value" name="chk_value">
                    </div>
                    <input type="password" class="input-field" name="u_password" placeholder="비밀번호를 입력하세요" required>
                    <input type="text" class="input-field" name="u_name" placeholder="이름을 입력하세요" required>
                    <input type="date" class="input-field" name="u_birth" required>
                    <div id="registerBtn">
                        <input type="submit" value="회원가입" class="submit">
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<script>

    // 회원 가입 부분 - 시작
    function test_chk() {
        if(frm2.u_id.value.length < 5) {
            alert('아이디를 5글자 이상 입력하세요.')
            frm2.u_id.focus()
            return false
        }
        if(frm2.u_password.value.length < 5) {
            alert('비밀번호를 5글자 이상 입력하세요.')
            frm2.u_password.focus()
            return false
        }
        if(frm2.u_name.value.length < 5) { // 이름에 대한 정규화
            const korean = /[^가-힣]/;
            // const result = korean.test(frm.nm.value)
            // console.log('result : ' + result)
            if(korean.test(frm2.u_name.value)) {
                alert('이름은 한글만 입력하세요.')
                frm2.u_name.focus()
                return false
            }
        }
        if(frm2.chk_value.value == 3) {
            alert('아이디를 다시 확인하세요')
            return false
        }
    }

    function chkId(id) {
        let u_id = id.value
        console.log(u_id)
        axios.post('/access/ajaxIdChk', {
            u_id: u_id
        }).then(function(res) {
            console.log(res)
            if(res.data == 2) { // 아이디 사용 가능
                idChkResult.innerText = '사용 가능한 아이디 입니다.'
                chk_value.value = 2
            } else if(res.data == 3) { // 아이디 중복 됨
                idChkResult.innerText = '중복된 아이디 입니다.'
                chk_value.value = 3
            }
        })
    }

    function changeId() {
        chk_value.value = 3
    }

    var x = document.getElementById("login");
    var y = document.getElementById("register");
    var z = document.getElementById("btn");
    function login(){
        x.style.left = "50px";
        y.style.left = "450px";
        z.style.left = "0";
    }
    function register(){
        x.style.left = "-400px";
        y.style.left = "43px";
        z.style.left = "110px";
    }
    // 회원 가입 부분 - 끝

    sessionStorage.removeItem('timeset')
    sessionStorage.removeItem('count')
    sessionStorage.clear()
</script>
</body>
</html>