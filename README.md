# spring-pcria-project-v2
pcria 레거시 개선 프로젝트

# 개선 사항

1. css (예전 커밋 정보에서 가져오)
2. file upload (관련 포스팅 : [링크](https://takeknowledge.tistory.com/61))
   - DB 에서 파일 이름 가져온 뒤 경로 찾기
3. 짜파게티 이미지 경로 (농심 공식 홈페이지에서 가져옴)
4. 프로필 유저 정보 - 사용시간 컬럼 오류로 인한 load 실패(컬럼형식 int -> date)

# 현재 문제점

1. LoginCheckInterceptor 기능
2. 프로필 사진 변경 후 새로 빌드하지 않으면 이미지 변경되지 않음

# 배포

- Heroku

## Heroku 설치 가이드

### 회원가입

> https://www.heroku.com/

### yml 설정

server:
   port: ${port:8080}

### Procfile

web: java -Dspring.server.port=8080 -Dspring.profiles.active=dev -jar target/pcria-0.0.1-SNAPSHOT.jar

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
# log 확인
$ heroku logs --tail
```
