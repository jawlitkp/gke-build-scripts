#!/bin/sh

test_mysql () {
  mysqladmin -h "${MYSQL_HOST}" ping
}

COUNT=0
# Chain tests together by using &&
until ( test_mysql )
do
  ((COUNT=$COUNT+1))
  if [ $COUNT -gt 200 ]
  then
    echo "MySQL didn't become ready in time"
    exit 1
  fi
  sleep 0.1
done
