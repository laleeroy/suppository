FROM debian:unstable-slim

ENV DEBIAN_FRONTEND=noninteractive

COPY tools/hactool /bin/hactool

RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-utils apt-transport-https && \
    apt-get install -y --no-install-recommends gh sudo gcc libc6-dev ca-certificates pkg-config curl wget bzip2 xz-utils make libarchive-tools doxygen gnupg python2.7-dev python2.7 python3 python3-pip && \
    apt-get install -y --no-install-recommends git git-restore-mtime gridsite-clients && \
    apt-get install -y --no-install-recommends gdebi-core python-is-python3 && \
    apt-get install -y --no-install-recommends cmake zip unzip && \
    apt-get install -y --no-install-recommends locales && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8 && \
    apt-get clean && \
    pip install lz4 && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/local/share/keyring/ && \
    wget -O /usr/local/share/keyring/devkitpro-pub.gpg https://apt.devkitpro.org/devkitpro-pub.gpg && \
    echo "deb [signed-by=/usr/local/share/keyring/devkitpro-pub.gpg] https://apt.devkitpro.org stable main" > /etc/apt/sources.list.d/devkitpro.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends devkitpro-pacman

RUN dkp-pacman -Syyu --noconfirm switch-dev deko3d devkita64-cmake switch-cmake switch-pkg-config devkitA64 devkitA64-gdb switch-tools general-tools uam devkitARM devkitARM-gdb devkitarm-rules && \
    dkp-pacman -S --needed --noconfirm switch-portlibs && \
    dkp-pacman -S --needed --noconfirm devkitARM && \
    dkp-pacman -Scc --noconfirm

ENV LANG en_US.UTF-8
ENV DEVKITPRO=/opt/devkitpro
ENV PATH=${DEVKITPRO}/tools/bin:$PATH
ENV DEVKITARM=/opt/devkitpro/devkitARM
