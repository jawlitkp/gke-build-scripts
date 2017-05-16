#!/bin/sh

set -e

if [ "$PUBSUB_HOST" == "" ];
then
  echo "Please set env var PUBSUB_HOST"
  exit 1
fi

if [ "$PUBSUB_PORT" == "" ];
then
  echo "Please set env var PUBSUB_PORT"
  exit 1
fi

echo -e "Testing PubSub availability..."
while ! echo exit | busybox nc $PUBSUB_HOST $PUBSUB_PORT; do sleep 10; done
echo -e "PubSub up!"
