#!/bin/bash
echo "$(curl -s "https://api.github.com/repos/CTCaer/hekate/releases/latest" | grep "tag_name" | head -1 | cut -c 17-21)" > hekate.version && \
echo "$(curl -s "https://api.github.com/repos/switchbrew/nx-hbloader/releases/latest" | grep "tag_name" | head -1 | cut -c 17-21)" > hbl.version && \
echo "$(curl -s "https://api.github.com/repos/switchbrew/nx-hbmenu/releases/latest" | grep "tag_name" | head -1 | cut -c 17-21)" > hbmenu.version && \
echo "$(curl -s "https://api.github.com/repos/Atmosphere-NX/Atmosphere/releases" | grep "tag_name" | head -1 | cut -c 18-22)" > ams.version && \
echo "$(curl -s https://api.github.com/repos/Atmosphere-NX/Atmosphere/releases | grep "browser_download_url" | head -1 | grep -oE "\-([0-9a-f]{8})" | head -1 | cut -c2-)" > ams.hash && \
echo "$(curl -s https://api.github.com/repos/borntohonk/NeutOS/releases | grep "browser_download_url" | head -1 | grep -oE "\-([0-9a-f]{8})" | head -1 | cut -c2-)" > neutos.hash && \
AMSVER=`cat ams.version` && \
HBLVER=`cat hbl.version` && \
HEKATEVER=`cat hekate.version` && \
HBMENUVER=`cat hbmenu.version` && \
AMSHASH=`cat ams.hash` && \
NEUTOSHASH=`cat neutos.hash` && \
mkdir ams && \
mv $(find Atmosphere -iname \*.zip) ams/temp.zip && \
unzip ams/temp.zip -d ams && \
rm ams/temp.zip && \
HBLVER=`cat hbl.version` && \
HEKATEVER=`cat hekate.version` && \
HBMENUVER=`cat hbmenu.version` && \
AMSHASH=`cat ams.hash` && \
mkdir hbl && \
mkdir hbmenu && \
mkdir hekate && \
mkdir temppatches && \
mkdir updater && \
wget $(curl -s https://api.github.com/repos/switchbrew/nx-hbloader/releases/latest | grep "browser_download_url" | cut -d '"' -f 4) -O hbl/hbl.nsp && \
wget $(curl -s https://api.github.com/repos/switchbrew/nx-hbmenu/releases/latest | grep "browser_download_url" | cut -d '"' -f 4) -O hbmenu/temp.zip && \
wget $(curl -s https://api.github.com/repos/CTCaer/hekate/releases/latest | grep "browser_download_url" | head -1 | cut -d '"' -f 4) -O hekate/temp.zip && \
wget $(curl -s https://api.github.com/repos/borntohonk/patches/releases/latest | grep "browser_download_url" | head -1 | cut -d '"' -f 4) -O temppatches/temp.zip && \
wget $(curl -s https://api.github.com/repos/borntohonk/aio-neutos-updater/releases/latest | grep "browser_download_url" | head -1 | cut -d '"' -f 4) -O updater/temp.zip && \
unzip hbmenu/temp.zip -d hbmenu && \
unzip hekate/temp.zip -d hekate && \
unzip temppatches/temp.zip -d temppatches && \
unzip updater/temp.zip -d updater && \
cp -r updater/switch ams/
rm temppatches/temp.zip && \
mkdir ams/atmosphere/hosts && \
cp hbl/hbl.nsp ams/atmosphere/hbl.nsp && \
cp hbmenu/*.nro ams/hbmenu.nro && \
cp -r hekate/bootloader ams/ && \
cp hekate/*.bin ams/payload.bin && \
cp ams/payload.bin ams/atmosphere/reboot_payload.bin && \
cp -r temppatches/atmosphere ams/ && \
cp -r temppatches/bootloader ams/ && \
cp suppository/tools/boot.dat ams/boot.dat && \
cp suppository/tools/boot.ini ams/boot.ini && \
cp suppository/configs/hekate_ipl.ini ams/bootloader/hekate_ipl.ini && \
cp suppository/configs/emummc.txt ams/atmosphere/hosts/emummc.txt && \
cp suppository/configs/sysmmc.txt ams/atmosphere/hosts/sysmmc.txt && \
cp suppository/configs/exosphere.ini ams/exosphere.ini && \
mkdir out && \
cd ams && \
zip -r ../out/NeutOS-${AMSVER}-master-${AMSHASH}+hbl-${HBLVER}+hbmenu-${HBMENUVER}+hekate-${HEKATEVER}+patches.zip ./* && \
cd .. && \
echo "zip built, proceeding with publishing release"
res=`curl --user "borntohonk:$GITHUB_TOKEN" -X POST https://api.github.com/repos/borntohonk/NeutOS/releases \
-d "
{
  \"tag_name\": \"$AMSVER-$AMSHASH-neutos\",
  \"target_commitish\": \"master\",
  \"name\": \"NeutOS $AMSVER-$AMSHASH-neutos\",
  \"body\": \"![Banner](https://github.com/borntohonk/NeutOS/raw/neutos/img/banner.png)\r\n\r\n**NOTE: This is a forked variant, it is not unedited atmosphere.** \r\nThis bundle comes pre-configured for emummc usage.\r\n\r\nNeutos is a minor Atmosphere-fork, and cfw bundle maintained for myself.\r\n\r\nThere is an updater homebrew included now ( https://github.com/borntohonk/aio-neutos-updater )\r\n\r\nSigpatches are made and distributed at ( https://github.com/borntohonk/patches ), \r\nPlease file an issue with the github issue tracker, if there are any inquiries.\r\nThis github and release is automated, and was published with suppository ( https://github.com/borntohonk/suppository ) \",
  \"draft\": false,
  \"prerelease\": false
}"`
echo Create release result: ${res}
rel_id=`echo ${res} | python -c 'import json,sys;print(json.load(sys.stdin, strict=False)["id"])'`
ZIPFILE=`find out -iname \*.zip`
FILE=`ls out`
ENCZIPFILE=`urlencode $FILE`

curl --user "borntohonk:$GITHUB_TOKEN" -X POST https://uploads.github.com/repos/borntohonk/NeutOS/releases/${rel_id}/assets?name=$ENCZIPFILE --header 'Content-Type: application/zip ' --upload-file $ZIPFILE