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

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOGFILE
Validate $? "Setting up rpm resource"
yum install nodejs -y &>>$LOGFILE
Validate $? "Installing Nodejs"
useradd roboshop &>>$LOGFILE
Validate $? " User Add"
mkdir /app bash &>>$LOGFILE
Validate $? "make App directory"
curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>>$LOGFILE
Validate $? "Installing catalogue"
cd /app &>>$LOGFILE
Validate $? "Moving to app directory"
unzip /tmp/catalogue.zip &>>$LOGFILE
Validate $? "Unziping catalogue"
npm install  &>>$LOGFILE
Validate $? "Installing Npm"
cp /home/centos/roboshop-shell-tf/catalogue.service /etc/systemd/system/catalogue.service &>>$LOGFILE
Validate $? "Copying catalogue servicess"
systemctl daemon-reload &>>$LOGFILE
Validate $? "catalogue reload"
systemctl enable catalogue &>>$LOGFILE
Validate $? "Enableling Catalogue"
systemctl start catalogue &>>$LOGFILE
Validate $? "Starting Catalogue"