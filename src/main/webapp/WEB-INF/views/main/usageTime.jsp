<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<link rel="stylesheet" type="text/css" href="/css/main/modal.css">
<link href="https://fonts.googleapis.com/icon?family=Material+Icons"
      rel="stylesheet">
<div id="allContainer">
    <h1>PCria 사용 시간 예약</h1>
    <div id="user_info">
        <p><span>${data.u_name}</span>님 반갑습니다.</p>
        <p id="current_time">잔여 시간 <span id="span_time"></span> 남았습니다.</p>
        <p id="current_price"></p>
        <div id="div_coin">
            <input type="text" name="coin" id="coin">원
            <button onclick="insert_coin()" id="coin_btn">충전하기</button>
        </div>
        <div class="msg">${msg}</div>
    </div>
    <div id="sel_div"></div>
    <form id="timeFrm" action="/count/time" method="post" onsubmit="return chk()">
        <input type="hidden" name="u_time" value="0" readonly="readonly">
        <input type="hidden" name="u_wallet" value="0" readonly="readonly">
        <div id="open">결제하기</div>
        <div class="modal hidden">
            <div class="modal__overlay"></div>
            <div class="modal__content">
                <div id="modal_btn"><span class="material-icons">clear</span></div>
                <div id="sel_time">
                    <p id="sel__time"></p>
                    <p id="sel__price"></p>
                </div>
                <input type="submit" value="결제하기" id="time_sub">
            </div>
        </div>
    </form>
</div>
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<script>
    var data_u_time = '${data.u_time}'
    var time_value = others_time_1(data_u_time)
    span_time.innerText = time_value

    function curr_price(coin) {
        current_price.innerHTML = '현재 잔액 <span>'+ numberFormat(coin) + '</span>원 남았습니다.'
    }
    function others_time_1(other_time) {
        var otherArr = other_time.split(':')
        return `\${otherArr[0]}:\${otherArr[1]}`
    }
    curr_price(${data.u_wallet})

    function insert_coin() {
        var coin = document.getElementById('coin').value
        console.log('coin : ' + coin)
        if(coin == 0) {
            alert('금액을 입력하세요')
            return false
        }
        if(confirm('충전하시겠습니까?')) {
            axios.post('/count/coinAjax', {
                u_wallet : coin
            }).then(function(res) {
                console.log(res)
                console.log(res.data)
                document.querySelector('#coin').value = 0
                current_price.innerText = ''
                curr_price(res.data.u_wallet)
            })
        }
    }

    function make_btn() {
        var selArr =[1, 2, 3, 5, 10, 20]
        var selDiv = document.createElement('div')
        selDiv.setAttribute('class', 'sel_div')
        for(var i = 0; i < selArr.length; i++) {
            var sel_btn = document.createElement('button')
            sel_btn.setAttribute('class','btn_list')
            sel_btn.setAttribute('id',selArr[i])
            sel_btn.setAttribute('onclick', 'pc_time('+selArr[i]+')')
            sel_btn.innerText = selArr[i]+':00시간\n'+numberFormat(selArr[i]*1200)+'원'
            selDiv.append(sel_btn)
            if(i % 2 == 1) {
                var br = document.createElement('br')
                selDiv.appendChild(br)
            }
        }
        sel_div.append(selDiv)
    }
    make_btn()

    const selBtn = (id) => {
        const u_id = document.getElementById(id)
        u_id.classList.remove('btn_list')
        u_id.classList.add('btn_sel')
    } // 선택 버튼

    const chanBtn = (id) => {
        const u_id = document.getElementById(id)
        u_id.classList.remove('btn_sel')
        u_id.classList.add('btn_list')
    } // 선택 변경 버튼

    var temp_btn = 0 // 이전 인덱스를 담기 위한 변수

    function pc_time(put_hour) {
        var hour = put_hour
        var price = hour * 1200

        console.log("hour : " + hour)
        console.log("price : " + price)
        timeFrm.u_time.value = hour * 10000
        timeFrm.u_wallet.value = price

        sel__time.innerText = '선택한 시간은 ' + hour + ':00 시간입니다'
        sel__price.innerText = '요금은 ' + numberFormat(price) + '원 입니다'

        const btn = document.getElementById(put_hour)
        btn.addEventListener('click', selBtn(put_hour))
        if(temp_btn != 0) { // 선택 변경을 위해 추가
            const chan_btn = document.getElementById(temp_btn)
            chan_btn.addEventListener('click', chanBtn(temp_btn))
        }

        temp_btn = put_hour
    }

    const openButton = document.getElementById("open")
    const modal = document.querySelector(".modal")
    const overlay = modal.querySelector(".modal__overlay")
    const closeBtn = modal.querySelector("#modal_btn")
    const openModal = () => {
        if(timeFrm.u_time.value == 0){
            alert('시간을 먼저 선택해 주세요.')
            return false
        }
        modal.classList.remove("hidden")
    }
    const closeModal = () => {
        modal.classList.add("hidden")
    }
    closeBtn.addEventListener("click", closeModal)
    openButton.addEventListener("click", openModal)

    function chk() {
        if(timeFrm.u_time.value == 0 && timeFrm.u_wallet.value ==0) {
            alert('시간을 선택해 주세요.')
            return false
        }
        alert('선택이 완료되었습니다.')
    }
    function numberFormat(inputNumber) {
        return inputNumber.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }
</script>