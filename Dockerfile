FROM ubuntu:18.04

ENV STEAM_USER_UID=1000
ENV STEAM_USER_NAME=steam
ENV STEAM_USER_GROUP=users
ENV STEAM_USER_DIR="/home/${STEAM_USER_NAME}"

ARG DEBIAN_FRONTEND=noninteractive

RUN adduser ${STEAM_USER_NAME} --uid ${STEAM_USER_UID} --ingroup ${STEAM_USER_GROUP} --home ${STEAM_USER_DIR} --disabled-password

RUN echo steam steam/question select "I AGREE" | debconf-set-selections \
 && echo steam steam/license note '' | debconf-set-selections

RUN dpkg --add-architecture i386 \
 && apt-get update \
 && apt-get install -y --no-install-recommends --no-install-suggests \
    ibsdl2-2.0-0:i386 \
    ca-certificates \
    steamcmd \
    locales \
 && apt-get clean autoclean \
 && apt-get autoremove -y \
 && dpkg-reconfigure locales \
 && rm -rf /var/lib/apt/lists/* \
 && ln -s /usr/games/steamcmd /usr/bin/steamcmd

RUN steamcmd +login anonymous +quit

WORKDIR ${STEAM_USER_DIR}

VOLUME ${STEAM_USER_DIR}