ARG BASE_IMAGE=python
ARG BASE_IMAGE_TAG=3.13-slim

FROM ${BASE_IMAGE}:${BASE_IMAGE_TAG} AS devel-base

ENV DEBIAN_FRONTEND="noninteractive"
ENV MAKEFLAGS="-j4" \
    PATH="/root/.cargo/bin:${PATH}"

# Install ffmpeg using install_ffmpeg.sh script
COPY /images-python/linux/amd64/install_ffmpeg.sh /tmp/install_ffmpeg.sh
RUN chmod +x /tmp/install_ffmpeg.sh && \
    /tmp/install_ffmpeg.sh

# Install HW Acceleration drivers and libraries
COPY /images-python/linux/amd64/install_drivers.sh /tmp/install_drivers.sh
RUN chmod +x /tmp/install_drivers.sh && \
    /tmp/install_drivers.sh

CMD         ["--help"]
ENTRYPOINT  ["ffmpeg"]
