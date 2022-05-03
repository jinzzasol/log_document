#!/bin/bash

prog_name=$(basename $0)

function help {
	echo "Usage: $prog_name [-a] [-b]"
	echo
	echo "Options"
	echo "    -a, 			VPN option a) - All Traffic over SSL VPN"
	echo "    -b, 			VPN option b) - VT Traffic over SSL VPN"
	echo "	  -d, --disconnect	Disconnect the running VPN"
	echo
}

function disconnect {
	echo "Disconnecting..."
	sudo pkill -SIGINT openconnect

	# Remove default gateway route rule when there is already a PPTP connection
	# Uncomment line below if your computer is connected to internet through a PPTP connection
	ip r | grep ppp0 && ip r | grep default | head -n1 | xargs sudo ip r del
}

subcommand=$1
case $subcommand in
	"-a")	# VPN option a) - All Traffic over SSL VPN
	echo $'\n\nConnecting to a) - All Traffic over SSL VPN...\n\n'
	echo -e '(Network Password)\n(2nd Authentification method)' | sudo openconnect --protocol=pulse 'https://vpn.nis.vt.edu/alltraffic' --user=(PID)
	;;
	"-b")	# VPN option b) - VT Traffic over SSL VPN
	echo $'\n\nConnecting to b) - VT Traffic over SSL VPN...\n\n'
	echo -e '(Network Password)\n(2nd Authentification method)' | sudo openconnect --protocol=pulse 'https://vpn.nis.vt.edu/vttraffic' --user=(PID)
	;;	# Disconnect
	"-d" | "--disconnect")
	disconnect
	;;
	*)
	echo "Error: '$subcommand' is not a known command or not typed." >&2
	echo "		Run '$prog_name --help' for a list of known commands." >&2
#	exit 1
	;;
esac
