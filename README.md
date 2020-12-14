# PJSIP and PJSUA builder for Android
This repo contains a couple of scripts that downloads all neccessary components and builds the PJSIP/PJSUA lib for Android

## Step 1
Work in a docker. Open Windows power shell and execute the following commands:
 - docker pull ubuntu:latest
 - docker run -v [path_to_directory_in_your_home_directory]:/home/bin  -it ubuntu bash

 Copy the prepare_docker.sh to that directory.

## Step 2
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
* Pjsip      : 2.10 
* Android ndk: r21d 

It is possible to set versions in the scripts/config file, open by running ./configure x