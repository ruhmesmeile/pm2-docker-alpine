FROM mhart/alpine-node:0.12
MAINTAINER Keymetrics <contact@keymetrics.io>

RUN npm install pm2@next -g

VOLUME ["/app"]

# Expose ports
EXPOSE 80 443

WORKDIR /app

# Start process.yml
CMD ["pm2-docker", "start", "--auto-exit", "--env", "production", "server-pm2.json"]
