#!/bin/bash

if [ -n "$1" ]; then
  BUNDLE_MANYCAM=$1
else
  BUNDLE_MANYCAM=true
fi

SCRIPTDIR=$(dirname $0)
BUILD=$SCRIPTDIR/installer
mkdir $BUILD

echo "Creating install.cmd file"
echo '@echo off' > $BUILD/install.cmd
echo 'runas /user:Administrator "reg add \"HKLM\Software\Microsoft\MicrosoftEdge\MediaCapture\" /v EnableConsentPrompt /t REG_DWORD /d 0 /f"' >> $BUILD/install.cmd

if [ $BUNDLE_MANYCAM != 'false' ]; then
  echo 'ManyCamSetup.exe /S' >> $BUILD/install.cmd
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
