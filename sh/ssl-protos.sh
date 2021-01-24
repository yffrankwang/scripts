#!/bin/bash

HOST=$1
PORT=$2

protos="-ssl2 -ssl3 -tls1 -tls1_1 -tls1_2"
OPTS=$3 $4 $5 $6 $7 $8 $9

if [ -z $HOST ]; then
	HOST=127.0.0.1
fi

if [ -z $PORT ]; then
	PORT=443
fi


SERVER=$HOST:$PORT

for proto in ${protos}
do
	echo -n "Testing $proto ... "
	result=$(echo -n | openssl s_client "$proto" $OPTS -connect $SERVER 2>&1)

	if [[ "$result" =~ ":error:" ]] ; then
		error=$(echo -n $result | cut -d':' -f6)
		echo NO \($error\)
	elif [[ "$result" =~ "s_client:" ]] ; then
		error=$(echo $result | head -1)
		echo XX \($error\)
	elif [[ "$result" =~ "Secure Renegotiation IS NOT supported" ]] ; then
		echo NOT supported
	elif [[ "$result" =~ "Secure Renegotiation IS supported" ]] ; then
		echo OK
	else
		error=UNKNOWN RESPONSE
		echo $error
		echo $result
		echo =============================
	fi
done
