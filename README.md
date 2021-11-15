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