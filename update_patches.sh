#!/bin/bash
cd patches && \
git config --local user.name "$(cat ../token/gh.user)" && \
git config --local user.email "$(cat ../token/gh.email)" && \
git remote set-url origin https://$(cat ../token/gh.token)@github.com/borntohonk/patches.git && \
git fetch && \
cd organize && \
python organize.py && \
cd .. && \
git add atmosphere && \
git add hekate_patches && \
git commit -m"add various new patches at $(date +%F)" && \
git push && \
cd .. && \
exit