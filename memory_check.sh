#!/bin/bash


usage() { #popsout whenever there is a wrong input
	echo "Message: Input Warning(-w); Critical(-c); Email(-e); "
	echo "Note: ****Warning treshold should be less than Critical treshold****"
	echo "Please try again."
	exit 4
}


while getopts ":w:c:e:" o #getopts to get the parameters
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

TOTAL_MEMORY=$( free | grep Mem: | awk '{ print $2 }') #getting the total memory
MEMORY=$( free | grep Mem: | awk ' { print $3 } ')    #getting the memory occupied
Percent=$(((100*MEMORY)/TOTAL_MEMORY))		     #getting memory%

if [ $w -ge $c ] #print error if warning% is greater than or equal to critical%
then
	usage
fi

shift $((OPTIND-1)) #shift

now="$(date +'%Y%m%d %H:%M')" #date in YYYYMMDD H:M format
echo "Memory = $MEMORY"	      #print memory
echo "Total Memory = $TOTAL_MEMORY" #print total memory

if [ $Percent -ge $c ] #if mem% greater than or equal to critical%
then
	LINES=17 top -n 1 -o %MEM > top.txt #getting the top 10 processes sorted from highest memory.
	mailx -a top.txt -s "$now" ${e} #mailx to the -e parameter
	echo "Critical! top 10 processes are sent to: ${e} 
				Memory % : $Percent %
				Critical treshold % : ${c} % 
				date/time: $now" 
	exit 2
fi

if [ $Percent -ge $w ] #if mem% is greater than or equal to warning%
then
	echo "WARNING! Memory % is greater than the warning treshold!
				Memory % : $Percent % 
				Warning treshold % : ${w} % 
				date/time: $now"
	exit 0
fi

if [ $Percent -lt $w ] #if mem% is less than %warning%
then
	echo "Everything is fine!
				Memory % : $Percent %
				Warning Treshold %: ${w} %
				date/time: $now"
	exit 1
fi

