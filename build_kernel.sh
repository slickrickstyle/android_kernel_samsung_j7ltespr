export PATH=/usr/local/toolchain/UBERTC-arm-eabi-4.8/bin:$PATH

export ARCH=arm
export CROSS_COMPILE=/usr/local/toolchain/UBERTC-arm-eabi-4.8/bin/arm-eabi-

mkdir $(pwd)/out
make -C $(pwd) O=$(pwd)/out j7ltespr_defconfig
make -C $(pwd) O=$(pwd)/out
cp $(pwd)/out/arch/arm/boot/zImage $(pwd)/arch/arm/boot/zImage
