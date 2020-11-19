#!/bin/bash
export IFS=$'\n'
DIR=$(cd $(dirname $0); pwd)
cd $DIR
CMDNAME=`basename $0`

FILENAME_QUEUE="queue_axel.txt"
if [ $# -ne 0 ]; then
    ${FILENAME_QUEUE}=${1}
fi
echo "reading from "${FILENAME_QUEUE}"..."

NUM_CONNECTIONS=10

for LINE in `cat ${FILENAME_QUEUE} | grep -v "^#"`
do

        TITLE=`echo ${LINE} | cut -f 1`
	URL=`echo ${LINE} | cut -f 2`

	if [ ${TITLE} = ${URL} ] ; then 
		TITLE=''
	fi


	echo ${TITLE}
	echo ${URL}

	echo ${#TITLE}
	echo ${#URL}

        if [ ${#URL} -lt 2 ] ; then
                continue
        fi


	TARGET_URL=`curl -I -Ls -o /dev/null -w %{url_effective} ${URL}`

	if [ ${#TITLE} = 0 ] ; then
		axel -a -v -n ${NUM_CONNECTIONS} ${TARGET_URL} || continue
	else
		axel -a -v -n ${NUM_CONNECTIONS} -o ${TITLE} ${TARGET_URL} || continue
	fi

	sed -i -e "s|${LINE}|#${LINE}|g" ${FILENAME_QUEUE}
done
