This version of suppository exists to feed files to a docker container.

example usage:

```sh
 docker run --name suppository \
 --rm \
 --env GITHUB_TOKEN=$GITHUB_TOKEN \
 --volume $PWD/libnx:/libnx \
 --volume $PWD/hbmenu:/hbmenu \
 --volume $PWD/hbl:/hbl \
 --volume $PWD/suppository:/suppository \
 --volume $PWD/suppository/bundle_and_publish.sh:/bundle_and_publish.sh \
 --volume $PWD/Atmosphere:/Atmosphere \
 borntohonk/suppository:latest /bin/bash -c \
 "make -C libnx clean && \
 make -C libnx -j8 && \
 make -C libnx install && \
 make -C hbmenu clean && \
 make -C hbmenu nx -j8 && \
 make -C hbl clean && \
 make -C hbl -j8 && \
 make -C Atmosphere clean && \
 make -C Atmosphere dist-no-debug -j8 && \
 sh bundle_and_publish.sh && \
 make -C libnx clean && \
 make -C hbmenu clean && \
 make -C hbl clean && \
 make -C Atmosphere clean"
```

If you have any inquiries; file an issue with the github tracker.

pre-requisites: 
* must be able to use a text-editor (at very least) to make alterations to deploy to another repository.
* have a github access token with appropriate permissions as GITHUB_TOKEN enviroment variable
* have hbl/hbmenu/libnx/suppository/your-fork checked out to ./hbl ./hbmenu ./libnx ./Suppository ./Atmosphere (recurse-submodules for suppository)

---
Credits: [@borntohonk](https://github.com/borntohonk)
license: whichever applicable to whichever files and MIT on whatever else (not that there's anything worth licensing here)
