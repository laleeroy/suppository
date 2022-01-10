#!/bin/bash
echo "$(curl -s https://api.github.com/repos/Atmosphere-NX/Atmosphere/releases | grep "browser_download_url" | head -1 | grep -oE "\-([0-9a-f]{8})" | head -1 | cut -c2-)" > ams.hash && \
echo "$(curl -s https://api.github.com/repos/borntohonk/NeutOS/releases | grep "browser_download_url" | head -1 | grep -oE "\-([0-9a-f]{8})" | head -1 | cut -c2-)" > neutos.hash && \
echo "$(curl -s "https://api.github.com/repos/CTCaer/hekate/releases/latest" | grep "tag_name" | head -1 | cut -c 17-21)" > hekate.version && \
AMSHASH=`cat ams.hash` && \
NEUTOSHASH=`cat neutos.hash` && \
if [ "$AMSHASH" = "$NEUTOSHASH" ]; then
 echo "Neutos update not needed!" && \
 exit
else
 HASH=$(curl --silent "https://api.github.com/repos/Atmosphere-NX/Atmosphere/releases" | grep "browser_download_url" | head -1 | grep -oE "\-([0-9a-f]{8})" | cut -c2-)
 git clone https://github.com/Atmosphere-NX/Atmosphere.git
 sleep 10
 git -C Atmosphere checkout $HASH
 AMSMAJORVER=$(grep 'define ATMOSPHERE_RELEASE_VERSION_MAJOR\b' Atmosphere/libraries/libvapours/include/vapours/ams/ams_api_version.h | tr -s [:blank:] | cut -d' ' -f3)
 AMSMINORVER=$(grep 'define ATMOSPHERE_RELEASE_VERSION_MINOR\b' Atmosphere/libraries/libvapours/include/vapours/ams/ams_api_version.h | tr -s [:blank:] | cut -d' ' -f3)
 AMSMICROVER=$(grep 'define ATMOSPHERE_RELEASE_VERSION_MICRO\b' Atmosphere/libraries/libvapours/include/vapours/ams/ams_api_version.h | tr -s [:blank:] | cut -d' ' -f3)
 HOS_MAJORVER=$(grep 'define ATMOSPHERE_SUPPORTED_HOS_VERSION_MAJOR\b' Atmosphere/libraries/libvapours/include/vapours/ams/ams_api_version.h | tr -s [:blank:] | cut -d' ' -f3)
 HOS_MINORVER=$(grep 'define ATMOSPHERE_SUPPORTED_HOS_VERSION_MINOR\b' Atmosphere/libraries/libvapours/include/vapours/ams/ams_api_version.h | tr -s [:blank:] | cut -d' ' -f3)
 HOS_MICROVER=$(grep 'define ATMOSPHERE_SUPPORTED_HOS_VERSION_MICRO\b' Atmosphere/libraries/libvapours/include/vapours/ams/ams_api_version.h | tr -s [:blank:] | cut -d' ' -f3)
 HBLVER=$(grep -P "APP_VERSION\t:=\t" hbl/Makefile | head -1 | cut -c 16-20)
 HBMENUVER=$(grep -P "export APP_VERSION\t:=\t" hbmenu/Makefile | head -1 | cut -c 23-27)
 HOSVER=$HOS_MAJORVER.$HOS_MINORVER.$HOS_MICROVER
 AMSVER=$AMSMAJORVER.$AMSMINORVER.$AMSMICROVER
 HEKATEVER=`cat hekate.version` && \
 AMSVER=$AMSMAJORVER.$AMSMINORVER.$AMSMICROVER && \
 HOSVER=$HOS_MAJORVER.$HOS_MINORVER.$HOS_MICROVER && \
 mkdir ams && \
 wget $(curl -s https://api.github.com/repos/Atmosphere-NX/Atmosphere/releases | grep "browser_download_url" | head -1 | cut -d '"' -f 4) -O ams/temp.zip && \
 sleep 10 && \
 unzip ams/temp.zip -d ams && \
 rm ams/temp.zip && \
 AMSHASH=`cat ams.hash` && \
 mkdir updater && \
 mkdir ams/bootloader && \
 mkdir hekate && \
 wget $(curl -s https://api.github.com/repos/CTCaer/hekate/releases/latest | grep "browser_download_url" | head -1 | cut -d '"' -f 4) -O hekate/temp.zip && \
 sleep 10 && \
 unzip hekate/temp.zip -d hekate && \
 rm hekate/temp.zip && \
 cd SigPatches && \
 python3 scripts/loader_patch.py && \
 cd ../ && \
 sleep 10 && \
 cp -r SigPatches/SigPatches/bootloader ams && \
 cp -r SigPatches/SigPatches/atmosphere ams && \
 wget $(curl -s https://api.github.com/repos/borntohonk/aio-neutos-updater/releases/latest | grep "browser_download_url" | head -1 | cut -d '"' -f 4) -O updater/temp.zip && \
 sleep 10 && \
 unzip updater/temp.zip -d updater && \
 cp -r updater/switch ams/
 mkdir ams/atmosphere/hosts && \
 mkdir hbl && \
 wget $(curl -s https://api.github.com/repos/switchbrew/nx-hbloader/releases/latest | grep "browser_download_url" | head -1 | cut -d '"' -f 4) -O hbl/hbl.nsp && \
 sleep 10 && \
 cp hbl/hbl.nsp ams/atmosphere/hbl.nsp && \
 mkdir hbmenu
 wget $(curl -s https://api.github.com/repos/switchbrew/nx-hbmenu/releases/latest | grep "browser_download_url" | head -1 | cut -d '"' -f 4) -O hbmenu/temp.zip && \
 sleep 10 && \
 unzip hbmenu/temp.zip -d hbmenu && \
 cp hbmenu/*/*.nro ams/hbmenu.nro && \
 cp -r hekate/bootloader ams/ && \
 cp hekate/*.bin ams/payload.bin && \
 mv ams/atmosphere/reboot_payload.bin ams/bootloader/payloads/fusee.bin && \
 wget $(curl -s https://api.github.com/repos/shchmue/Lockpick_RCM/releases/latest | grep "browser_download_url" | head -1 | cut -d '"' -f 4) -O ams/bootloader/payloads/Lockpick_RCM.bin && \
 sleep 10 && \
 wget $(curl -s https://api.github.com/repos/suchmememanyskill/TegraExplorer/releases/latest | grep "browser_download_url" | head -1 | cut -d '"' -f 4) -O ams/bootloader/payloads/TegraExplorer.bin && \
 sleep 10 && \
 cp ams/payload.bin ams/atmosphere/reboot_payload.bin && \
 cp configs/hekate_ipl.ini ams/bootloader/hekate_ipl.ini && \
 cp configs/emummc.txt ams/atmosphere/hosts/emummc.txt && \
 cp configs/sysmmc.txt ams/atmosphere/hosts/sysmmc.txt && \
 cp configs/exosphere.ini ams/exosphere.ini && \
 mkdir out && \
 cd ams && \
 zip -r ../out/NeutOS-${AMSVER}-master-${AMSHASH}+hbl-${HBLVER}+hbmenu-${HBMENUVER}+hekate-${HEKATEVER}+patches.zip ./* && \
 cd .. && \
 echo "zip built, proceeding with publishing release"
 res=`curl --user "$GITHUB_USER:$GITHUB_TOKEN" -X POST https://api.github.com/repos/borntohonk/NeutOS/releases \
 -d "
 {
   \"tag_name\": \"$HOSVER-$AMSVER-$AMSHASH\",
   \"target_commitish\": \"master\",
   \"name\": \"NeutOS $AMSVER-$AMSHASH for FW version $HOSVER\",
   \"body\": \"![Banner](https://github.com/borntohonk/NeutOS/raw/neutos/img/banner.png)\r\n\r\n- This release supports FW version ${HOSVER}, and sigpatches for loader, es, fs and nifm are included for this FW version. \r\n\r\n- This bundle comes pre-configured for emummc usage.\r\n\r\n- Neutos is a minor Atmosphere-fork, and cfw bundle maintained for myself.\r\n\r\n- There is an updater homebrew included now ( https://github.com/borntohonk/aio-neutos-updater )\r\n\r\n- Sigpatches are made and distributed at ( https://github.com/borntohonk/SigPatches ), \r\n\r\nPlease file an issue with the github issue tracker, if there are any inquiries.\r\n\r\nThis github and release is automated, and was published with suppository ( https://github.com/borntohonk/suppository ) \",
   \"draft\": false,
   \"prerelease\": false
 }"`
 echo Create release result: ${res}
 rel_id=`echo ${res} | python -c 'import json,sys;print(json.load(sys.stdin, strict=False)["id"])'`
 ZIPFILE=`find out -iname \*.zip`
 FILE=`ls out`
 ENCZIPFILE=`urlencode $FILE`

 curl --user "$GITHUB_USER:$GITHUB_TOKEN" -X POST https://uploads.github.com/repos/borntohonk/NeutOS/releases/${rel_id}/assets?name=$ENCZIPFILE --header 'Content-Type: application/zip ' --upload-file $ZIPFILE
fi