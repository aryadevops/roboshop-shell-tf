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

yum install maven -y &>>$LOGFILE
Validate $? "Installing Maven"
useradd roboshop &>>$LOGFILE
Validate $? "Adding User"
mkdir /app &>>$LOGFILE
Validate $? "Creating app directory"
curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>>$LOGFILE
Validate $? "downloading shipping data"
cd /app &>>$LOGFILE
Validate $? "Changing to App directory"
unzip /tmp/shipping.zip &>>$LOGFILE
Validate $? "unzipping"
mvn clean package &>>$LOGFILE
Validate $? "mvn package cleaning"
systemctl daemon-reload &>>$LOGFILE
Validate $? "reload Shipping"
systemctl enable shipping &>>$LOGFILE
Validate $? "Enableling shipping"
systemctl start shipping &>>$LOGFILE
Validate $? "Starting Shipping"
yum install mysql -y  &>>$LOGFILE
Validate $? "Install mysql"
mysql -h mysql.aryadevops.online -uroot -pRoboShop@1 < /app/schema/shipping.sql &>>$LOGFILE
Validate $? "mysql path attaching"
systemctl restart shipping &>>$LOGFILE
Validate $? "Restart Shipping"