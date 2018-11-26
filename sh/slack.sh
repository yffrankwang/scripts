#!/bin/bash

function usage {
	echo '
slack.sh [-u URL] [-n USERNAME] [-c CHANNEL] [-e ICON_EMOJI] [-a ATTACHMENT_FILE] SUBJECT [DETAIL...] 
  -u, --url          Slack web-hook URL
  -n, --name         User name
  -c, --channel      CHANNEL
  -e, --emoji        Icon EMOJI
  -a, --attachment   Attachment file
'
	exit
}

URL=
USERNAME=noname
CHANNEL=
EMOJI=:ghost:
SUBJECT=
DETAILS=()

# Use > 1 to consume two arguments per pass in the loop (e.g. each
# argument has a corresponding value to go with it).
# Use > 0 to consume one or more arguments per pass in the loop (e.g.
# some arguments don't have a corresponding value).

while [[ $# > 0 ]]
do
	key="$1"

	case $key in
		-u|--url)
			URL="$2"
			shift
		;;
		-n|--name)
			USERNAME="$2"
			shift
		;;
		-c|--channel)
			CHANNEL="$2"
			shift
		;;
		-e|--emoji)
			EMOJI="$2"
			shift
		;;
		-a|--attachment)
			DETAILS[${#DETAILS[@]}]=`sed -e 's/\\n/\\\\n/' -e 's/\\\\/\\\\\\\\/' $2`
			shift
		;;
		*)
		# unknown option
			if [ -z $SUBJECT ]; then
				SUBJECT=$key
			else
				DETAILS[${#DETAILS[@]}]=$key
			fi
		;;
	esac
	shift # past argument or value
done

if [ -z "$URL" ]; then
	usage
fi
if [ -z "$SUBJECT" ]; then
	usage
fi

# Build our JSON payload and send it as a POST request to the Slack incoming web-hook URL
DATA="\"text\": \"${SUBJECT//\"/\\\"}\""
if [ ! -z "$CHANNEL" ]; then
	DATA="$DATA, \"channel\": \"${CHANNEL//\"/\\\"}\""
fi
if [ ! -z "$USERNAME" ]; then
	DATA="$DATA, \"username\": \"${USERNAME//\"/\\\"}\""
fi
if [ ! -z "$EMOJI" ]; then
	DATA="$DATA, \"icon_emoji\": \"${EMOJI//\"/\\\"}\""
fi

if [ "${#DETAILS[@]}" -gt "0" ]; then
	DATA="$DATA, \"attachments\": ["
	for i in "${!DETAILS[@]}"
	do
		if [ "$i" -gt "0" ]; then
			DATA="$DATA, "
		fi
		DATA="$DATA { \"text\": \"${DETAILS[$i]//\"/\\\"}\" }"
	done
	DATA="$DATA ]"
fi

curl -m 5 -X POST -H 'Content-type: application/json' --data "{${DATA}}" $URL

