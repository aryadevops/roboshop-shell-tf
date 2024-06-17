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


yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$LOGFILE
Validate $? "Installing rpms"
yum module enable redis:remi-6.2 -y &>>$LOGFILE
Validate $? "Enableling Redis"
yum install redis -y &>>$LOGFILE
Validate $? "Installing Redis"
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf /etc/redis/redis.conf &>>$LOGFILE
Validate $? "Replacing with public ip"
systemctl enable redis &>>$LOGFILE
Validate $? "Enableling redis"
systemctl start redis &>>$LOGFILE
Validate $? "Starting Redis"