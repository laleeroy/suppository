FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-utils && \
    apt-get install -y --no-install-recommends sudo ca-certificates pkg-config curl wget bzip2 xz-utils make libarchive-tools doxygen gnupg python3 python3-pip && \
    apt-get install -y --no-install-recommends git git-restore-mtime && \
    apt-get install -y --no-install-recommends gdebi-core python-is-python3 && \
    apt-get install -y --no-install-recommends cmake zip unzip && \
    apt-get install -y --no-install-recommends locales && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8 && \
    apt-get clean && \
    pip install lz4 && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/devkitPro/pacman/releases/latest/download/devkitpro-pacman.amd64.deb && \
    gdebi -n devkitpro-pacman.amd64.deb && \
    rm devkitpro-pacman.amd64.deb && \
    dkp-pacman -Scc --noconfirm

ENV LANG en_US.UTF-8

RUN dkp-pacman -Syyu --noconfirm switch-dev deko3d devkita64-cmake switch-cmake switch-pkg-config devkitA64 devkitA64-gdb switch-tools general-tools uam devkitARM devkitARM-gdb devkitarm-rules && \
    dkp-pacman -S --needed --noconfirm switch-portlibs && \
    dkp-pacman -S --needed --noconfirm devkitARM hactool && \
    dkp-pacman -Scc --noconfirm

RUN mkdir /out && \
    mkdir /token

COPY start.sh /start.sh
COPY neutos.sh /neutos.sh
COPY atmosphere.sh /atmosphere.sh

ENV DEVKITPRO=/opt/devkitpro
ENV PATH=${DEVKITPRO}/tools/bin:$PATH
ENV DEVKITARM=/opt/devkitpro/devkitARM

VOLUME ["/out"]
VOLUME ["/token/gh.token"]
VOLUME ["/token/gh.user"]
VOLUME ["/token/gh.email"]
VOLUME ["/compile_target.sh"]
ENTRYPOINT ["/bin/sh","start.sh"]
