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
  extn=$(basename $eenput | awk -F . '{print $NF}')
  fileSize=$(stat -c %s "$eenput")
    if [ $fileSize -gt $((20*1024*1024)) ]; then
        echo "file is bigger than 20MB, you have to split it now :(."
        mkdir /tmp/cosmic-drive/ > /dev/null 2>&1
        mkdir /tmp/cosmic-drive/${naamkaran}/
        split --bytes 20M --numeric-suffixes --suffix-length=5 $eenput /tmp/cosmic-drive/${naamkaran}/out_ 
        for i in /tmp/cosmic-drive/${naamkaran}/* ; do 
          echo ${i}
          fileId=$(curl -F chat_id="${chatId}" -F document="@${i}" "${apiEnd}/sendDocument" | grep -o '"file_id":"[^"]*' | tail -n 1 | awk -F'"' '{print $4}')
        done
        rm -r /tmp/cosmic-drive/
    else
      echo "file is not bigger than 20MB. :)"
      fileId=$(curl -F chat_id="${chatId}" -F document=@"${eenput}" "${apiEnd}/sendDocument" | grep -o '"file_id":"[^"]*' | tail -n 1 | awk -F'"' '{print $4}')
    fi 
    echo $naamkaran $fileId $extn >> ${db}
}

downloader () {
 read -r -p "file key: " key
 fileId=$(grep -w ${key} ${db} | awk '{print $2}')
 extn=$(grep -w ${key} ${db} | awk '{print $3}')
 numb=$(grep -w ${key} ${db} | wc -l)
 if [ $numb -gt 1 ]; then 
   echo "split detected"
   mkdir /tmp/cosmic-drive/ > /dev/null 2>&1 
   mkdir /tmp/cosmic-drive/${key}_download/
   for i in ${fileId}; do 
     echo ${i}
     pathFile=$(curl -s "${apiEnd}/getFile?file_id=${i}" | grep -o '"file_path":"[^"]*' | awk -F'"' '{print $4}')
     dlURL="https://api.telegram.org/file/bot${TOKEN}/${pathFile}"
     curl -o /tmp/cosmic-drive/${key}_download/${i} ${dlURL}
   done
   cat /tmp/cosmic-drive/${key}_download/* > ${key}.${extn}
   rm -r /tmp/cosmic-drive/
 else 
   echo "file id for ${key} is ${fileId} "
   pathFile=$(curl -s "${apiEnd}/getFile?file_id=${fileId}" | grep -o '"file_path":"[^"]*' | awk -F'"' '{print $4}')
   dlURL="https://api.telegram.org/file/bot${TOKEN}/${pathFile}"
   curl -o ${key}.${extn} ${dlURL}
 fi
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
