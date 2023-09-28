#!/bin/bash

if [[ -z ${2} ]]; then
  echo -n "Firewall IP: "
  read FP_HOST
  echo "connecting $FP_HOST"
else 
  FP_HOST = ${1}
fi

if [[ -z ${1} ]]; then
  FP_USER="root"
else
  FP_USER=${2}
fi

if [[ -f "~/.ssh/id_rsa.pub" ]]; then
  echo "Using default ~/.ssh/id_rsa.pub"
  FP_KEY=`cat ~/.ssh/id_rsa.pub`
else
  echo -n "Enter your public ssh key: "
  read FP_KEY
fi

ssh ${FP_USER}@${FP_HOST} "mkdir .ssh && touch .ssh/authorized_keys; echo ${FP_KEY} >> .ssh/authorized_keys"
ssh ${FP_USER}@${FP_HOST} "rm /data/config/ssh/sshd_config; cp /usr/share/stonegate/sshd_config /data/config/ssh/sshd_config"
ssh ${FP_USER}@${FP_HOST} "echo 'PubkeyAuthentication yes' >> /data/config/ssh/sshd_config; echo 'AuthorizedKeysFile /data/home/%u/.ssh/authorized_keys' >> /data/config/ssh/sshd_config; msvc -d sshd && msvc -u sshd"
