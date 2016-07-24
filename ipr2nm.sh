#!/bin/bash
#
# (c) Christian Lohmann
#
# iprange2netmask
#
# 


# helper function from GitHub
# based on https://gist.github.com/jjarmoc/1299906
# Handy functions for .bashrc loading.
#
# $ atoi 192.168.1.1
# 3232235777
# $ itoa 3232235777
# 192.168.1.1

function atoi
{
#Returns the integer representation of an IP arg, passed in ascii dotted-decimal notation (x.x.x.x)
  IP=$1; IPNUM=0
  for (( i=0 ; i<4 ; ++i )); do
    ((IPNUM+=${IP%%.*}*$((256**$((3-${i}))))))
    IP=${IP#*.}
  done
  echo $IPNUM 
} 

function itoa
{
#returns the dotted-decimal ascii form of an IP arg passed in integer format
   printf "%d.%d.%d.%d\n" $(($(($(($((${1}/256))/256))/256))%256)) $(($(($((${1}/256))/256))%256)) $(($((${1}/256))%256))  $((${1}%256)) 
}
#


inet=("$(whois $1 | grep inetnum)")
if [ ${#inet} == 0 ]; then
   inet=("$(whois $1 | grep CIDR)")
   if [ ${#inet} > 0 ]; then
      printf "%s\n" $inet 
    fi
   exit
fi
inetInfo=($inet)

inetFrom=("${inetInfo[1]}")
inetFromNum=("$(atoi $inetFrom)")
inetFromBin=$(echo "obase=2;$inetFromNum" | bc)

inetTo=("${inetInfo[3]}")
inetToNum=("$(atoi $inetTo)")
inetToBin=$(echo "obase=2;$inetToNum" | bc)

printf "%s %s\n%s %s\n" $inetFromBin $inetFrom $inetToBin $inetTo

iF2iT=$(( $inetFromNum ^ $inetToNum ))
iF2iTBin=$(echo "obase=2;$iF2iT" | bc)
printf "%s /%d\n" $inetFrom $((32 - ${#iF2iTBin} )) 
