#!/bin/bash

AOM_REPO="https://aomedia.googlesource.com/aom"
AOM_COMMIT="8c1aa3050e5ab883bc86e9c772be73b6d2b9d23c"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    git-mini-clone "$AOM_REPO" "$AOM_COMMIT" aom
    cd aom

    mkdir cmbuild && cd cmbuild

    # Workaround broken build system
    export CFLAGS="$CFLAGS -pthread -I/opt/ffbuild/include/libvmaf"

    cmake -DCMAKE_TOOLCHAIN_FILE="$FFBUILD_CMAKE_TOOLCHAIN" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$FFBUILD_PREFIX" -DBUILD_SHARED_LIBS=OFF -DENABLE_EXAMPLES=NO -DENABLE_TESTS=NO -DENABLE_TOOLS=NO -DCONFIG_TUNE_VMAF=1 ..
    make -j$(nproc)
    make install

    echo "Requires.private: libvmaf" >> "$FFBUILD_PREFIX/lib/pkgconfig/aom.pc"
}

ffbuild_configure() {
    echo --enable-libaom
}

ffbuild_unconfigure() {
    echo --disable-libaom
}