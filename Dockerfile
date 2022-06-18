# jar 파일 실행
#FROM amazoncorretto:11
#ARG JAR_FILE=build/libs/*.jar
#COPY ${JAR_FILE} app.jar
#ENTRYPOINT ["java","-jar","-Dspring.profiles.active=mac","/app.jar"]
#ENTRYPOINT ["java","-jar","/app.jar"]

# war 파일 실행 -> jsp 파일을 불러오기 위해 war 실행
FROM amazoncorretto:11
VOLUME /tmp
ARG JAR_FILE=build/libs/*.war
COPY ${JAR_FILE} app.war
ENV	USE_PROFILE local

#ENTRYPOINT ["java","-Djava.security.egd=ee:/dev/./urandom","-jar","/app.war"]

ENTRYPOINT ["java","-Dspring.profiles.active=${USE_PROFILE}", "-Djava.security.egd=file:/dev/./urandom","-jar","/app.war"]