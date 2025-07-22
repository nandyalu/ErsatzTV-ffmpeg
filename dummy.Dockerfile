ARG BUILD_VERSION=7.1.1
ARG TARGETPLATFORM=linux/amd64


# Stage 1: Determine platform suffix
FROM alpine AS platform-detector
ARG BUILD_VERSION
ARG TARGETPLATFORM

ARG PLATFORM_SUFFIX
RUN case "$TARGETPLATFORM" in \
    "linux/arm64") PLATFORM_SUFFIX="-arm64" ;; \
    "linux/arm/v7") PLATFORM_SUFFIX="-arm" ;; \
    "linux/amd64") PLATFORM_SUFFIX="" ;; \
    *) echo "Unsupported platform: $TARGETPLATFORM" && exit 1 ;; \
    esac && \
    echo "Using platform suffix: $PLATFORM_SUFFIX"


FROM jasongdove/ersatztv-ffmpeg:${BUILD_VERSION}${PLATFORM_SUFFIX}

RUN ["ffmpeg", "--help"]

CMD         ["--help"]
ENTRYPOINT  ["ffmpeg"]
