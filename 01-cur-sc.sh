#!/bin/bash
COURSE="Devops in current script"

echo "Before calling: The var in current script ::::$COURSE"
echo "Before calling: The pid of current script::::::$$"

./02-oth-sc.sh

echo "After calling: The var:::::$COURSE"
