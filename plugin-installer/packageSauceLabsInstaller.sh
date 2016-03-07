#!/bin/bash

if [ -n "$1" ]; then
  URL=$1
else
  URL=https://tbdev.tokbox.com/v2
fi

if [ -n "$2" ]; then
  FAKE_DEVICES=$2
else
  FAKE_DEVICES=true
fi

SCRIPTDIR=$(dirname $0)
BUILD=$SCRIPTDIR/installer
mkdir $BUILD

PATH_TO_PLUGIN=$URL/plugin/OpenTokPluginMain_x32.msi
echo "Downloading the OpenTok Plugin from: $PATH_TO_PLUGIN"
curl $PATH_TO_PLUGIN > $BUILD/OpenTokPluginMain.msi

VERSION=`curl $URL/plugin/VERSION`
echo "Plugin version is $VERSION"

echo "Creating install.cmd file"
echo '@echo off' > $BUILD/install.cmd
echo '@msiexec /i OpenTokPluginMain.msi' >> $BUILD/install.cmd

if [ $FAKE_DEVICES != 'false' ]; then
  echo '@echo ^<?xml version="1.0"?^>^<OpenTokPlugin^>^<DevSel AlwaysAllow="1" FakeDevices="0"/^>^</OpenTokPlugin^> > %appdata%\TokBox\OpenTokPluginMain\'$VERSION'\Config\OTConfig.xml' >> $BUILD/install.cmd
else
  echo '@echo ^<?xml version="1.0"?^>^<OpenTokPlugin^>^<DevSel AlwaysAllow="1" FakeDevices="1"/^>^</OpenTokPlugin^> > %appdata%\TokBox\OpenTokPluginMain\'$VERSION'\Config\OTConfig.xml' >> $BUILD/install.cmd
fi

cd $BUILD

RAR_CMD=rar
if ! type "$RAR_CMD" > /dev/null; then
  echo "installing WinRAR"
  curl http://www.rarlab.com/rar/rarlinux-x64-5.3.0.tar.gz > ./rarlinux-x64-5.3.0.tar.gz
  tar -zxvf ./rarlinux-x64-5.3.0.tar.gz
  RAR_CMD=./rar/rar
fi

$RAR_CMD a -r -sfx"../Win64.SFX" -z"../xfs.conf" ../SauceLabsInstaller.exe install.cmd OpenTokPluginMain.msi
