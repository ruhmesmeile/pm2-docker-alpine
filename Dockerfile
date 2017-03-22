FROM mhart/alpine-node:0.12
MAINTAINER Keymetrics <contact@keymetrics.io>

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh

# build tools for native dependencies
RUN apk add --update make gcc g++ python git

# graphicsmagick
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories;
RUN apk add --update graphicsmagick && rm -rf /var/cache/apk/*

RUN npm install pm2@next -g

VOLUME ["/app"]

# Expose ports
EXPOSE 80 443

WORKDIR /app

# Start process.yml
CMD ["pm2-docker", "start", "--auto-exit", "--env", "production", "server-pm2.json"]
