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

yum install maven -y &>>$LOGFILE
Validate $? "Installing Maven"

useradd roboshop &>>$LOGFILE
#Validate $? "Adding User"

mkdir /app &>>$LOGFILE
#Validate $? "Creating app directory"

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>>$LOGFILE
Validate $? "downloading shipping artifact"

cd /app &>>$LOGFILE
Validate $? "Moving to App directory"

unzip /tmp/shipping.zip &>>$LOGFILE
Validate $? "unzipping shipping"

mvn clean package &>>$LOGFILE
Validate $? "packing shipping app"

mv target/shipping-1.0.jar shipping.jar &>>$LOGFILE
Validate $? "renaming shipping jar"

cp /home/centos/roboshop-shell-tf/shipping.service /etc/systemd/system/shipping.service &>>$LOGFILE
Validate $? "copying shipping service"

systemctl daemon-reload &>>$LOGFILE
Validate $? "reload Shipping"

systemctl enable shipping &>>$LOGFILE
Validate $? "Enabling shipping"

systemctl start shipping &>>$LOGFILE
Validate $? "Starting Shipping"

yum install mysql -y  &>>$LOGFILE
Validate $? "Installing mysql client"

mysql -h mysql.aryadevops.online -uroot -pRoboShop@1 < /app/schema/shipping.sql &>>$LOGFILE
Validate $? "Loaded countries and cities info"

systemctl restart shipping &>>$LOGFILE
Validate $? "Restarting Shipping"