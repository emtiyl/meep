FROM ubuntu:bionic

RUN mkdir -p ~/meep &&\
    cd ~/meep &&\
    wget https://raw.githubusercontent.com/NanoComp/meep/master/contrib/build-meep.sh &&\
    chmod +x build-meep.sh &&\
    ./build-meep.sh

# Expose port 22 for local JARVICE emulation in docker
EXPOSE 22

# for standalone use
EXPOSE 5901
EXPOSE 443
