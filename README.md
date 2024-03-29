# PJSIP and PJSUA builder for Android
This repo contains a couple of scripts that downloads all neccessary components and builds the PJSIP/PJSUA lib for Android(armeabi-v7a and arm64-v8a)

## Step 1 (only Windows)
Work in a docker if you are on Windows. Open Windows power shell and execute the following commands:
 - docker pull ubuntu:latest
 - docker volume create pjsip_volume
 - docker run -v pjsip_volume:/home/bin -v C:/Users/boss/work/volume:/home/win -it ubuntu bash (Make sure that C:/Users/boss/work/volume:/home/win is a directory you have access to)
 - in docker console: cd /home/bin
 - apt update && apt install nano
 - nano docker_prepare.sh
 - now copy the content from the git repo to the newly opened file and save
 - chmod +x docker_prepare.sh

## Step 1 (MAC and Linux)
Clone the pjsua-builder git repository

## Step 2 (only Windows)
In the console, go to /home/bin and execute the shell script:
 - ./docker_prepare.sh
 (Sometimes you have to set the right permissions: chmod +x docker_prepare.sh)

## Step 3
Got to "pjsua-builder" directory and run ./configure
It is possible to run ./configure X to open and edit the config file
When done, run ./build

It shall result in a libpjsua.zip file in the working directory.


## Versions
* Openssl    : 1.1.1h 
* Openh264   : 2.1.1 
* Swig       : 4.0.2 
* Opus       : 1.3.1 
* Pjsip      : 2.11.1
* Android ndk: r21d 

It is possible to set versions in the scripts/config file, open by running ./configure x
First time run with "-f" flag, it forces everything needed to be installed, ( ./configure -f )
