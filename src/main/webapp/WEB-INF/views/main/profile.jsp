<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<div id="allContainer">
    <div id="profileContainer">
        <h1>${loginUser.u_name}님 프로필</h1>
        <div id="leftContainer">
            <div class="printImage">
                <c:choose>
                    <c:when test="${loginUser.u_profile == '' || loginUser.u_profile == null}">
                        <img class="profileImg" src="/img/login/default_image.jpg" alt="프로필 설정 가기">
                    </c:when>
                    <c:otherwise>
                        <img class="profileImg" src="/img/u_profile/user/${loginUser.u_no}/${loginUser.u_profile}" alt="프로필 설정 가기">
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="frmContainer">
                <form id="frm" action="/main/profile" method="post" enctype="multipart/form-data">
                    <div>
                        <span class="name">사진 변경</span>&nbsp;&nbsp;
                        <input type="file" name="profile_img" accept="image/*" value="이미지 선택" class="imgFile">
                    </div>
                    <div>
                        <span class="name">아이디</span>&nbsp;&nbsp;
                        <input type="search" name="u_id" value="${loginUser.u_id}" class="updList" readonly>
                    </div>
                    <div>
                        <span class="name">이름</span>&nbsp;&nbsp;
                        <input type="search" name="u_name" value="${loginUser.u_name}" class="updList">
                    </div>
                    <div>
                        <span class="name">비밀번호 변경</span>&nbsp;&nbsp;
                        <input type="password" name="u_password" value="" class="updList" placeholder="변경하시려면 입력해주세요">
                    </div>
                    <div>
                        <span class="name">비밀번호 확인</span>&nbsp;&nbsp;
                        <input type="password" name="u_repassword" value="" class="updList" placeholder="위와 동일하게 입력해주세요">
                    </div>
                    <div>
                        <span class="name">생년월일</span>&nbsp;&nbsp;
                        <input type="date" name="u_birth" value="${loginUser.u_birth}" class="updList">
                    </div>
                </form>
                <div id="btnBox">
                    <input type="submit" value="업데이트" id="frmBtn" onclick="checkUptUser()">
                </div>
            </div>
        </div>
        <div id="rightContainer">
            <div id="leftInfo">
                <h3>총 충전 시간</h3>
                <div id="myTotalTime">
                    <input type="text" class="updList" readonly>
                </div>
                <h3>총 먹거리 주문 금액</h3>
                <div id="myTotalFoodPayment">
                    <input type="text" class="updList" readonly>
                </div>
            </div>
            <div id="rightInfo">
                <h3>가입 일자</h3>
                <div id="r_dt">
                    <input type="text" class="updList" readonly>
                </div>
                <h3>수정 일자</h3>
                <div id="m_dt">
                    <input type="text" class="updList" readonly>
                </div>
            </div>
            <h3>나의 주문 목록</h3>
            <div id="myOrderList"></div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
    <script type="text/javascript">
        var origin_name = '${loginUser.u_name}'
        var result = '${result}'
        var payment = 0

        if(result == 1) alert('프로필 업데이트 완료되었습니다.')
        ajaxSelMyOrderList()
        ajaxSelMyInfo()
        function makeMyOrderList(listArr) {
            for(var i = 0; i < listArr.length; i++) {
                let div_con = document.createElement('div')
                div_con.classList.add('myOrderContainer')
                div_con.id = 'seq_'+listArr[i].seq

                myOrderList.append(div_con)

                let f_name = document.createElement('span')
                f_name.innerText = listArr[i].f_name
                div_con.append(f_name)
                let total_quantity = document.createElement('span')
                total_quantity.innerText = listArr[i].total_quantity+'개'
                div_con.append(total_quantity)
                let total_price = document.createElement('span')
                let temp = listArr[i].f_price * listArr[i].total_quantity
                payment += temp
                total_price.innerText = numberWithCommas(temp)+'개'
                div_con.append(total_price)
            }
            console.log(numberWithCommas(payment)+'원')
        }
        function selMyInfo(myInfo) {
            var timeArr = myInfo.u_totalTime.split(':')
            myTotalTime.childNodes[1].value = timeArr[0]+'시간'
            myTotalFoodPayment.childNodes[1].value = numberWithCommas(myInfo.u_totalPayment)+'원'
            r_dt.childNodes[1].value = myInfo.r_dt
            m_dt.childNodes[1].value = myInfo.m_dt
        }

        function ajaxSelMyOrderList(){
            axios.get('/main/ajaxSelMyOrderList').then(function(res) {
                console.log(res)
                let myOrderList = res.data
                makeMyOrderList(myOrderList)
            })
        }
        function ajaxSelMyInfo(){
            axios.get('/main/ajaxSelMyInfo').then(function(res) {
                console.log(res)
                let myInfo = res.data
                selMyInfo(myInfo)
            })
        }
        function checkUptUser() {
            if(frm.u_password.value.length > 0) {
                if(frm.u_password.value.length < 5){
                    alert('비밀번호는 5글자 이상입니다')
                    return false
                }
                if(frm.u_password.value != frm.u_repassword.value) {
                    alert('비밀번호가 일치하지 않습니다')
                    console.log(frm.u_password.value)
                    console.log(frm.u_repassword.value)
                    return false
                }
            }
            if(frm.u_name.value.length > 0){
                if(frm.u_name.value.length > 6){
                    alert('이름을 6글자 이하로 설정해주세요.')
                    frm.u_name.value = origin_name
                    return false
                }
            }
            if(frm.u_birth.value.length > 0){
                if(frm.u_birth.value.length <= 10){
                    if(birthday(frm.u_birth.value) == false){
                        return false
                    }
                }
            }
            frm.submit();
        }
        function numberWithCommas(x) {
            return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        }
        function birthday(birth){
            var format = /^(19[0-9][0-9]|20\d{2})-(0[0-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/;
            if(format.test(birth)){
                return true
            }else{
                alert("생년월일을 다시 입력해주세요.");
                return false
            }
        }
    </script>
</div>