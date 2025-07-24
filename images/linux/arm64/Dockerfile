ARG BASE_IMAGE=ghcr.io/linuxserver/baseimage-ubuntu
ARG BASE_IMAGE_TAG=arm64v8-noble

FROM ${BASE_IMAGE}:${BASE_IMAGE_TAG} AS devel-base

ENV DEBIAN_FRONTEND="noninteractive"
ENV MAKEFLAGS="-j4" \
    PATH="/root/.cargo/bin:${PATH}" \
    PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:/usr/local/lib/aarch64-linux-gnu/pkgconfig:/usr/lib/aarch64-linux-gnu/pkgconfig"

ENV AOM=v3.12.0 \
    FDKAAC=2.0.3 \
    FFMPEG_HARD=7.1.1 \
    FONTCONFIG=2.16.0 \
    FREETYPE=2.13.3 \
    FRIBIDI=1.0.16 \
    KVAZAAR=2.3.1 \
    LAME=3.100 \
    LIBASS=0.17.3 \
    LIBDAV1D=1.5.1 \
    LIBDOVI=2.2.0 \
    LIBDRM=2.4.124 \
    LIBGL=1.7.0 \
    LIBPLACEBO=7.349.0 \
    LIBSRT=1.5.4 \
    LIBVA=2.22.0 \
    LIBVDPAU=1.5 \
    LIBVIDSTAB=1.1.1 \
    LIBWEBP=1.5.0 \
    NVCODEC=11.1.5.3 \
    OGG=1.3.5 \
    OPENCOREAMR=0.1.6 \
    OPENJPEG=2.5.3 \
    OPUS=1.5.2 \
    SHADERC=v2025.1 \
    THEORA=1.1.1 \
    VORBIS=1.3.7 \
    VPX=1.15.0 \
    VULKANSDK=vulkan-sdk-1.4.304.1 \
    X265=4.1 \
    XVID=1.3.7 \
    ZIMG=3.0.5

