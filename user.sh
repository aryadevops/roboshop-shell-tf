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

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOGFILE
Validate $? "setting up NPM setup"

yum install nodejs -y &>>$LOGFILE
Validate $? "Installing nodejs"

useradd roboshop &>>$LOGFILE
#Validate $? "Adding User"

mkdir /app &>>$LOGFILE
#Validate $? "Creating App Directory"

curl -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>>$LOGFILE
Validate $? "Downloading User Artifact"

cd /app  &>>$LOGFILE
Validate $? "Moving to App Directory"

unzip /tmp/user.zip &>>$LOGFILE
Validate $? "Unzipping User File"

npm install &>>$LOGFILE
Validate $? "Installing dependencies"

cp  /home/centos/roboshop-shell-tf/user.service /etc/systemd/system/user.service &>>$LOGFILE
Validate $? "Copying user.service"

systemctl daemon-reload &>>$LOGFILE
Validate $? "Reloading User module"

systemctl enable user  &>>$LOGFILE
Validate $? "Enabling User module"

systemctl start user &>>$LOGFILE
Validate $? "Starting User module"

cp /home/centos/roboshop-shell-tf/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE
Validate $? "copying mongo repo"

yum install mongodb-org-shell -y &>>$LOGFILE
Validate $? "installing Mongo client"

mongo --host mongodb.aryadevops.online </app/schema/user.js &>>$LOGFILE
Validate $? "Loading user data info mongodb"
