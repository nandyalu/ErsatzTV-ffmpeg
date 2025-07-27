ARG BASE_IMAGE=python
ARG BASE_IMAGE_TAG=3.13-slim

FROM ${BASE_IMAGE}:${BASE_IMAGE_TAG} AS devel-base

ENV DEBIAN_FRONTEND="noninteractive"
ENV MAKEFLAGS="-j4" \
    PATH="/root/.cargo/bin:${PATH}"

# Install ffmpeg using install_ffmpeg.sh script
COPY ./install_ffmpeg.sh /tmp/install_ffmpeg.sh
RUN chmod +x /tmp/install_ffmpeg.sh && \
    /tmp/install_ffmpeg.sh

# Stage 2 - Final image
FROM python:3.12-slim

# Install HW Acceleration drivers and libraries
COPY ./install_drivers.sh /tmp/install_drivers.sh
RUN chmod +x /tmp/install_drivers.sh && \
    /tmp/install_drivers.sh