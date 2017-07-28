#!/bin/bash

# Set the internal field separator
IFS=$'\n'

# Flush the selected chain, or all the chains in the table if none is given.
# This deletes all the rules one by one
iptables -F

# Creates a default "Deny All" policy
# -P sets the policy for the built-in (non-user-defined) chain to either ACCEPT or DROP
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# Allow all traffic on the loopback interface
# -A appends the rule to the end of the selected chain
# -i gives the name of the interface via which a packet is received
iptables -A INPUT -i lo -j ACCEPT

# Prevents loopback address spoofing from outside the box
# -s gives the source ip address(es) of the incoming packet
# When the source and/or destination resolve to more than one address,
# a rule will be added for each possible address combination
iptables -A INPUT -s 127.0.0.0/8 -j DROP

# Allow outbound traffic
# -p gives the protocol of the rule or the packet to check
# -m specifies a match to use and enables stateful session handling
iptables -A OUTPUT -p tcp -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p udp -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p icmp -m state --state NEW,ESTABLISHED -j ACCEPT

# Allow returning traffic from outbound connections
iptables -A INPUT -p tcp -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -p udp -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -p icmp -m state --state ESTABLISHED -j ACCEPT

# Allow incoming traffic
# --dport gives the destination port for traffic
iptables -A INPUT -p tcp --dport 22 -m state --state NEW -j ACCEPT  # open port for SSH

# Log everything else before dropping it
iptables -A INPUT -j LOG
iptables -A OUTPUT -j LOG
iptables -A FORWARD -j LOG

# Save our iptables configuration
iptables-save > /etc/sysconfig/iptables

# Put our rules into effect
systemctl restart iptables

unset IFS
exit 0
