rm -rf build_android32
mkdir build_android32 && cd build_android32

export ANDROID_NDK_PATH=/opt/toolchain/Android/ndk/android-ndk-r22b/
cmake -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK_PATH/build/cmake/android.toolchain.cmake \
		-DCMAKE_BUILD_TYPE=Release \
		-DANDROID_ABI="armeabi-v7a with NEON" \
		-DANDROID_NDK=$ANDROID_NDK_PATH \
		-DMNN_BUILD_HARD=OFF \
		-DMNN_BUILD_SHARED_LIBS=ON \
		-DMNN_FORBID_MULTI_THREAD=ON \
		-DMNN_BUILD_MINI=OFF \
		-DMNN_BUILD_CONVERTER=OFF \
		-DANDROID_PLATFORM=android-24 \
		-DMNN_LOW_MEMORY=ON \
		-DANDROID_ARM_MODE=arm                          \
		-DANDROID_ARM_NEON=TRUE \
		..

make -j20
/opt/toolchain/Android/ndk/android-ndk-r22b/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/arm-linux-androideabi/bin/strip -g -S -d --strip-debug --strip-unneeded OFF/armeabi-v7a/librkaudio_nn.so