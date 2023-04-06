# Docker file to build KLAB OpenGrok

# Base image
FROM klab/ubuntu:latest

# About this docker image
LABEL MAINTAINER="Kirubakaran Shanmugam <kribakarans@gmail.com>"
LABEL DESCRIPTION="KLAB OpenGrok"

# Install required packages
RUN apt-get update && \
    apt-get upgrade -y --no-install-recommends && \
    apt-get install -y --no-install-recommends \
            curl default-jdk python3-pip universal-ctags wget

#--------------------------------------------------------------#
#                                                              #
#                 Installing Tomcat web server                 #
#                                                              #
#--------------------------------------------------------------#

ARG DIRTOMCAT=/opt/tomcat
ARG SRCPKG=apache-tomcat-10.0.27.tar.gz
RUN useradd -m -d ${DIRTOMCAT} -U -s /bin/false tomcat && \
    wget --no-verbose --show-progress \
         --quiet --progress=bar:force:noscroll \
           https://github.com/atomixcloud/archives/releases/download/apache/${SRCPKG} && \
    tar -xf ${SRCPKG} -C ${DIRTOMCAT} --strip=1 && \
    chown -R tomcat:tomcat ${DIRTOMCAT} && \
    rm -f ${SRCPKG}

#--------------------------------------------------------------#
#                                                              #
#    Installing OpenGrok source code cross reference engine    #
#                                                              #
#--------------------------------------------------------------#

ARG DIROPENGROK=/opengrok
ARG SRCPKG=opengrok-1.8.1.tar.gz
ARG DIRWEBAPP=/opt/tomcat/webapps
RUN mkdir -p ${DIROPENGROK}/data && \
    mkdir -p ${DIROPENGROK}/dist && \
    mkdir -p ${DIROPENGROK}/etc  && \
    mkdir -p ${DIROPENGROK}/src  && \
    mkdir -p ${DIROPENGROK}/log  && \
    wget --no-verbose --show-progress \
         --quiet --progress=bar:force:noscroll \
           https://github.com/atomixcloud/archives/releases/download/opengrok/${SRCPKG} && \
    tar -xf ${SRCPKG} -C ${DIROPENGROK}/dist --strip=1 && \
    pip install --quiet ${DIROPENGROK}/dist/tools/opengrok-tools.tar.gz && \
    opengrok-deploy -c ${DIROPENGROK}/etc/configuration.xml ${DIROPENGROK}/dist/lib/source.war ${DIRWEBAPP} && \
    rm -f ${SRCPKG}

# Copy source
COPY src /klab
RUN cp -f /klab/scripts/index-xrefs.sh /usr/local/bin/index-xrefs

USER root
WORKDIR /root

CMD [ "/klab/init.sh" ]