RUN apt-get -yqq update && \ 
    apt-get -yq --no-install-recommends install -y \
    autoconf \
    automake \
    bzip2 \
    ca-certificates \
    clang \
    cmake \
    curl \
    diffutils \
    doxygen \
    expat \
    g++ \
    gcc \
    git \
    gperf \
    jq \
    libexpat1-dev \
    libxext-dev \
    libgcc-9-dev \
    libgomp1 \
    libharfbuzz-dev \
    libpciaccess-dev \
    libssl-dev \
    libtool \
    libv4l-dev \
    libwayland-dev \
    libwayland-egl-backend-dev \
    libx11-dev \
    libx11-xcb-dev \
    libxcb-dri2-0-dev \
    libxcb-dri3-dev \
    libxcb-glx0-dev \
    libxcb-present-dev \
    libxcb-shape0-dev \
    libxml2-dev \
    libxrandr-dev \
    make \
    meson \
    nasm \
    ninja-build \
    nvidia-cuda-toolkit \
    ocl-icd-opencl-dev \
    patch \
    perl \
    pkg-config \
    python3 \
    python3-pip\
    python3-setuptools \
    python3-venv \
    python3-wheel \
    x11proto-xext-dev \
    xserver-xorg-dev \
    xz-utils \
    yasm \
    zlib1g-dev && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    mkdir -p /tmp/rust && \
    RUST_VERSION=$(curl -fsX GET https://api.github.com/repos/rust-lang/rust/releases/latest | jq -r '.tag_name') && \
    curl -fo /tmp/rust.tar.gz -L "https://static.rust-lang.org/dist/rust-${RUST_VERSION}-aarch64-unknown-linux-gnu.tar.gz" && \
    tar xf /tmp/rust.tar.gz -C /tmp/rust --strip-components=1 && \
    cd /tmp/rust && \
    ./install.sh && \
    cargo install cargo-c cbindgen --locked && \
    python3 -m venv /lsiopy && \
    pip install -U --no-cache-dir \
    pip \
    setuptools \
    wheel && \
    pip install --no-cache-dir cmake==3.31.6 mako meson ninja packaging ply pyyaml

# aom
RUN mkdir -p /tmp/aom && \
    git clone \
    --branch ${AOM} \
    --depth 1 https://aomedia.googlesource.com/aom \
    /tmp/aom
RUN cd /tmp/aom && \
    rm -rf \
    CMakeCache.txt \
    CMakeFiles && \
    mkdir -p \
    aom_build && \
    cd aom_build && \
    cmake \
    -DBUILD_STATIC_LIBS=0 .. && \
    make && \
    make install

# libdav1d
RUN mkdir -p /tmp/libdav1d && \
    git clone \
    --branch ${LIBDAV1D} \
    --depth 1 https://github.com/videolan/dav1d.git \
    /tmp/libdav1d
RUN mkdir /tmp/libdav1d/build && cd /tmp/libdav1d/build && \
    meson setup -Denable_tools=false -Denable_tests=false --libdir /usr/local/lib .. && \
    ninja install

# fdk-aac
RUN mkdir -p /tmp/fdk-aac && \
    curl -Lf \
    https://github.com/mstorsjo/fdk-aac/archive/v${FDKAAC}.tar.gz | \
    tar -zx --strip-components=1 -C /tmp/fdk-aac
RUN cd /tmp/fdk-aac && \
    autoreconf -fiv && \
    ./configure \
    --disable-static \
    --enable-shared && \
    make && \
    make install && \
    strip -d /usr/local/lib/libfdk-aac.so

# ffnvcodec
RUN mkdir -p /tmp/ffnvcodec && \
    git clone \
    --branch n${NVCODEC} \
    --depth 1 https://github.com/FFmpeg/nv-codec-headers \
    /tmp/ffnvcodec
RUN cd /tmp/ffnvcodec && \
    make install

# libgl
RUN mkdir -p /tmp/libgl && \
    curl -Lf \
    https://gitlab.freedesktop.org/glvnd/libglvnd/-/archive/v${LIBGL}/libglvnd-v${LIBGL}.tar.gz | \
    tar -xz --strip-components=1 -C /tmp/libgl
RUN cd /tmp/libgl && \
    meson setup \
    --buildtype=release \
    build && \
    ninja -C build install && \
    strip -d \
    /usr/local/lib/libEGL.so \
    /usr/local/lib/libGLdispatch.so \
    /usr/local/lib/libGLESv1_CM.so \
    /usr/local/lib/libGLESv2.so \
    /usr/local/lib/libGL.so \
    /usr/local/lib/libGLX.so \
    /usr/local/lib/libOpenGL.so

# libdrm
RUN mkdir -p /tmp/libdrm && \
    curl -Lf \
    https://dri.freedesktop.org/libdrm/libdrm-${LIBDRM}.tar.xz | \
    tar -Jx --strip-components=1 -C /tmp/libdrm
RUN cd /tmp/libdrm && \
    meson setup \
    --prefix=/usr --libdir=/usr/local/lib/aarch64-linux-gnu \
    -Dvalgrind=disabled \
    . build && \
    ninja -C build && \
    ninja -C build install && \
    strip -d /usr/local/lib/aarch64-linux-gnu/libdrm*.so

# libdovi
RUN mkdir -p /tmp/libdovi && \
    git clone \
    --branch ${LIBDOVI} \
    https://github.com/quietvoid/dovi_tool.git \
    /tmp/libdovi
RUN cd /tmp/libdovi/dolby_vision && \
    cargo cinstall --release && \
    strip -d /usr/local/lib/libdovi.so

# libplacebo
RUN mkdir -p /tmp/libplacebo && \
    git clone \
    --branch v${LIBPLACEBO} \
    --recursive https://code.videolan.org/videolan/libplacebo \
    /tmp/libplacebo
RUN cd /tmp/libplacebo && \
    meson setup \
    --prefix=/usr --libdir=/usr/local/lib/aarch64-linux-gnu \
    . build --buildtype release && \
    ninja -C build install

# libva
RUN mkdir -p /tmp/libva && \
    curl -Lf \
    https://github.com/intel/libva/archive/${LIBVA}.tar.gz | \
    tar -zx --strip-components=1 -C /tmp/libva
RUN cd /tmp/libva && \
    ./autogen.sh && \
    ./configure \
    --disable-static \
    --enable-shared && \
    make && \
    make install && \
    strip -d \
    /usr/local/lib/libva.so \
    /usr/local/lib/libva-drm.so \
    /usr/local/lib/libva-wayland.so

# libvdpau
RUN mkdir -p /tmp/libvdpau && \
    git clone \
    --branch ${LIBVDPAU} \
    --depth 1 https://gitlab.freedesktop.org/vdpau/libvdpau.git \
    /tmp/libvdpau
RUN cd /tmp/libvdpau && \
    meson setup \
    --prefix=/usr --libdir=/usr/local/lib \
    -Ddocumentation=false \
    build && \
    ninja -C build install && \
    strip -d /usr/local/lib/libvdpau.so

# shaderc
RUN mkdir -p /tmp/shaderc && \
    git clone \
    --branch ${SHADERC} \
    --depth 1 https://github.com/google/shaderc.git \
    /tmp/shaderc
RUN cd /tmp/shaderc && \
    ./utils/git-sync-deps && \
    mkdir -p build && \
    cd build && \
    cmake -GNinja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    .. && \
    ninja install

# vulkan
RUN mkdir -p /tmp/vulkan-headers && \
    git clone \
    --branch ${VULKANSDK} \
    --depth 1 https://github.com/KhronosGroup/Vulkan-Headers.git \
    /tmp/vulkan-headers
RUN cd /tmp/vulkan-headers && \
    cmake -S . -B build/ && \
    cmake --install build --prefix /usr/local

RUN mkdir -p /tmp/vulkan-loader && \
    git clone \
    --branch ${VULKANSDK} \
    --depth 1 https://github.com/KhronosGroup/Vulkan-Loader.git \
    /tmp/vulkan-loader
RUN cd /tmp/vulkan-loader && \
    mkdir -p build && \
    cd build && \
    cmake \
    -D CMAKE_BUILD_TYPE=Release \
    -D VULKAN_HEADERS_INSTALL_DIR=/usr/local/lib/aarch64-linux-gnu \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    .. && \
    make && \
    make install

# freetype
RUN mkdir -p /tmp/freetype && \
    curl -Lf \
    https://download.savannah.gnu.org/releases/freetype/freetype-${FREETYPE}.tar.gz | \
    tar -zx --strip-components=1 -C /tmp/freetype
RUN cd /tmp/freetype && \
    ./configure \
    --disable-static \
    --enable-shared && \
    make && \
    make install && \
    strip -d /usr/local/lib/libfreetype.so

# fontconfig
RUN mkdir -p /tmp/fontconfig && \
    curl -Lf \
    https://www.freedesktop.org/software/fontconfig/release/fontconfig-${FONTCONFIG}.tar.xz | \
    tar -Jx --strip-components=1 -C /tmp/fontconfig
RUN cd /tmp/fontconfig && \
    ./configure \
    --disable-static \
    --enable-shared && \
    make && \
    make install && \
    strip -d /usr/local/lib/libfontconfig.so

# fribidi
RUN mkdir -p /tmp/fribidi && \
    curl -Lf \
    https://github.com/fribidi/fribidi/archive/v${FRIBIDI}.tar.gz | \
    tar -zx --strip-components=1 -C /tmp/fribidi
RUN cd /tmp/fribidi && \
    ./autogen.sh && \
    ./configure \
    --disable-static \
    --enable-shared && \
    make -j 1 && \
    make install && \
    strip -d /usr/local/lib/libfribidi.so

# kvazaar
RUN mkdir -p /tmp/kvazaar && \
    curl -Lf \
    https://github.com/ultravideo/kvazaar/archive/v${KVAZAAR}.tar.gz | \
    tar -zx --strip-components=1 -C /tmp/kvazaar
RUN cd /tmp/kvazaar && \
    ./autogen.sh && \
    ./configure \
    --disable-static \
    --enable-shared && \
    make && \
    make install && \
    strip -d /usr/local/lib/libkvazaar.so

# lame
RUN mkdir -p /tmp/lame && \
    curl -Lf \
    http://downloads.sourceforge.net/project/lame/lame/3.100/lame-${LAME}.tar.gz | \
    tar -zx --strip-components=1 -C /tmp/lame
RUN cd /tmp/lame && \
    cp \
    /usr/share/automake-1.16/config.guess \
    config.guess && \
    cp \
    /usr/share/automake-1.16/config.sub \
    config.sub && \
    ./configure \
    --disable-frontend \
    --disable-static \
    --enable-nasm \
    --enable-shared && \
    make && \
    make install

# libass
RUN mkdir -p /tmp/libass && \
    curl -Lf \
    https://github.com/libass/libass/archive/${LIBASS}.tar.gz | \
    tar -zx --strip-components=1 -C /tmp/libass
RUN cd /tmp/libass && \
    ./autogen.sh && \
    ./configure \
    --disable-static \
    --enable-shared && \
    make && \
    make install && \
    strip -d /usr/local/lib/libass.so

# libsrt
RUN mkdir -p /tmp/libsrt && \
    curl -Lf \
    https://github.com/Haivision/srt/archive/v${LIBSRT}.tar.gz | \
    tar -zx --strip-components=1 -C /tmp/libsrt
RUN cd /tmp/libsrt && \
    cmake . && \
    make && \
    make install

# libwebp
RUN mkdir -p /tmp/libwebp && \
    curl -Lf \
    https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-${LIBWEBP}.tar.gz | \
    tar -zx --strip-components=1 -C /tmp/libwebp
RUN cd /tmp/libwebp && \
    ./configure \
    --disable-static \
    --enable-shared && \
    make && \
    make install

# ogg
RUN mkdir -p /tmp/ogg && \
    curl -Lf \
    http://downloads.xiph.org/releases/ogg/libogg-${OGG}.tar.gz | \
    tar -zx --strip-components=1 -C /tmp/ogg
RUN cd /tmp/ogg && \
    ./configure \
    --disable-static \
    --enable-shared && \
    make && \
    make install

# opencore-amr
RUN mkdir -p /tmp/opencore-amr && \
    curl -Lf \
    http://downloads.sourceforge.net/project/opencore-amr/opencore-amr/opencore-amr-${OPENCOREAMR}.tar.gz | \
    tar -zx --strip-components=1 -C /tmp/opencore-amr
RUN cd /tmp/opencore-amr && \
    ./configure \
    --disable-static \
    --enable-shared  && \
    make && \
    make install && \
    strip -d /usr/local/lib/libopencore-amr*.so

# openjpeg
RUN mkdir -p /tmp/openjpeg && \
    curl -Lf \
    https://github.com/uclouvain/openjpeg/archive/v${OPENJPEG}.tar.gz | \
    tar -zx --strip-components=1 -C /tmp/openjpeg
RUN cd /tmp/openjpeg && \
    rm -Rf \
    thirdparty/libpng/* && \
    curl -Lf \
    https://download.sourceforge.net/libpng/libpng-1.6.37.tar.gz | \
    tar -zx --strip-components=1 -C thirdparty/libpng/ && \
    cmake \
    -DBUILD_STATIC_LIBS=0 \
    -DBUILD_THIRDPARTY:BOOL=ON . && \
    make && \
    make install

# opus
RUN mkdir -p /tmp/opus && \
    curl -Lf \
    https://downloads.xiph.org/releases/opus/opus-${OPUS}.tar.gz | \
    tar -zx --strip-components=1 -C /tmp/opus
RUN cd /tmp/opus && \
    autoreconf -fiv && \
    ./configure \
    --disable-static \
    --enable-shared && \
    make && \
    make install && \
    strip -d /usr/local/lib/libopus.so

# theora
RUN mkdir -p /tmp/theora && \
    curl -Lf \
    http://downloads.xiph.org/releases/theora/libtheora-${THEORA}.tar.gz | \
    tar -zx --strip-components=1 -C /tmp/theora
RUN cd /tmp/theora && \
    cp \
    /usr/share/automake-1.16/config.guess \
    config.guess && \
    cp \
    /usr/share/automake-1.16/config.sub \
    config.sub && \
    curl -fL \
    'https://gitlab.xiph.org/xiph/theora/-/commit/7288b539c52e99168488dc3a343845c9365617c8.diff' \
    > png.patch && \
    patch ./examples/png2theora.c < png.patch && \
    ./configure \
    --disable-static \
    --enable-shared && \
    make && \
    make install

# vid.stab
RUN mkdir -p /tmp/vid.stab && \
    curl -Lf \
    https://github.com/georgmartius/vid.stab/archive/v${LIBVIDSTAB}.tar.gz | \
    tar -zx --strip-components=1 -C /tmp/vid.stab
RUN cd /tmp/vid.stab && \
    mkdir -p build && \
    cd build && \
    cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    -DBUILD_SHARED_LIBS=ON \
    -DUSE_OMP=ON \
    .. && \
    make && \
    make install && \
    ldconfig

# vorbis
RUN mkdir -p /tmp/vorbis && \
    curl -Lf \
    http://downloads.xiph.org/releases/vorbis/libvorbis-${VORBIS}.tar.gz | \
    tar -zx --strip-components=1 -C /tmp/vorbis
RUN cd /tmp/vorbis && \
    ./configure \
    --disable-static \
    --enable-shared && \
    make && \
    make install

# vpx
RUN mkdir -p /tmp/vpx && \
    curl -Lf \
    https://github.com/webmproject/libvpx/archive/v${VPX}.tar.gz | \
    tar -zx --strip-components=1 -C /tmp/vpx
RUN cd /tmp/vpx && \
    ./configure \
    --disable-debug \
    --disable-docs \
    --disable-examples \
    --disable-install-bins \
    --disable-static \
    --disable-unit-tests \
    --enable-pic \
    --enable-shared \
    --enable-vp8 \
    --enable-vp9 \
    --enable-vp9-highbitdepth && \
    make && \
    make install

# x264
RUN mkdir -p /tmp/x264 && \
    git clone --branch stable --depth 1 https://github.com/mirror/x264 /tmp/x264
RUN cd /tmp/x264 && \
    ./configure \
    --disable-cli \
    --disable-static \
    --enable-pic \
    --enable-shared && \
    make && \
    make install

# x265
RUN mkdir -p /tmp/x265 && \
    curl -Lf \
    https://bitbucket.org/multicoreware/x265_git/downloads/x265_${X265}.tar.gz | \
    tar -zx --strip-components=1 -C /tmp/x265
RUN cd /tmp/x265/build/linux && \
    ./multilib.sh && \
    make -C 8bit install

# xvid
RUN mkdir -p /tmp/xvid && \
    curl -Lf \
    https://downloads.xvid.com/downloads/xvidcore-${XVID}.tar.gz | \
    tar -zx --strip-components=1 -C /tmp/xvid
RUN cd /tmp/xvid/build/generic && \
    ./configure && \ 
    make && \
    make install

# zimg
RUN mkdir -p /tmp/zimg && \
    git clone \
    --branch release-${ZIMG} --depth 1 \
    https://github.com/sekrit-twc/zimg.git \
    /tmp/zimg
RUN cd /tmp/zimg && \
    ./autogen.sh && \
    ./configure \
    --disable-static \
    --enable-shared && \
    make && \
    make install

# ffmpeg
RUN if [ -z ${FFMPEG_VERSION+x} ]; then \
    FFMPEG=${FFMPEG_HARD}; \
    else \
    FFMPEG=${FFMPEG_VERSION}; \
    fi && \
    mkdir -p /tmp/ffmpeg && \
    echo "https://ffmpeg.org/releases/ffmpeg-${FFMPEG}.tar.bz2" && \
    curl -Lf \
    https://ffmpeg.org/releases/ffmpeg-${FFMPEG}.tar.bz2 | \
    tar -jx --strip-components=1 -C /tmp/ffmpeg

# Update library cache and verify vidstab installation
RUN ldconfig && \
    pkg-config --exists --print-errors vidstab || echo "Warning: vidstab pkg-config not found"

RUN cd /tmp/ffmpeg && \
    export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:/usr/local/lib/aarch64-linux-gnu/pkgconfig:/usr/lib/aarch64-linux-gnu/pkgconfig" && \
    ./configure \
    --ld=clang++ \
    --disable-debug \
    --disable-doc \
    --disable-ffplay \
    --enable-cuda \
    --enable-cuda-llvm \
    --enable-cuvid \
    --enable-ffprobe \
    --enable-fontconfig \
    --enable-gpl \
    --enable-libaom \
    --enable-libdav1d \
    --enable-libass \
    --enable-libfdk_aac \
    --enable-libfontconfig \
    --enable-libfreetype \
    --enable-libfribidi \
    --enable-libkvazaar \
    --enable-libmp3lame \
    --enable-libopencore-amrnb \
    --enable-libopencore-amrwb \
    --enable-libopenjpeg \
    --enable-libopus \
    --enable-libplacebo \
    --enable-libshaderc \
    --enable-libsrt \
    --enable-libtheora \
    --enable-libv4l2 \
    --enable-libvidstab \
    --enable-libvorbis \
    --enable-libvpx \
    --enable-libwebp \
    --enable-libxml2 \
    --enable-libx264 \
    --enable-libx265 \
    --enable-libxvid \
    --enable-libzimg \
    --enable-nonfree \
    --enable-nvdec \
    --enable-nvenc \
    --enable-opencl \
    --enable-openssl \
    --enable-small \
    --enable-stripping \
    --enable-vaapi \
    --enable-vdpau \
    --enable-version3 \
    --enable-vulkan \
    --extra-libs=-ldl \
    --extra-libs=-lpthread && \
    make

RUN /usr/local/lib/rustlib/uninstall.sh && \
    ldconfig && \
    mkdir -p \
    /buildout/usr/local/bin \
    /buildout/usr/lib \
    /buildout/usr/local/lib/aarch64-linux-gnu/dri \
    /buildout/usr/local/lib/aarch64-linux-gnu/vdpau \
    /buildout/usr/local/share/vulkan \
    /buildout/usr/share/libdrm \
    /buildout/etc/OpenCL/vendors && \
    cp \
    /tmp/ffmpeg/ffmpeg \
    /buildout/usr/local/bin && \
    cp \
    /tmp/ffmpeg/ffprobe \
    /buildout/usr/local/bin && \
    cp -a \
    /usr/local/lib/lib*so* \
    /buildout/usr/local/lib/ && \
    cp -a \
    /usr/local/lib/lib*so* \
    /buildout/usr/local/lib/aarch64-linux-gnu/ 2>/dev/null || true && \
    cp -a \
    /usr/local/lib/aarch64-linux-gnu/lib*so* \
    /buildout/usr/local/lib/aarch64-linux-gnu/ 2>/dev/null || true && \
    cp -a \
    /usr/share/libdrm/amdgpu.ids \
    /buildout/usr/share/libdrm/ 2>/dev/null || true && \
    cp -a \
    /usr/local/share/vulkan/* \
    /buildout/usr/local/share/vulkan/ 2>/dev/null || true && \
    echo \
    'libnvidia-opencl.so.1' > \
    /buildout/etc/OpenCL/vendors/nvidia.icd

FROM ${BASE_IMAGE}:${BASE_IMAGE_TAG} AS runtime-base

COPY --from=devel-base /buildout/ /

ARG DEBIAN_FRONTEND="noninteractive"

ENV MAKEFLAGS="-j4" \
    LD_LIBRARY_PATH="/usr/local/lib/aarch64-linux-gnu:/usr/lib/aarch64-linux-gnu" \
    LIBVA_MESSAGING_LEVEL=0 \
    LIBVA_DISPLAY=drm \
    NVIDIA_DRIVER_CAPABILITIES="compute,video,utility" \
    NVIDIA_VISIBLE_DEVICES="all"

RUN apt-get -yqq update && \
    apt-get install -yq --no-install-recommends \
    tzdata \
    fontconfig \
    fonts-noto-core \
    fonts-noto-cjk \
    libgdiplus \
    libicu-dev \
    ca-certificates \
    expat \
    libgomp1 \
    libharfbuzz-bin \
    libv4l-0 \
    libwayland-client0 \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxext6 \
    libxml2 \
    vainfo \
    hwinfo \
    clinfo \
    ocl-icd-libopencl1 && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

CMD         ["--help"]
ENTRYPOINT  ["ffmpeg"]
