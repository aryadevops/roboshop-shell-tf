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

yum module disable mysql -y &>> $LOGFILE
Validate $? "Disabling the default version"

cp /home/centos/roboshop-shell-tf/mysql.repo /etc/yum.repos.d/mysql.repo &>>$LOGFILE
Validate $? "copying mysql repo"

yum install mysql-community-server -y &>> $LOGFILE
Validate $? "Installing mysql community server"

systemctl enable mysqld &>> $LOGFILE
Validate $? "Enabling mysql"

systemctl start mysqld &>> $LOGFILE
Validate $? "Starting mysql"

mysql_secure_installation --set-root-pass RoboShop@1 &>> $LOGFILE
Validate $? "Setting up root password"


