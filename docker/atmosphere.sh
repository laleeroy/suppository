#!/bin/bash
git clone https://github.com/Atmosphere-NX/Atmosphere.git Atmosphere && \
dkp-pacman -Syyu --noconfirm && \
make -C Atmosphere dist-no-debug -j8 && \
cp Atmosphere/out/*.zip /out/