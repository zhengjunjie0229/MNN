rm -rf build_android64
mkdir build_android64 && cd build_android64

export ANDROID_NDK_PATH=/opt/toolchain/Android/ndk/android-ndk-r22b/
cmake -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK_PATH/build/cmake/android.toolchain.cmake \
		-DCMAKE_BUILD_TYPE=Release \
		-DANDROID_ABI="arm64-v8a" \
		-DANDROID_NDK=$ANDROID_NDK_PATH \
		-DMNN_BUILD_HARD=OFF \
		-DMNN_BUILD_SHARED_LIBS=ON \
		-DMNN_FORBID_MULTI_THREAD=ON \
		-DMNN_BUILD_MINI=OFF \
		-DMNN_BUILD_CONVERTER=OFF \
		-DANDROID_PLATFORM=android-26 \
		-DCMAKE_C_FLAGS="-Os" \
		-DCMAKE_CXX_FLAGS="-Os" \
		-DMNN_LOW_MEMORY=ON \
		-DANDROID_ARM_MODE=arm                          \
		-DANDROID_ARM_NEON=TRUE \
		..

make -j20
/opt/toolchain/Android/ndk/android-ndk-r22b/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64/aarch64-linux-android/bin/strip -g -S -d --strip-debug --strip-unneeded OFF/arm64-v8a/librkaudio_nn.so