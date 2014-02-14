#!/bin/sh

apktool d $1 $2
cd $2
mkdir source
unzip $1 -d source
cd source
dex2jar classes.dex
# use jd-gui get whole java files
