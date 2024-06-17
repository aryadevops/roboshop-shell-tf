#!/bin/bash

USERID=$(id -u)
SCRIPT_NAME=$0
DATE=$(date +%F)
LOGDIR=/tmp
LOGFILE=/$LOGDIR/$SCRIPT_NAME-$DATE.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $USERID -ne 0 ]
    then 
    echo -e "$R ERROR:: $N Please try with ROOT USER"
    exit 1
fi    

Validate(){
    if [ $1 -ne 0 ]
     then
         echo -e " $2 ......$R Failure $N"
         Exit 1
        else
         echo -e " $2 ...... $G Success $N"
    fi     
}

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$LOGFILE
Validate $? "Downloading Robbitmq"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$LOGFILE
Validate $? "Downloading rabbitmq server"
yum install rabbitmq-server -y &>>$LOGFILE
Validate $? "Installing Rabbitmq server"
systemctl start rabbitmq-server &>>$LOGFILE
Validate $? "Start Rbbitmq Server"
rabbitmqctl add_user roboshop roboshop123 &>>$LOGFILE
Validate $? "Add user "
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOGFILE
Validate $? "Set Permissions"