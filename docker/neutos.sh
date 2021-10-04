#!/bin/bash
dkp-pacman -Syuu --noconfirm && \
export DEVKITPRO=/opt/devkitpro && \
export DEVKITARM=${DEVKITPRO}/devkitARM && \
export DEVKITPPC=${DEVKITPRO}/devkitPPC && \
export PATH=${DEVKITPRO}/tools/bin:$PATH && \
git config --global user.name "$(cat /token/gh.user)" && \
git config --global user.email "$(cat /token/gh.email)" && \
git clone https://github.com/switchbrew/libnx.git libnx && \
make -C libnx -j4 && \
make -C libnx install && \
sleep 5 && \
echo "$(curl --silent "https://api.github.com/repos/Atmosphere-NX/Atmosphere/releases/latest" | grep "browser_download_url" | head -1 | grep -oE "\-([0-9a-f]{8})" | cut -c2-)" > ams.short_hash && \
git clone https://$(cat /token/gh.token)@github.com/borntohonk/NeutOS.git Atmosphere && \
git -C Atmosphere remote add upstream https://github.com/Atmosphere-NX/Atmosphere.git && \
git -C Atmosphere fetch origin && \
git -C Atmosphere fetch upstream && \
git -C Atmosphere checkout neutos && \
git -C Atmosphere reset --hard origin/neutos && \
git -C Atmosphere rebase $(cat ams.short_hash) && \
git -C Atmosphere push origin HEAD:neutos --force && \
git -C Atmosphere reset --hard origin/neutos && \
git -C Atmosphere checkout neutos && \
echo "$(curl -s "https://api.github.com/repos/CTCaer/hekate/releases/latest" | grep "tag_name" | head -1 | cut -c 17-21)" > hekate.version && \
echo "$(curl -s "https://api.github.com/repos/switchbrew/nx-hbloader/releases/latest" | grep "tag_name" | head -1 | cut -c 17-21)" > hbl.version && \
echo "$(curl -s "https://api.github.com/repos/switchbrew/nx-hbmenu/releases/latest" | grep "tag_name" | head -1 | cut -c 17-21)" > hbmenu.version && \
MAJORVER="$(grep 'define ATMOSPHERE_RELEASE_VERSION_MAJOR\b' Atmosphere/libraries/libvapours/include/vapours/ams/ams_api_version.h \
		| tr -s [:blank:] \
		| cut -d' ' -f3)" && \
MINORVER="$(grep 'define ATMOSPHERE_RELEASE_VERSION_MINOR\b' Atmosphere/libraries/libvapours/include/vapours/ams/ams_api_version.h \
	    | tr -s [:blank:] \
		| cut -d' ' -f3)" && \
MICROVER="$(grep 'define ATMOSPHERE_RELEASE_VERSION_MICRO\b' Atmosphere/libraries/libvapours/include/vapours/ams/ams_api_version.h \
		| tr -s [:blank:] \
		| cut -d' ' -f3)" && \
