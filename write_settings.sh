#!/bin/sh

config_file=settings.cfg
read -p "What is the name of the server?: " server_name

if [ ! -z "$server_name" ];
then
	printf "name=\"${server_name}\"\n" | tee $config_file
	printf "log_dir=\"/var/log\"\n" | tee -a $config_file
	printf "regular_log=( \"auth.log\" \"auth.log.1\" )\n" | tee -a $config_file
	printf "zipped_log=( \"auth.log.2.gz\" \"auth.log.3.gz\" \"auth.log.4.gz\" )\n" | tee -a $config_file
fi

