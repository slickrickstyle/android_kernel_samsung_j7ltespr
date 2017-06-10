#!/bin/bash
KERNELDIR=`readlink -f .`
COMMON_ARGS="-C $(pwd) O=$(pwd)/${OUT_DIR} ARCH=arm CROSS_COMPILE=/usr/local/toolchain/UBERTC-arm-eabi-4.8/bin/arm-eabi-"
OUT_DIR=${KERNELDIR}/out
export PATH=/usr/local/toolchain/UBERTC-arm-eabi-4.8/bin:$PATH
redt=$(tput setaf 1)
redb=$(tput setab 1)
greent=$(tput setaf 2)
greenb=$(tput setab 2)
yellowt=$(tput setaf 3)
yellowb=$(tput setab 3)
bluet=$(tput setaf 4)
blueb=$(tput setab 4)
magentat=$(tput setaf 5)
magentab=$(tput setab 5)
cyant=$(tput setaf 6)
cyanb=$(tput setab 6)
whiteb=$(tput setab 7)
bold=$(tput bold)
italic=$(tput sitm)
stand=$(tput smso)
underline=$(tput smul)
normal=$(tput sgr0)
clears=$(tput clear)
	echo "$clears"
	echo ""
	echo "------------------------------------------------------"
	echo "$bold$stand                   SM-J700P Custom Build Script                   $normal"
	echo "$italic$stand                       by rick.wardenburg@xda                      $normal"
	echo "------------------------------------------------------"
	echo ""
if [ ! -f $KERNELDIR/.config ];
then
  make ${COMMON_ARGS} j7ltespr_defconfig
fi
. $KERNELDIR/.config
mv .git .git-halt
echo "Clearing DTB files ..."
rm ${OUT_DIR}/arch/arm/boot/dts/*.dtb
echo "Cross-compiling kernel ..."
cd $KERNELDIR/
make ${COMMON_ARGS}
rm -rf $KERNELDIR/BUILT_j7ltespr
mkdir -p $KERNELDIR/BUILT_j7ltespr/lib/modules
find -name '*.ko' -exec mv -v {} $KERNELDIR/BUILT_j7ltespr/lib/modules/ \;
echo ""
echo "Stripping unneeded symbols and debug info from module(s)..."
${CROSS_COMPILE}strip --strip-unneeded $KERNELDIR/BUILT_j7ltespr/lib/modules/*
mkdir -p $KERNELDIR/BUILT_j7ltespr/lib/modules/pronto
mv $KERNELDIR/BUILT_j7ltespr/lib/modules/wlan.ko $KERNELDIR/BUILT_j7ltespr/lib/modules/pronto/pronto_wlan.ko
mv ${OUT_DIR}/arch/arm/boot/zImage $KERNELDIR/BUILT_j7ltespr/
echo ""
echo "Compiling >> dtbtool <<  for device tree image ..."
cd $KERNELDIR/tools/dtbtool; make
echo ""
echo "Generating Device Tree image (dt.img) ..."
$KERNELDIR/tools/dtbtool/dtbtool -o $KERNELDIR/BUILT_j7ltespr/dt.img -s 2048 -p $KERNELDIR/scripts/dtc/ ${OUT_DIR}/arch/arm/boot/dts/ && rm $KERNELDIR/tools/dtbtool/dtbtool
cd $KERNELDIR/; mv .git-halt .git
echo ""
echo "BUILT_j7ltespr is ready."
