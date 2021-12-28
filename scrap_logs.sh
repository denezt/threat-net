#!/bin/bash
# Configuration Example Settings
# for settings.cfg file
#
# name=[NAME_OF_SERVER]
# log_dir=[NAME_OF_DIRECTORY]
# main_log=( "auth.log" )
# regular_logs=( "auth.log.1" "auth.log.2" )
# zipped_logs=( "auth.log.2.gz" "auth.log.3.gz" "auth.log.4.gz" )

source settings.cfg

temporalfile="${name}-temporal.tmp"
logfile=${name}-logs-$(date '+%F').csv

remove_tempfile(){
	if [ -e "$temporalfile" ];
	then
		printf "Removing: $temporalfile\n"
		rm -fv "$temporalfile"
	fi
	}

remove_logfile(){
	if [ -e "$logfile" ];
	then
		printf "Removing: $logfile\n"
		rm -fv "$logfile"
	fi
	}

#Flush Older Files
remove_tempfile
remove_logfile

for f in ${main_log[@]}
do
	printf "${log_dir}/${f}\n"
	if [ -f "${log_dir}/${f}" ];
	then
		egrep "Invalid" ${log_dir}/${f} | awk '{print "\"" $8 "\",\"" $10 "\"" }' | sort -u | tee -a $temporalfile
	fi
done

for f in ${regular_logs[@]}
do
	printf "${log_dir}/${f}\n"
	if [ -f "${log_dir}/${f}" ];
	then
		egrep "Invalid" ${log_dir}/${f} | awk '{print "\"" $8 "\",\"" $10 "\"" }' | sort -u | tee -a $temporalfile
	fi
done

for f in ${zipped_logs[@]}
do
	printf "${log_dir}/${f}\n"
	if [ -f "${log_dir}/${f}" ];
	then
		zgrep "Invalid" ${log_dir}/${f} | awk '{print  "\"" $8 "\",\"" $10 "\"" }' | sort -u | tee -a $temporalfile
	fi
done

printf "\"username\",\"ip_address\"\n" > $logfile
cat $temporalfile | sort -u | tee -a $logfile

#Remove old temporary files
remove_tempfile
