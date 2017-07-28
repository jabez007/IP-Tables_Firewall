#!/bin/bash

echo "**Run this on your target machine**"

printf "%s\n" "======================="
printf "%s\n" "== Open Random Ports =="
printf "%s\n" "======================="

read -p "How many ports would you like to open? " numPorts

printf "How many ports?: %s\n" $numPorts

for x in $(seq 1 $numPorts)
do
        tempRandom=$RANDOM
        # printf "NetCat is listening on port number: %d\n" $tempRandom

        if [ $(($tempRandom%2)) -eq 0 ];
        then
                # This is even numbers
ncat -4 --keep-open --listen --source-port $tempRandom --sh-exec 'printf "%s\n" "IPTABLES: This is A Good Port, keep me open"' &
        else
                # This is odd numbers
ncat -4 --keep-open --listen --source-port $tempRandom --sh-exec 'printf "%s\n" "IPTABLES: This is a Bad Port, close me"' &
        fi
done
