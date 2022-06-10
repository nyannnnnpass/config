#!/bin/bash

function usage {
	echo "Usage: source $0 on|off|list"
}

function on {
	export http_proxy="http://127.0.0.1:7890"
	export https_proxy=$http_proxy
}

function off {
	unset http_proxy
	unset https_proxy
}

function list {
	echo "http_proxy=$http_proxy"
	echo "https_proxy=$https_proxy"
}

if [ -z $1 ]; then
	usage
else
	if [ $1 = "on" ]; then
		on
	elif [ $1 = "off" ]; then
		off
	elif [ $1 = "list" ]; then
		list
	else
		usage
	fi
fi
