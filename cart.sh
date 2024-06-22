#!/bin/bash

USERID=$(id -u)
SCRIPT_NAME=$0
DATE=$(date +%F)
LOGDIR=/home/centos/Roboshop
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
Validate $? "Setting up NPM source"

yum install nodejs -y &>>$LOGFILE
Validate $? "Installing nodejs"

useradd roboshop &>>$LOGFILE
#Validate $? "Adding user"

mkdir /app &>>$LOGFILE
#Validate $? "make APP Directory"

curl -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>>$LOGFILE
Validate $? "Downloading Cart Artifact"

cd /app &>>$LOGFILE
Validate $? " redirect to app folder"

unzip /tmp/cart.zip &>>$LOGFILE
Validate $? "Unzipping"

npm install &>>$LOGFILE
Validate $? "installing dependencies"

cp /home/centos/roboshop-shell-tf/cart.service /etc/systemd/system/cart.service &>>$LOGFILE
Validate $? "copying cart.service"

systemctl daemon-reload &>>$LOGFILE
Validate $? "reloading Cart"

systemctl enable cart &>>$LOGFILE
Validate $? "Enableling cart"

systemctl start cart &>>$LOGFILE
Validate $? "Starting cart"