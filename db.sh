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

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "mysql server installation"


systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "enable the mysqld"


systemctl start mysqld &>>$LOGFILE
VALIDATE $? "start the mysqld"

#idempotency   

mysql -h db.daws78s-nnr.online -uroot -p${DB_SERVER_PASSWORD} -e 'show databases' &>>$LOGFILE
if [ $? -ne 0 ];
then
    mysql_secure_installation --set-root-pass ${DB_SERVER_PASSWORD} &>>$LOGFILE
    VALIDATE $? "setting up username and password for DB"
else 
    echo -e "Already db username and password is set... $Y SKIPPING $N "
    
fi 

#mysql_secure_installation --set-root-pass ${DB_SERVER_PASSWORD} &>>$LOGFILE
#VALIDATE $? "setting up username and password for DB"