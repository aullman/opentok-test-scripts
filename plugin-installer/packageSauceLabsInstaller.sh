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

RAR_CMD=rar
if ! type "$RAR_CMD" > /dev/null; then
  echo "installing WinRAR"
  curl http://www.rarlab.com/rar/rarlinux-5.3.0.tar.gz > $SCRIPTDIR/rarlinux-5.3.0.tar.gz
  tar -zxvf $SCRIPTDIR/rarlinux-5.3.0.tar.gz -C $SCRIPTDIR/
  RAR_CMD=$SCRIPTDIR/rar/rar
fi

$RAR_CMD a -r -sfx"$SCRIPTDIR/DEFAULT.sfx" -z"$SCRIPTDIR/xfs.conf" $SCRIPTDIR/SauceLabsInstaller.exe $BUILD/ManyCamSetup.exe $BUILD/install.cmd $BUILD/OpenTokPluginMain.msi

rm -r $BUILD
