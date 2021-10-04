This version of suppository comes configured for NeutOS, and will using docker, automatically build and put togheter the latest Atmosphere release into a bundle, if there is a new version, and then automatically publish it to github.

If you have any inquiries; file an issue with the github tracker.

Docker image located at: https://hub.docker.com/r/borntohonk/suppository
How to obtain: git clone https://github.com/borntohonk/suppository.git
docker pull borntohonk/suppository:neutos
(there is a version that just builds atmosphere too, tag :atmosphere instead)

This project will run `docker run --rm --name suppository -v "$(pwd)"/token/gh.token:/token/gh.token -v "$(pwd)"/token/gh.user:/token/gh.user -v "$(pwd)"/token/gh.email:/token/gh.email -v "$(pwd)"/out:/out -v "$(pwd)"/compile_target.sh:/compile_target.sh borntohonk/suppository:neutos` to compile the atmosphere fork and publish it to github. The included Dockerfile is what the docker image is made of. It will output the compiled build into the "out" (assuming it's made) folder.

To output vanilla atmosphere instead of fork, run the following docker command instead:
`docker run --rm --name suppository -v "$(pwd)"/out:/out -v "$(pwd)"/docker/atmosphere.sh:/compile_target.sh borntohonk/suppository:neutos`
Will output vanilla atmosphere from latest master commit to an out folder if it's present.

how to use: sh check.sh (add to crontab for maximum effect)

This repository is called suppository. The primary purpose is to build and publish a forked version of atmosphere for my own personal use.

For publishing you're going to want to put your github api personal token as gh.token in token/gh.token, username as token/gh.user, email as token/gh.email (user and email are needed for rebase logic and to be able to push commits automatically to github)

pre-requisites: 
* must be able to use a text-editor (at very least) to make alterations to deploy to another repository. 
* have docker capable enviroment (x86_64 linux)


---
Credits: [@borntohonk](https://github.com/borntohonk)
license: whichever applicable to whichever files and MIT on whatever else (not that there's anything worth licensing here)
