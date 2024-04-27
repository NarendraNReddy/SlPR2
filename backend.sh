#!/bin/bash
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
BL="\e[34m"
N="\e[0m"

echo "Enter password:"
read DB_SERVER_PASSWORD
#ExpenseApp@1

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



dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "Disable Node JS"


dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "Enable Node Js:20"


dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "Installation Node JS "


id expense &>>$LOGFILE
if [ $? -ne 0 ];
then
    useradd expense 
    VALIDATE $? "Adding the user expense"
else 
    echo -e "User expense is already present ... $Y SKIPPING $N"    
fi 


mkdir -p /app &>>$LOGFILE
VALIDATE $? "created app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE
VALIDATE $? "Download code to tmp folder"


cd /app &>>$LOGFILE
VALIDATE $? "Move to app folder"

rm -rf /app/* &>>$LOGFILE
VALIDATE $? "Removed the app in app folder"

unzip /tmp/backend.zip &>>$LOGFILE
VALIDATE $? "Unzip the backend code"


npm install &>>$LOGFILE
VALIDATE $? "NPM install for node js"

cp -rf /home/ec2-user/SlPR2/backend.service /etc/systemd/system/backend.service &>>$LOGFILE
VALIDATE $? "copying the backend service"


systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "daemon reload"


systemctl start backend &>>$LOGFILE
VALIDATE $? "backend starts"


systemctl enable backend &>>$LOGFILE
VALIDATE $? "backend enable"



dnf install mysql -y  &>>$LOGFILE
VALIDATE $? "instll mysql client"


mysql -h db.daws78s-nnr.online -uroot -p${DB_SERVER_PASSWORD} < /app/schema/backend.sql &>>$LOGFILE
VALIDATE $? "Schema loading"

systemctl restart backend &>>$LOGFILE
VALIDATE $? "Restart backend"