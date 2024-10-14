rm -rf build_linux
mkdir build_linux && cd build_linux
cmake   -DCMAKE_SYSTEM_NAME=Linux \
	-DCMAKE_SYSTEM_VERSION=1 \
	-DCMAKE_SYSTEM_PROCESSOR=aarch64 \
	-DCMAKE_C_COMPILER=/opt/toolchain/arm-gnu-toolchain-12.3.rel1-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-gcc \
	-DCMAKE_CXX_COMPILER=/opt/toolchain/arm-gnu-toolchain-12.3.rel1-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-g++ \
	-DCMAKE_C_FLAGS="-O3 -march=armv8-a -mcpu=cortex-a35  -rdynamic -ldl -funwind-tables -fPIC" \
	-DCMAKE_CXX_FLAGS="-O3 -march=armv8-a -mcpu=cortex-a35  -rdynamic -ldl -funwind-tables -fPIC" \
	-DMNN_BUILD_HARD=OFF \
	-DMNN_BUILD_SHARED_LIBS=ON \
	-DMNN_FORBID_MULTI_THREAD=ON \
	-DMNN_BUILD_MINI=OFF \
	-DMNN_LOW_MEMORY=ON \
	-DMNN_BUILD_CONVERTER=OFF \
	-DCMAKE_BUILD_TYPE=Release \
	..

make -j20
/opt/toolchain/arm-gnu-toolchain-12.3.rel1-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-strip -g -S -d --strip-debug --strip-unneeded librkaudio_nn.so