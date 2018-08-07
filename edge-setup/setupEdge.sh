#!/bin/bash

if [ -n "$1" ]; then
  BUNDLE_MANYCAM=$1
else
  BUNDLE_MANYCAM=true
fi

if [ -n "$2" ]; then
  DOMAIN=$2
else
  DOMAIN=localhost
fi

if [ -n "$3" ]; then
  PORT=$3
else
  PORT=9876
fi

SCRIPTDIR=$(dirname $0)
BUILD=$SCRIPTDIR/installer
mkdir $BUILD

echo "Updating install.cmd file"
cp $SCRIPTDIR/install.cmd $BUILD/install.cmd
sed -i -e "s/{DOMAIN}/$DOMAIN/g"  $BUILD/install.cmd
sed -i -e "s/{PORT}/$PORT/g"  $BUILD/install.cmd

if [ $BUNDLE_MANYCAM != 'false' ]; then
  echo '.\ManyCamSetup.exe /S' >> $BUILD/install.cmd
fi

cp $SCRIPTDIR/ManyCamSetup.exe $BUILD/

cd $BUILD

RAR_CMD=rar
if ! type "$RAR_CMD" > /dev/null; then
  echo "installing WinRAR"
  RAR_URL="http://www.rarlab.com/rar/rarlinux-x64-5.4.0.tar.gz"
  case $OSTYPE in
    darwin*) RAR_URL="http://www.rarlab.com/rar/rarosx-5.4.0.tar.gz";;
    linux*) ;;
  esac
  curl -L $RAR_URL > ./rar.tar.gz
  tar -zxvf ./rar.tar.gz
  RAR_CMD=./rar/rar
fi

if [ $BUNDLE_MANYCAM != 'false' ]; then
  $RAR_CMD a -iadm -r -sfx"../../plugin-installer/Win64.SFX" -z"../../plugin-installer/xfs.conf" ../EdgeSetup.exe ManyCamSetup.exe install.cmd
else
  $RAR_CMD a -iadm -r -sfx"../../plugin-installer/Win64.SFX" -z"../../plugin-installer/xfs.conf" ../EdgeSetup.exe install.cmd
fi