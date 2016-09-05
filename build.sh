#!/bin/sh
TARGET=$1
OS=$(uname)
echo $OS $TARGET

case $OS in
  Linux)
    openfl $TARGET linux
    ;;
  Darwin)
    openfl $TARGET mac
    ;;
  *)
    echo "Unknown OS: $OS"
esac
