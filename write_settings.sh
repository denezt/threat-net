#!/bin/bash

config_file=settings.cfg

error(){
	printf "\033[35mError:\t\033[31m${1}\033[0m\n"
	exit 1
}

read -p "Do you want to set a logfile name? [(y)es|(n)o]: " _confirm

case $_confirm in
	y|yes) read -p "What is the name of the server?: " server_name;;
	*) server_name="$(hostname)"
	printf "Setting, the default server name to ${server_name}.\n"
	;;
esac

regular=($(ls /var/log/auth.log.* | grep -v 'gz' | cut -d'/' -f4))
zipped=($(ls /var/log/auth.log.*.gz | cut -d'/' -f4))

_regular=$(printf "\'%s\' " ${regular[*]})
printf '\n'
_zipped=$(printf "\'%s\' " ${zipped[*]})
printf '\n'

if [ ! -z "$server_name" ];
then
	printf "name=\"${server_name}\"\n" | tee $config_file
	printf "log_dir=\"/var/log\"\n" | tee -a $config_file
	printf "main_log=( \'auth.log\' )\n" | tee -a $config_file
	printf "regular_logs=( ${_regular[*]} )\n" | tee -a $config_file
	printf "zipped_logs=( ${_zipped[*]} )\n" | tee -a $config_file
	printf "\n"
else
	error "Unable to set the servername"
fi

