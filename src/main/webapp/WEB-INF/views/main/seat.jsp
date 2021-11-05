<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<div id="allContainer">
    <h1>PCria 좌석 선택</h1>
    <div id="seatsContainer"></div>
    <div id="btnContainer">
        <button id="btnSelSeat" onclick="extractSeatList()">좌석 선택 완료</button>
    </div>
    <input type="hidden" value="${data.u_time}" id="u_time">
    <input type="hidden" id="sample01">
</div>
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<script>
    //좌석 배치용
    var alphabetArr = ['A','B','C','D','E','F','G']
    //내가 좌석을 체크 했는지 안 했는지.
    var selectedSeatValue = '이용 가능';
    //내가 선택한 좌석 저장 변수
    var myS_val = ''
    var myS_no = 0;
    var myS_occupied = 0
    //내가 기존에 자리가 있었는지, 신규인지 체크
    var myUpdInsChk = 0

    //좌석 선택 완료 버튼 클릭 시 좌석 업데이트
    function ajaxUpdSeat(s_no, s_occupied, chk) {
        axios.post('/main/ajaxUpdSeat',{
            s_no : s_no,
            s_occupied : s_occupied,
            myUpdInsChk : chk
        }).then(function(res) {
            console.log(`res.data : \${res.data}`)
            console.log(`myUpdInsChk 전 : \${myUpdInsChk}`)
            myUpdInsChk = 1
            console.log(`myUpdInsChk 후 : \${myUpdInsChk}`)

            var myBtn = document.querySelector('.btnMySelSeat')
            var u_time = document.createElement('div')
            var myU_time = `${data.u_time}`
            if(res.data == 1){
                alert('좌석 이동이 완료되었습니다.')
                myBtn.append(u_time)
                u_time.innerText = ''
                u_time.innerText = others_time(myU_time)
                start()
            }else if(res.data == 2){
                if(myU_time == '00:00:00') {
                    alert('먼저 시간 예약을 해주세요.')
                    return false
                } else {
                    alert('좌석 등록이 완료되었습니다.')
                    myBtn.append(u_time)
                    u_time.innerText = ''
                    u_time.innerText = others_time(myU_time)
                    start()
                }
            }else{
                alert('실패하였습니다.')
            }
        })
    }

    function extractSeatList() {
        if(myS_occupied == 0){
            alert('좌석을 선택해주세요')
        }else{
            var seatId = document.getElementById(myS_val)
            var s_no = seatId.childNodes[2].value
            console.log(`s_no(현재 내가 선택한 좌석) : \${s_no}`)

            var s_occupied = seatId.childNodes[1].innerText
            console.log(`s_occupied(이용 체크) : \${s_occupied}`)
            if(seatId.childNodes[1].innerText == '이용중'){
                s_occupied = 1
            }else{
                s_occupied = 0
            }
            ajaxUpdSeat(s_no, s_occupied, myUpdInsChk)
        }
    }



    function changeColorSeat(s_val, clickId, clickClassName){
        if(clickClassName == 'btnMySelSeat' && s_val == myS_val){
            if(confirm('선택한 좌석을 취소하시겠습니까')){
                clickId.classList.remove('btnMySelSeat')
                clickId.classList.add('btnEmptySeats')
                clickId.childNodes[1].innerText = '이용 가능'
                clickId.removeChild(clickId.lastChild)
                myS_val = ''
                myS_occupied = 0
                myS_no = 0
            }
        }else if(clickClassName == 'btnSelSeats' && s_val != myS_val){
            alert('이용중입니다.')
        }else{
            if(myS_occupied == 1){
                //이전 선택된 자리 지우기
                if(confirm('자리를 이동하시겠습니까?')){
                    var prevSelId = document.getElementById(myS_val)
                    prevSelId.classList.remove('btnMySelSeat')
                    prevSelId.classList.add('btnEmptySeats')
                    prevSelId.childNodes[1].innerText = '이용 가능'

                    prevSelId.removeChild(prevSelId.lastChild)

                    clickId.classList.remove('btnEmptySeats')
                    clickId.classList.add('btnMySelSeat')
                    clickId.childNodes[1].innerText = '이용중'
                    myS_val = s_val
                    myS_no = clickId.childNodes[2].value
                    myS_occupied = 1;
                }
            }else{
                if(confirm('좌석을 선택하시겠습니까?')){
                    if(`${data.u_time}` == '00:00:00') {
                        alert('먼저 시간을 예약해 주세요')
                        return false
                    }
                    clickId.classList.remove('btnEmptySeats')
                    clickId.classList.add('btnMySelSeat')
                    clickId.childNodes[1].innerText = '이용중'
                    myS_val = s_val
                    myS_no = clickId.childNodes[2].value
                    myS_occupied = 1;
                }
            }
        }
    }

    //좌석 만들어서 그림 그려넣기(완료)
    function makeSeatBtns(arr, colCnt, seatArr){
        var divParent = document.createElement('div')
        let j = 0;
        arr.forEach(function(item){
            var divChild = document.createElement('div')
            for(var i = 0; i < colCnt; i++){
                //var로 하면 문제터짐. for문 끝나도 살아있음. for문의 마지막 값이 있음
                let txt = `\${item}\${i+1}`
                //버튼 생성 및 속성 추가
                var btn = document.createElement('button')
                btn.setAttribute('id',`\${item}\${i+1}`)
                //버튼 내부 s_val 텍스트 추가
                var divS_val = document.createElement('div')
                divS_val.innerText = txt
                btn.append(divS_val)
                //좌석 사용 여부 체크
                var divS_occupied = document.createElement('div')
                var s_occupied = seatArr[j].s_occupied
                btn.append(divS_occupied)
                //s_no를 input hidden에 추가
                var divS_no = document.createElement('input')
                divS_no.value = seatArr[j].s_no
                divS_no.type = 'hidden'
                btn.append(divS_no)
                //이용중 text 추가와 시간 추가
                if(s_occupied == 1){
                    divS_occupied.innerText = '이용중'
                    if(txt == myS_val){
                        btn.classList.add('btnMySelSeat')
                    }else{
                        btn.classList.add('btnSelSeats')
                        // 다른 사람 시간 추가 하는 곳
                        var other_div = document.createElement('div')
                        var other_time = seatArr[j].u_time
                        other_div.append(others_time(other_time))
                        btn.append(other_div)
                        other_div.innerText = ''
                        other_div.innerText = others_time(other_time)
                    }
                }else{
                    divS_occupied.innerText = '이용 가능'
                    btn.classList.add('btnEmptySeats')
                }
                //index 추가(이용중/이용가능, 좌석seq 주는 인덱스)
                j++

                //버튼 클릭 시 이벤트
                btn.addEventListener('click',function(){
                    //현재 ID값 추출
                    let clickId = document.getElementById(`\${this.id}`)
                    changeColorSeat(txt, clickId, this.className)
                })
                divChild.appendChild(btn)
                if((i+1) % 2 == 0){
                    var sp = document.createElement('span')
                    divChild.appendChild(sp)
                }
            }
            divParent.appendChild(divChild)
            seatsContainer.appendChild(divParent)
        })
    }
    //시작 시 전체 PC방 좌석 출력(완료)
    function ajaxSelListSeat(alphabetArr) {
        axios.get('/main/ajaxSelSeat').then(function(res) {
            console.log(res)
            //DB에 내가 사용하고 있는 정보 가져오기
            myS_val = res.data.myS_val
            myS_no = res.data.myS_no
            myS_occupied = res.data.myS_occupied
            myUpdInsChk = res.data.myS_occupied
            //DB에 전체 좌석 현황 가져오기
            let seatArr = res.data.ajaxSelSeat
            //좌석 만드는 함수 실행
            makeSeatBtns(alphabetArr, 8, seatArr)

            var myBtn = document.querySelector('.btnMySelSeat')
            if(myBtn != null) {
                var u_time = document.createElement('div')
                var myU_time = `${data.u_time}`
                myBtn.append(u_time)
                u_time.innerText = ''
                u_time.innerText = others_time(myU_time)
            }
        })
    }
    function time_count() {
        if(localStorage.getItem('otherCount') == null) {
            localStorage.setItem('otherCount', -1)
        } else {
            localStorage.setItem('otherCount', localStorage.getItem('otherCount') - 1)
        }
        seatsContainer.innerText = ''
        ajaxSelListSeat(alphabetArr)

    }

    var other_timer = null

    function Start_other_timer() {
        time_count()
        other_timer = setInterval(time_count, 20000)
    }
    Start_other_timer()
    const countDownTimer = function (id, date) {
        var _vDate = new Date(date); // 전달 받은 일자
        var _second = 1000;
        var _minute = _second * 60;
        var _hour = _minute * 60;
        var _day = _hour * 24;
        var timer;
        var i = -1;
        function showRemaining() {
            var now = new Date();
            var distDt = _vDate - now;
            if(localStorage.getItem('timeset') == null) {
                localStorage.setItem('timeset', distDt); // 세션에 초기 시간 삽입
                localStorage.setItem('count', i); // 세션에 초기 시간 삽입
            }
            if (distDt < 0) {
                clearInterval(timer);
//                 document.getElementById(id).textContent = '해당 이벤트가 종료 되었습니다!';
                return;

            }
            var days = Math.floor(distDt / _day);
            var hours = Math.floor((distDt % _day) / _hour);
            var minutes = Math.floor((distDt % _hour) / _minute);
            var seconds = Math.floor((distDt % _minute) / _second);
            //document.getElementById(id).textContent = date.toLocaleString() + "까지 : ";
            document.getElementById(id).textContent = days + '일 ';
            document.getElementById(id).textContent += hours + '시간 ';
            document.getElementById(id).textContent += minutes + '분 ';
            document.getElementById(id).textContent += seconds + '초';
        }
        timer = setInterval(showRemaining, 1000);
    }
    function start() {
        var dateObj = new Date();
        var time = u_time.value
        var real_time = 0
        console.log(time)
        if(time != '00:00:00') {
            var timeArr = time.split(':')
            console.log(parseInt(timeArr[0]))
            real_time = parseInt(timeArr[0] * 3600) + parseInt(timeArr[1] * 60) + parseInt(timeArr[0])
            console.log(real_time)
        } else {
            real_time = 0
        }
        dateObj.setTime(dateObj.getTime() + real_time * 1000);
        countDownTimer('sample01', dateObj); // 남은 시간부터 카운트다운
    }

</script>