# syntax=docker/dockerfile:1
ARG NODE_VERSION=20
FROM node:${NODE_VERSION}-slim

LABEL maintainer="hello@wagtail.org"

RUN apt update -y \
    && apt install -y \
    dumb-init \
    make

# Download dependencies as a separate step to take advantage of Docker's caching.
# Leverage a cache mount to /root/.npm to speed up subsequent builds.
# Leverage a bind mounts to package.json and package-lock.json to avoid having to copy them into
# into this layer.
RUN --mount=type=bind,source=wagtail/package.json,target=package.json \
    --mount=type=bind,source=wagtail/package-lock.json,target=package-lock.json,rw \
    --mount=type=cache,target=/root/.npm \
    npm install

USER node

WORKDIR /code/wagtail

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

CMD ["npm", "run", "start"]
