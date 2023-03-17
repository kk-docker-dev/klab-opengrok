# Docker file to build Klab OpenGrok

# Base image
FROM ubuntu:focal

# About docker image
LABEL MAINTAINER="Kirubakaran Shanmugam <kribakarans@gmail.com>"
LABEL DESCRIPTION="Klab OpenGrok"

# Disable user prompt
ARG DEBIAN_FRONTEND=noninteractive

# Update and upgrade the system
RUN apt-get update && \
    apt-get upgrade -y --no-install-recommends

# Install base packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends locales tzdata

# Setting timezone
RUN ln -fs /usr/share/zoneinfo/Asia/Kolkata /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

# Setting locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8 && \
    locale-gen en_US.UTF-8

# Setting language
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Install required packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
            ca-certificates curl default-jdk gnupg-agent gpg python3-pip tree universal-ctags

# Copy source
COPY src /klab

# Install Tomcat and OpenGrok
RUN /klab/scripts/install-tomcat.sh && \
    /klab/scripts/install-opengrok.sh

RUN cp -f /klab/scripts/index-opengrok-xrefs.sh /usr/local/bin/index-xrefs

USER root
WORKDIR /root

CMD [ "/klab/startup.sh" ]
