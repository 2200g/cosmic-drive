#!/bin/sh

TOKEN=TOKEN
chatId="chat id"

apiEnd="https://api.telegram.org/bot${TOKEN}/sendDocument"

read -r -p "key" key

fileId=$(grep -w ${key} db | awk '{print $2}')


echo "file id for ${key} is ${fileId} "

pathFile=$(curl -s "${apiEnd}?file_id=${fileId}" | grep -o '"file_path":"[^"]*' | awk -F'"' '{print $4}')

download="https://api.telegram.org/file/bot${TOKEN}/${pathFile}"

curl -o "${key}" "${download}"
