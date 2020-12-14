#!/bin/sh
# Script for preparing a docker to be able to compile the pjsip-android library
# 2020 Bela Bursan
# v0.0.7
set -e

# docker pull ubuntu:latest
# docker volume create hello
# docker run -v hello:/home/bin -v C:/Users/bub/Desktop/SVEP/work/volume:/home/win -it ubuntu bash


WORKDIR="pjsua-builder"
NEWGIT="1"
GIT_BRANCH=""

## Colors
C="\033[96m"  # Cyan
R="\033[91m"  # Red
E="\033[0m"   # End of color
Y="\033[93m"  # Yellow color

echo "$C\n Preparing docker to be able tobuild PJSIP$E\n"
if [ $(pwd) != "/home/bin" ]; then
    echo "$R\n -Wrong directory, change to /home/bin!!\n$E"
    exit 1
fi

## Install some needed apps
echo "$C -Updating$E"
apt-get -o Acquire::Check-Valid-Until=false -o Acquire::Check-Date=false update
echo "$C -Installing nano$E"
apt install -y nano
sed -i 's/# set linenumbers/set linenumbers/g' /etc/nanorc

echo "$C -Installing git$E"
apt install -y git

## Add  user to sudoers
echo "$C Installing sudo$E"
apt-get install sudo
usermod -a -G sudo root

## prepare aliases
echo "$C -Creating aliases$E"
echo "####### A L I A S E S ####### \
\n## \
\nalias ..=\"cd ..\" \
\nalias ...=\"cd ../..\" \
\n## \
\nalias nn=\"nano\" \
\nalias l=\"ls -lh\" \
\nalias ll=\"ls -lAh\" \
\n## \
\nalias grepi=\"grep -irnI\" \
\nalias findi=\"find . -name\"\n" > ~/.bash_aliases
echo "$Y !DON'T FORGET TO RUN: source ~/.bashrc$E"


## prepare workdir
if [ "$NEWGIT" != "" ]; then
    if [ -d "$WORKDIR" ]; then
        echo "$C Removing old working directory: $WORKDIR $E"
        rm -rf "$WORKDIR"
    fi
fi

## clone git
if [ -d "$WORKDIR" ]; then
    echo "$Y -Git already cloned$E"
else
    echo "$C -Cloning git repo$E"
    git clone https://github.com/belabursan/pjsip-android-builder.git
fi

cd "$WORKDIR"
if [ "$GIT_BRANCH" != "" ]; then
    echo "$Y Checking out branch: $GIT_BRANCH$E"
    git checkout "$GIT_BRANCH"
fi
git pull

# Fix file permissions
cd "$BASEDIR/scripts"
chmod +x *

echo "\n\n   ! Now run \e[41msource ~/.bashrc\e[49m and after that got to $WORKDIR and run  \e[41m./prepare-build-system \e[49m\n\n"
