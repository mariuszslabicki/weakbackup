FROM debian:buster-slim

RUN apt-get update && apt-get install -y bzip2 ca-certificates cron tzdata

ARG RESTIC_VERSION=0.9.5
ARG PLATFORM
ADD https://github.com/restic/restic/releases/download/v${RESTIC_VERSION}/restic_${RESTIC_VERSION}_linux_${PLATFORM}.bz2 /
RUN bzip2 -d restic_${RESTIC_VERSION}_linux_${PLATFORM}.bz2 && mv restic_${RESTIC_VERSION}_linux_${PLATFORM} /bin/restic && chmod +x /bin/restic
