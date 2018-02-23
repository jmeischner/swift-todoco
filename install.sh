#!/usr/bin/env bash

BASEDIR=$(basename $(pwd))

if [ "$BASEDIR" == "todoco" ]
then
  swift build -c release >/dev/null 2>&1
  cp ./.build/release/todoco /usr/local/bin
  echo "todoco was successfully installed."
else
  echo "You have to execute this script in the todoco directory."
fi