#!/bin/bash
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
BL="\e[34m"
N="\e[0m"



VALIDATE()
{
    if [ $1 -ne 0 ];
    then 
        echo -e "$2 is ... $R FAILURE $N"
    else 
        echo -e "$2 is ... $G SUCCESS $N"    
    fi
}

USERID=$(id -u)

if [ $USERID -ne 0 ];
then 
    echo "Be a super user to install the commands"
    exit 1
else 
    echo "Super User"     
fi  

dnf install nginx -y &>>$LOGFILE
VALIDATE $? "nginx install"


systemctl enable nginx &>>$LOGFILE
VALIDATE $? "enable nginx "

systemctl start nginx &>>$LOGFILE
VALIDATE $? "start nginx"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE
VALIDATE $? "remove nginx hmtl"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOGFILE
VALIDATE $? "download frontend code"

cd /usr/share/nginx/html &>>$LOGFILE
VALIDATE $? "Entering into nginx html folder"

unzip /tmp/frontend.zip &>>$LOGFILE
VALIDATE $? "Copy the frontend code"

cp -rf /home/ec2-user/SIPR2/expense.conf /etc/nginx/default.d/expense.conf &>>$LOGFILE
VALIDATE $? "copying expense.conf"

systemctl restart nginx &>>$LOGFILE
VALIDATE $? "Restart nginx"