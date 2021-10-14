This version of suppository exists to feed files to a docker container.

example usage:

```
docker run --name suppository --rm --env GITHUB_TOKEN=$GITHUB_TOKEN --volume $PWD/bundle_and_publish.sh:/bundle_and_publish.sh --detach borntohonk/suppository:latest /bin/bash -c "git clone https://$GITHUB_TOKEN@github.com/borntohonk/NeutOS Atmosphere && git clone https://github.com/switchbrew/libnx.git libnx && git clone https://github.com/borntohonk/suppository.git suppository && make -C libnx -j4 && make -C libnx install && make -C Atmosphere dist-no-debug -j4 && sh bundle_and_publish.sh"
```

If you have any inquiries; file an issue with the github tracker.

pre-requisites: 
* must be able to use a text-editor (at very least) to make alterations to deploy to another repository.
* have a github access token with appropriate permissions as GITHUB_TOKEN enviroment variable

---
Credits: [@borntohonk](https://github.com/borntohonk)
license: whichever applicable to whichever files and MIT on whatever else (not that there's anything worth licensing here)
