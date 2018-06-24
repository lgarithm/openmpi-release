FROM ubuntu:bionic

ADD sources.list.ustc /etc/apt/sources.list
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && \
    apt install -y make cmake g++
WORKDIR /work
