#!/bin/bash


usage() {
	echo "Message: Input Warning(-w); Critical(-c); Email(-e); "
	echo "Note: ****Warning treshold should be less than Critical treshold****"
	echo "Please try again."
	exit 4
}


while getopts ":w:c:e:" o
do
    case "${o}" in
		        w)
						  w=${OPTARG}
							;;

						c)
						  c=${OPTARG}
							;;
						  
						e)
							e=${OPTARG}
							;;
						*)
							usage
							;;
		esac
done

TOTAL_MEMORY=$( free | grep Mem: | awk '{ print $2 }')
MEMORY=$( free | grep Mem: | awk ' { print $3 } ')
Percent=$(((100*MEMORY)/TOTAL_MEMORY))

if [ $w -ge $c ]
then
	usage
fi

shift $((OPTIND-1))

now="$(date +'%Y%m%d %H:%M')"
echo "Memory = $MEMORY"
echo "Total Memory = $TOTAL_MEMORY"

if [ $Percent -ge $c ]
then
	LINES=17 top -n 1 -o %MEM > top.txt
	mailx -a top.txt -s "$now" ${e} 
	echo "Critical! top 10 processes are sent to: ${e}
				Memory % : $Percent %
				Critical treshold % : ${c} % "
	exit 2
fi

if [ $Percent -ge $w ]
then
	echo "WARNING! Memory % is greater than the warning treshold!
				Memory % : $Percent % 
				Warning treshold % : ${w} % "
	exit 0
fi

if [ $Percent -lt $w ]
then
	echo "Everything is fine!
				Memory % : $Percent %
				Warning Treshold %: ${w} %
				"
	exit 1
fi


