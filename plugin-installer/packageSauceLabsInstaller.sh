#!/bin/bash

if [ -n "$1" ]; then
  URL=$1
else
  URL=https://static.opentok.com/v2.7
fi

SCRIPTDIR=$(dirname $0)
BUILD=$SCRIPTDIR/installer
mkdir $BUILD

PATH_TO_PLUGIN=$URL/plugin/OpenTokPluginMain.msi
echo "Downloading the OpenTok Plugin from: $PATH_TO_PLUGIN"
curl $PATH_TO_PLUGIN > $BUILD/OpenTokPluginMain.msi

VERSION=`curl $URL/plugin/VERSION`
echo "Plugin version is $VERSION"

echo "Creating install.cmd file"
echo '@echo off' > $BUILD/install.cmd
echo '@msiexec /i OpenTokPluginMain.msi' >> $BUILD/install.cmd
echo '@echo ^<?xml version="1.0"?^>^<TokBox^>^<DevSel Allow="1"/^>^</TokBox^> > %appdata%\TokBox\OpenTokPluginMain\'$VERSION'\Config\OTConfig.xml' >> $BUILD/install.cmd
echo '@ManyCamSetup.exe /S' >> $BUILD/install.cmd

cp $SCRIPTDIR/ManyCamSetup.exe $BUILD/

cd $BUILD

RAR_CMD=rar
if ! type "$RAR_CMD" > /dev/null; then
  echo "installing WinRAR"
  curl http://www.rarlab.com/rar/rarlinux-x64-5.3.0.tar.gz > ./rarlinux-x64-5.3.0.tar.gz
  tar -zxvf ./rarlinux-x64-5.3.0.tar.gz
  RAR_CMD=./rar/rar
fi

$RAR_CMD a -r -sfx"./rar/default.sfx" -z"../xfs.conf" ../SauceLabsInstaller.exe ManyCamSetup.exe install.cmd OpenTokPluginMain.msi
