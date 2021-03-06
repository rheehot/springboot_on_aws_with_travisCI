#!/bin/bash

REPOSITORY=/home/ubuntu/app/step2
PROJECT_NAME=springboot_on_aws_with_travisCI
PROPERTIES_PATH=$REPOSITORY/..
REAL_PROPERTIES=$PROPERTIES_PATH/application-real.properties
OAUTH_PROPERTIES=$PROPERTIES_PATH/application-oauth.properties
REAL_DB_PROPERTIES=$PROPERTIES_PATH/application-real-db.properties
ALL_PROPERTIES=classpath:/application.properties,$REAL_PROPERTIES,$OAUTH_PROPERTIES,$REAL_DB_PROPERTIES

echo "> Build 파일 복사"

cp $REPOSITORY/zip/*.jar $REPOSITORY/

echo "> 현재 구동중인 애플리케이션 pid 확인"

CURRENT_PID=$(pgrep -fl springboot | awk '{print $1}')
# CURRENT_PID=$(pgrep -fl freelec-springboot2-webservice | grep jar | awk '{print $1}')

echo "현재 구동중인 어플리케이션 pid: $CURRENT_PID"

if [ -z "$CURRENT_PID" ]; then
    echo "> 현재 구동중인 애플리케이션이 없으므로 종료하지 않습니다."
else
    echo "> kill -15 $CURRENT_PID"
    kill -15 $CURRENT_PID
    sleep 5
fi

echo "> 새 어플리케이션 배포"

JAR_NAME=$(ls -tr $REPOSITORY/*.jar | tail -n 1)

echo "> JAR Name: $JAR_NAME"

echo "> $JAR_NAME 에 실행권한 추가"

chmod +x $JAR_NAME

echo "> $JAR_NAME 실행"

JAVA_JAR_RUN="java -jar -Dspring.config.location=$ALL_PROPERTIES -Dspring.profile.active=real $JAR_NAME"
echo "> $JAVA_JAR_RUN"
nohup $JAVA_JAR_RUN 2>&1 &
