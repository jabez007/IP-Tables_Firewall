#!/bin/bash

# Set the internal field separator
IFS=$'\n'

target=$1

echo "**Run this on your testing machine**"
echo "####################"
printf "%10s %10s\n" "Good Ports" "Bad Ports"
for port in {1..65535}
do
        check_port="$(nc -w 1 $target $port 2>&1)"
        if [ -n "$(echo "$check_port" | grep "Good Port")" ]
        then
                printf "%10s\n" "$port"
        else
                if [ -n "$(echo "$check_port" | grep "Bad Port")" ]
                then
                        printf "%21s\n" "$port"
                fi
        fi
done

unset IFS
exit 0
