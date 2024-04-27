#!/bin/bash
COURSE="Devops in current script"

echo "Before calling the other script the variable : course value::::::$COURSE"
echo "Before calling other script, the pid of current script:::::::::$$"

./02-other-script1.sh

echo "After calling the other script the variable : course value:::::$COURSE"


