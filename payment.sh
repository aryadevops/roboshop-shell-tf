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

yum install python36 gcc python3-devel -y &>>$LOGFILE
Validate $? "Installing paymet"
useradd roboshop &>>$LOGFILE
Validate $? "Adding user"
mkdir /app &>>$LOGFILE
Validate $? "make directory app"
curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>>$LOGFILE
Validate $? "downloading payment zip"
cd /app &>>$LOGFILE
Validate $? "Changing to app folder"
unzip /tmp/payment.zip &>>$LOGFILE
Validate $? "Unzipp paymets"
pip3.6 install -r requirements.txt &>>$LOGFILE
Validate $? "Installing Pip3.6"
cp /home/centos/roboshop-shell-tf/payment.service /etc/systemd/system/payment.service &>>$LOGFILE
Validate $? "Copying payments.service"
systemctl daemon-reload &>>$LOGFILE
Validate $? "Reloading paymets"
systemctl enable payment  &>>$LOGFILE
Validate $? "enableling payment"
systemctl start payment &>>$LOGFILE
Validate $? "starting payment"