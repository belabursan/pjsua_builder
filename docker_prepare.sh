#!/bin/sh
# Script for preparing a docker to be able to compile the pjsip-android library
# 2020 Bela Bursan
# v1.0.1
set -e

# docker pull ubuntu:latest
# docker volume create hello
# docker run -v hello:/home/bin -v C:/Users/bub/Desktop/SVEP/work/volume:/home/win -it ubuntu bash


NEWGIT="1"
GIT_REPO="pjsua_builder"
GIT_SITE="git@repository.svep.se:002-171"
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

if [ $# -gt 0 ]; then
    if [ "bela" = "$1" ]; then
        echo "$G Creating gitconfig for $1 \n"
        echo "\
 [user]\
 \n    email = bela.bursan@svep.se\
 \n    name = Bela Bursan\
 \n[core]\
 \n    editor = nano\
 \n[alias]\
 \n    s = status\
 \n    co = checkout\
 \n    b = branch\
 \n    tree = log --oneline --decorate --all --graph\
 \n    com = checkout master\
 \n" > /root/.gitconfig
        if [ -d ".ssh" ]; then
            echo "$Y -Copying .ssh to /root\n"
            cp -r .ssh /root
        fi
    fi
 fi

## Install some needed apps
echo "$C -Updating$E"
apt-get -o Acquire::Check-Valid-Until=false -o Acquire::Check-Date=false update
echo "$C -Installing nano$E"
apt install -y nano
sed -i 's/# set linenumbers/set linenumbers/g' /etc/nanorc
sed -i 's/# set tabsize 8/set tabsize 4/g' /etc/nanorc

echo "$C -Installing ssh $E"
apt install -y ssh

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


## prepare git
if [ "$NEWGIT" != "" ]; then
    if [ -d "$GIT_REPO" ]; then
        echo "$C Removing old working directory: $GIT_REPO $E"
        rm -rf "$GIT_REPO"
    fi
fi

## clone git
if [ -d "$GIT_REPO" ]; then
    echo "$Y -Git already cloned$E"
else
    echo "$C -Cloning git repo$E"
    git clone "$GIT_SITE/$GIT_REPO.git"
fi

cd "$GIT_REPO"
if [ "$GIT_BRANCH" != "" ]; then
    echo "$Y Checking out branch: $GIT_BRANCH$E"
    git checkout "$GIT_BRANCH"
fi
git pull

# Fix file permissions
chmod +x configure build
cd "scripts"
chmod +x *

echo "\n\n$Y   ! Now run $R""source ~/.bashrc$Y and after that got to $GIT_REPO and run $R./configure && ./build\n$E"
