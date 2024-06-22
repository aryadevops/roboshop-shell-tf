#!/bin/bash

USERID=$(id -u)
SCRIPT_NAME=$0
DATE=$(date +%F)
LOGDIR=/tmp
LOGFILE=$LOGDIR/$SCRIPT_NAME-$DATE.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $USERID -ne 0 ];
then 
    echo -e "$R ERROR:: $N Please try with ROOT USER"
    exit 1
fi    

Validate(){
    if [ $1 -ne 0 ];
    then
         echo -e " $2 ......$R Failure $N"
         Exit 1
    else
         echo -e " $2 ...... $G Success $N"
    fi      
}

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE
Validate $? "Copied MongoDB repo to yum.repos.d"

yum install mongodb-org -y &>> $LOGFILE
Validate $? "Installation of Mongodb"

systemctl enable mongod &>> $LOGFILE
Validate $? "Enabling MongoDB"

systemctl start mongod &>> $LOGFILE
Validate $? "Starting MongoDB"

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>> $LOGFILE
Validate $? "Edited MongoDB conf"

systemctl restart mongod &>> $LOGFILE
Validate $? "Restarting mongoDB"


