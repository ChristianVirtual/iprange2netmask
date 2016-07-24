# iprange2netmask

simple shell script to get the ip netmask for a given IP adress with help of WHOIS and some bit math

Example:

sh ipr2nm.sh 61.178.42.242

111101101100100000000000000000 61.178.0.0

111101101100101111111111111111 61.178.255.255

61.178.0.0/16

