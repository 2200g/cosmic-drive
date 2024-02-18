#!/bin/sh

read -r -p "input file: " fileName

apiEnd="https://api.telegram.org/bot${TOKEN}/sendDocument"

curl -F chat_id=${CHATID} -F document=@"${fileName}" "${apiEnd}" | grep -o '"file_id":"[^"]*' | tail -n 1 | awk -F'"' '{print $4}'
