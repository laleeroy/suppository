#!/bin/bash
if
	[ "$(curl -s https://api.github.com/repos/Atmosphere-NX/Atmosphere/releases/latest | grep "browser_download_url" | head -1 | grep -oE "\-([0-9a-f]{8})" | cut -c2-)" = "$(cat ams.short_hash)" ]
then
	echo "No need to publish a new release, exiting..." && exit
else
	rm -rf out
	mkdir out
	echo "Current commit hash does not match the latest release, rebasing..."
	docker run --rm --name suppository -v "$(pwd)"/token/gh.token:/token/gh.token -v "$(pwd)"/token/gh.user:/token/gh.user -v "$(pwd)"/token/gh.email:/token/gh.email -v "$(pwd)"/out:/out -v "$(pwd)"/compile_target.sh:/compile_target.sh borntohonk/suppository:neutos
	echo "$(curl --silent "https://api.github.com/repos/Atmosphere-NX/Atmosphere/releases/latest" | grep "browser_download_url" | head -1 | grep -oE "\-([0-9a-f]{8})" | cut -c2-)" > ams.short_hash
fi
