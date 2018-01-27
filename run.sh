#!/bin/bash

CONNECTION="${USER_NAME_ROOT}/${PASSWORD_ROOT}@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=${HOST})(Port=${PORT}))(CONNECT_DATA=(SID=${SID})))"

if [ "$REFRESH" == "true" ] 
then
  sqlplus "${CONNECTION}" @/tmp/clean.sql ${USER_NAME} ${PASSWORD} ${TABLESPACE}
fi

sqlplus "${CONNECTION}" @/tmp/script.sql ${USER_NAME} ${PASSWORD} ${TABLESPACE}

imp "${USER_NAME_ROOT}/${PASSWORD_ROOT}@${HOST}:${PORT}/${SID}" FROMUSER=${USER_NAME} TOUSER=${USER_NAME} FILE=/var/app/dataload/${DUMP_FILE} LOG=/tmp/imp_${DUMP_FILE}.log

echo "Exiting..." 
exit -1
