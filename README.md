# spring-pcria-project-v2
pcria 레거시 개선 프로젝트

# 개선 사항

1. css (예전 커밋 정보에서 가져오)
2. file upload (관련 포스팅 : [링크](https://takeknowledge.tistory.com/61))
   - DB 에서 파일 이름 가져온 뒤 경로 찾기
3. 짜파게티 이미지 경로 (농심 공식 홈페이지에서 가져옴)
4. 프로필 유저 정보 - 사용시간 컬럼 오류로 인한 load 실패(컬럼형식 int -> date)
5. 모바일 환경에서 로그인 페이지에 있는 background image 나오지 않고 가운데 정렬로 이루어 지도록 변경

# 현재 문제점

1. LoginCheckInterceptor 기능 - 사용 X
2. 프로필 사진 변경 후 새로 빌드하지 않으면 이미지 변경되지 않음

# Build

빌드는 Heroku 원격 저장소에 올리기 전에 만들어 준다.

```shell
$ ./gradlew build
```
경로를 target 아래로 이동
target/pcria-0.0.1-SNAPSHOT.jar

# 배포

- Heroku

## Heroku 설치 가이드

### 회원가입

> https://www.heroku.com/

### yml-dev 설정

server:
   port: ${port:8080}

### Procfile

프로젝트 root 경로에 확장자 없이 Procfile 생성.

web: java -Dspring.server.port=8080 -Dspring.profiles.active=dev -jar target/pcria-0.0.1-SNAPSHOT.jar

입력해줘야 8080 포트로 연결됨 -> Heroku 는 빌드할 때 마다 port 가 바뀌기 때문에 필요한 설정.

### Heroku CLI

```shell
# heroku 설치
$ brew install heroku/brew/heroku

# heroku login
$ heroku login

# 원격 등록
$ heroku git:remote -a pcria

# heroku 저장소에 push
$ git push heroku master

# heroku 클라이언트 설정
$ heroku ps:scale web=1

# 접속 확인
$ heroku open

# log 확인
$ heroku logs --tail
```

### Heroku url

https://pcria.herokuapp.com/

### Heroku 의 문제

Heroku 는 30분 내에 트래픽이 발생하지 않으면 sleep 모드로 들어가 재접속시 긴 시간이 필요함.

#### 해결

1. 매 30분 핑 발사 [링크](http://kaffeine.herokuapp.com)
2. linux 서버 crontab & curl 

[crontab 사용법](https://jdm.kr/blog/2)
[crontab 설정](https://m.blog.naver.com/writer0713/221507833658)