echo "${MAJORVER}.${MINORVER}.${MICROVER}" > ams.version && \
make -C Atmosphere dist-no-debug -j4 && \
mkdir ams && \
mv $(find Atmosphere/out/ | grep .zip | head -1) ams/temp.zip
unzip ams/temp.zip -d ams && \
rm ams/temp.zip && \
mkdir /build && \
git clone https://github.com/borntohonk/suppository.git /build/suppository && \
AMSHASH=`cat ams.short_hash` && \
AMSVER=`cat ams.version` && \
HBLVER=`cat hbl.version` && \
HEKATEVER=`cat hekate.version` && \
HBMENUVER=`cat hbmenu.version` && \
mkdir hbl && \
mkdir hbmenu && \
mkdir hekate && \
mkdir patches && \
mkdir updater && \
wget $(curl -s https://api.github.com/repos/switchbrew/nx-hbloader/releases/latest | grep "browser_download_url" | cut -d '"' -f 4) -O hbl/hbl.nsp && \
wget $(curl -s https://api.github.com/repos/switchbrew/nx-hbmenu/releases/latest | grep "browser_download_url" | cut -d '"' -f 4) -O hbmenu/temp.zip && \
wget $(curl -s https://api.github.com/repos/CTCaer/hekate/releases/latest | grep "browser_download_url" | head -1 | cut -d '"' -f 4) -O hekate/temp.zip && \
wget $(curl -s https://api.github.com/repos/borntohonk/patches/releases/latest | grep "browser_download_url" | head -1 | cut -d '"' -f 4) -O patches/temp.zip && \
wget $(curl -s https://api.github.com/repos/borntohonk/aio-neutos-updater/releases/latest | grep "browser_download_url" | head -1 | cut -d '"' -f 4) -O updater/temp.zip && \
unzip hbmenu/temp.zip -d hbmenu && \
unzip hekate/temp.zip -d hekate && \
unzip patches/temp.zip -d patches && \
unzip updater/temp.zip -d updater && \
cp -r updater/switch ams/
rm patches/temp.zip && \
mkdir ams/atmosphere/hosts && \
cp hbl/hbl.nsp ams/atmosphere/hbl.nsp && \
cp hbmenu/*.nro ams/hbmenu.nro && \
cp -r hekate/bootloader ams/ && \
cp ams/atmosphere/reboot_payload.bin ams/bootloader/payloads/fusee.bin && \
rm ams/atmosphere/reboot_payload.bin && \
cp hekate/*.bin ams/payload.bin && \
cp ams/payload.bin ams/atmosphere/reboot_payload.bin && \
cp -r patches/atmosphere ams/ && \
cp -r patches/bootloader ams/ && \
cp /build/suppository/tools/boot.dat ams/boot.dat && \
cp /build/suppository/tools/boot.ini ams/boot.ini && \
cp /build/suppository/configs/hekate_ipl.ini ams/bootloader/hekate_ipl.ini && \
cp /build/suppository/configs/emummc.txt ams/atmosphere/hosts/emummc.txt && \
cp /build/suppository/configs/sysmmc.txt ams/atmosphere/hosts/sysmmc.txt && \
cp /build/suppository/configs/exosphere.ini ams/exosphere.ini && \
cd ams; zip -r ../out/NeutOS-${AMSVER}-master-${AMSHASH}+hbl-${HBLVER}+hbmenu-${HBMENUVER}+hekate-${HEKATEVER}+patches.zip ./*; cd ../;

if
	[ -n "$(find "out" -type f -size +4000000c)" ]; then
	echo "Build size passed, continuing"
	echo "Attempting to publish a new build to github"
	res=`curl --user "borntohonk:$(cat /token/gh.token)" -X POST https://api.github.com/repos/borntohonk/NeutOS/releases \
	-d "
	{
	  \"tag_name\": \"$(cat ams.version)-$(cat ams.short_hash)-neutos\",
	  \"target_commitish\": \"master\",
	  \"name\": \"NeutOS $(cat ams.version)-$(cat ams.short_hash)-neutos\",
	  \"body\": \"![Banner](https://github.com/borntohonk/NeutOS/raw/neutos/img/banner.png)\r\n\r\n**NOTE: This is a forked variant, it is not unedited atmosphere.** \r\nThis bundle comes pre-configured for emummc usage.\r\n\r\nNeutos is a minor Atmosphere-fork, and cfw bundle maintained for myself.\r\n\r\nThere is an updater homebrew included now ( https://github.com/borntohonk/aio-neutos-updater )\r\n\r\nSigpatches are made and distributed at ( https://github.com/borntohonk/patches ), \r\nPlease file an issue with the github issue tracker, if there are any inquiries.\r\nThis github and release is automated, and was published with suppository ( https://github.com/borntohonk/suppository ) \",
	  \"draft\": false,
	  \"prerelease\": false
	}"`
	echo Create release result: ${res}
	rel_id=`echo ${res} | python -c 'import json,sys;print(json.load(sys.stdin, strict=False)["id"])'`

	curl --user "borntohonk:$(cat /token/gh.token)" -X POST https://uploads.github.com/repos/borntohonk/NeutOS/releases/${rel_id}/assets?name=$(ls out | sed -e's/./&\n/g' -e's/ /%20/g' | grep -v '^$' | while read CHAR; do test "${CHAR}" = "%20" && echo "${CHAR}" || echo "${CHAR}" | grep -E '[-[:alnum:]!*.'"'"'()]|\[|\]' || echo -n "${CHAR}" | od -t x1 | tr ' ' '\n' | grep '^[[:alnum:]]\{2\}$' | tr '[a-z]' '[A-Z]' | sed -e's/^/%/g'; done | sed -e's/%20/+/g' | tr -d '\n') --header 'Content-Type: application/zip ' --upload-file out/$(ls out)
	echo "A new build has now been published to github"
	echo "Build was completed with success on $(date)" > log/$(date +%d%B%R).success
else
	echo "Build size is too small a failure has occured!"
	echo "Build failed on $(date)" > log/$(date +%d%B%R).failure
fi