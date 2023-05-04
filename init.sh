#!/bin/bash

# Assumption: k8s/kubeadm was deployed using podcidr=10.240.0.0/16
# Allow pod to pod communication
iptables -A FORWARD -s 10.244.0.0/16 -j ACCEPT
iptables -A FORWARD -d 10.244.0.0/16 -j ACCEPT

# Allow communication across hosts
ip route add 10.244.3.0/24 via 10.0.1.14 dev enp0s3

sudo iptables -A FORWARD -i cni0 -p tcp --dport 9999 -j ACCEPT
sudo iptables -A FORWARD -o cni0 -p tcp --dport 9999 -j ACCEPT

# Allow outgoing internet 
iptables -t nat -A POSTROUTING -s 10.244.0.0/24 ! -o cni0 -j MASQUERADE
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT
