FROM debian:testing

RUN apt-get update && apt-get install -y bzip2 ca-certificates tzdata curl \
    && rm -rf /var/lib/apt/lists/*

ARG RESTIC_VERSION=0.9.6
ADD https://github.com/restic/restic/releases/download/v${RESTIC_VERSION}/restic_${RESTIC_VERSION}_linux_arm64.bz2 /
RUN bzip2 -d restic_${RESTIC_VERSION}_linux_arm64.bz2 && mv restic_${RESTIC_VERSION}_linux_arm64 /bin/restic && chmod +x /bin/restic