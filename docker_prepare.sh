#!/bin/bash
# Script for preparing a docker to be able to compile the pjsip-android library
# 2020 Bela Bursan
# v1.1.0
set -e

# Commands to open a docker:
#   docker run --rm --privileged ubuntu hwclock -s    (to fix time issue)
#   docker pull ubuntu:latest
#   docker volume create hello
#   docker run -v hello:/home/bin -v C:/Users/bub/Desktop/SVEP/work/volume:/home/win -it ubuntu bash


NAME="Bela Bursan"
EMAIL="bela.bursan@svep.se"

NEWGIT="1"
GIT_REPO="pjsua_builder"
GIT_SITE="git@repository.svep.se:002-171"
GIT_BRANCH=""

## Colors
C="\033[96m"  # Cyan
R="\033[91m"  # Red
E="\033[0m"   # End of color
Y="\033[93m"  # Yellow color

echo -e "$C\n Preparing docker to be able tobuild PJSIP$E\n"
if [ $(pwd) != "/home/bin" ]; then
    echo -e "$R\n -Wrong directory, change to /home/bin!!\n$E"
    exit 1
fi


echo -e "$Y Preparing git\nM A K E  S U R E that name and email is set properly!!$E"
read  -n 1 -p "Is your name \"$NAME\" and email <$EMAIL> correct?  (y/n): " input
if [ "$input" != "y" ]; then
    echo -e "\n\nOpen the script and change NAME and EMAIL variables at the top.\n"
    exit 0
fi
echo -e "\
[user]\
\n    email = $EMAIL\
\n    name = $NAME\
\n[core]\
\n    editor = nano\
\n[alias]\
\n    s = status\
\n    co = checkout\
\n    b = branch\
\n    tree = log --oneline --decorate --all --graph\
\n    com = checkout master\
\n" > /root/.gitconfig


# Copy ssh public key to root/.ssh. The ssh key shall be registered on GitLab
# The key should be copied to the /home/bin/.ssh directory before running this script
if [ -d "/home/bin/.ssh" ]; then
    echo -e "$Y -Copying ssh public key to /root\n"

    mkdir -p /root/.ssh
    cp /home/bin/.ssh/* /root/.ssh
fi


## Install some needed apps
echo -e "$C -Updating$E"
apt-get -o Acquire::Check-Valid-Until=false -o Acquire::Check-Date=false update
echo -e "$C -Installing nano$E"
apt install -y nano
sed -i 's/# set linenumbers/set linenumbers/g' /etc/nanorc
sed -i 's/# set tabsize 8/set tabsize 4/g' /etc/nanorc

echo -e "$C -Installing ssh $E"
apt install -y ssh

echo -e "$C -Installing git$E"
apt install -y git

## Add  user to sudoers
echo -e "$C Installing sudo$E"
apt-get install sudo
usermod -a -G sudo root


## prepare aliases
echo -e "$C -Creating aliases$E"
echo -e "####### A L I A S E S ####### \
\n## \
\nalias ..=\"cd ..\"\
\nalias ...=\"cd ../..\"\
\nalias home=\"cd /home/bin\"\
\nalias work=\"cd /home/bin/$GIT_REPO\"\
\n## \
\nalias nn=\"nano\"\
\nalias l=\"ls -lh\"\
\nalias ll=\"ls -lAh\"\
\n##\
\nalias lineon=\"sed -i 's/# set linenumbers/set linenumbers/g' /etc/nanorc\"\
\nalias lineoff=\"sed -i 's/set linenumbers/# set linenumbers/g' /etc/nanorc\"\
\nalias grepi=\"grep -irnI\"\
\nalias findi=\"find . -name\"\n" > ~/.bash_aliases
echo -e "$Y !DON'T FORGET TO RUN: source ~/.bashrc$E"


## prepare git
if [ "$NEWGIT" != "" ]; then
    if [ -d "$GIT_REPO" ]; then
        echo -e "$C Removing old working directory: $GIT_REPO $E"
        rm -rf "$GIT_REPO"
    fi
fi

## clone git
if [ -d "$GIT_REPO" ]; then
    echo -e "$Y -Git already cloned$E"
else
    echo -e "$C -Cloning git repo$E"
    git clone "$GIT_SITE/$GIT_REPO.git"
fi

cd "$GIT_REPO"
if [ "$GIT_BRANCH" != "" ]; then
    echo -e "$Y Checking out branch: $GIT_BRANCH$E"
    git checkout "$GIT_BRANCH"
fi
git pull

# Fix file permissions
chmod +x configure build
cd "scripts"
chmod +x *

echo -e "\n\n$Y   Docker prepared\n   ! Now run $R""source ~/.bashrc$Y and after that got to $GIT_REPO and run $R./configure && ./build\n$E"
