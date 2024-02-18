#!/bin/sh
#
TOKEN="TOKEN"
chatId="CHATID"

apiEnd="https://api.telegram.org/bot${TOKEN}"
db="${HOME}/.config/cosmicdrive.db"

touch ${db}

helpme () {
  echo "cosmic drive"
  echo "a file storage system hosted on telegram"
  echo 
  echo "syntax: cosmic drive [-h|u|d]"
	echo "options:"
  echo "h     print help text (this)."
	echo "u     upload a file."
	echo "d     download a file."
	echo
}

uploader () {
  read -r -p "input (absolute) file path: " eenput
  read -r -p "save as (no space): " naamkaran
  file_size=$(stat -c %s "$eenput")
    if [ $file_size -gt $((20*1024*1024)) ]; then
        echo "file is bigger than 20MB, you have to split it now :(."
    else
      echo "file is not bigger than 20MB. :)"
      fileName=${eenput}
    fi

  fileId=$(curl -F chat_id="${chatId}" -F document=@"${fileName}" "${apiEnd}/sendDocument" | grep -o '"file_id":"[^"]*' | tail -n 1 | awk -F'"' '{print $4}')
  
  echo $naamkaran $fileId >> ${db}
}

downloader () {
 read -r -p "file key: " key
 fileId=$(grep -w ${key} ${db} | awk '{print $2}')
 echo "file id for ${key} is ${fileId} "
 
 pathFile=$(curl -s "${apiEnd}/getFile?file_id=${fileId}" | grep -o '"file_path":"[^"]*' | awk -F'"' '{print $4}')
 dlURL="https://api.telegram.org/file/bot${TOKEN}/${pathFile}"

 curl -o ${key} ${dlURL}
}

while getopts ":hud" option; do
	case $option in
		h) 
  			helpme
	  		exit;;
		u)
		  	uploader;;
		d)
        downloader;;
	  \?)
      echo "invalid option -$OPTARG :("  >&2
      helpme  >&2 
      exit 1;;
	esac
done


