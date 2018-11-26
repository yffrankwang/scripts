#!/bin/bash

HOST=$1
PORT=$2

#-ssl2, -ssl3, -tls1, -tls1_1, -tls1_2, -no_ssl2, -no_ssl3, -no_tls1, -no_tls1_1, -no_tls1_2
OPTS=$3 $4 $5 $6 $7 $8 $9

if [ -z $HOST ]; then
  HOST=127.0.0.1
fi

if [ -z $PORT ]; then
  PORT=443
fi


SERVER=$HOST:$PORT

ciphers=$(openssl ciphers 'ALL:eNULL' | sed -e 's/:/ /g')

echo Obtaining cipher list from $(openssl version).

for cipher in ${ciphers[@]}
do
  echo -n Testing $cipher...
  result=$(echo -n | openssl s_client -cipher "$cipher" $OPTS -connect $SERVER 2>&1)
  if [[ "$result" =~ ":error:" ]] ; then
    error=$(echo -n $result | cut -d':' -f6)
    echo NO \($error\)
  elif [[ "$result" =~ "Cipher is ${cipher}" || "$result" =~ "Cipher    :" ]] ; then
    success="$success
$cipher"
    echo $cipher
  else
    error=UNKNOWN RESPONSE
    echo $error: $result
  fi
#  sleep 1
done

echo 
echo ------ SUCCESS CIPHERS ------
echo "$success"
