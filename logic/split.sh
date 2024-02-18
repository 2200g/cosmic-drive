#!/bin/sh
echo "split."

noeenput (){
  read -r -p "input (absolute) file path:" eenput
  split --bytes 20M --numeric-suffixes --suffix-length=5 $eenput out_$eenput
}

yeseenput (){
  split --bytes 20M --numeric-suffixes --suffix-length=5 $eenput out_$eenput
}

while getopts ":hi:" option; do
	case $option in
		i)
      eenput=$OPTARG;
			yeseenput;;
		\?)
			noeenput;;
	esac
done
