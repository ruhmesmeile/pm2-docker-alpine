FROM mhart/alpine-node:0.12
MAINTAINER Keymetrics <contact@keymetrics.io>

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh

# build tools for native dependencies
RUN apk add --update make gcc g++ python git

# install graphicsmagick from source because install via apk not working
ENV PKGNAME=graphicsmagick
ENV PKGVER=1.3.25
ENV PKGSOURCE=http://downloads.sourceforge.net/$PKGNAME/$PKGNAME/$PKGVER/GraphicsMagick-$PKGVER.tar.lz

# Installing graphicsmagick dependencies
RUN apk add --update lzip \
                     wget \
                     ffmpeg \
                     libjpeg-turbo-dev \
                     libpng-dev \
                     libtool \
                     libgomp && \
    wget $PKGSOURCE && \
    lzip -d -c GraphicsMagick-$PKGVER.tar.lz | tar -xvf - && \
    cd GraphicsMagick-$PKGVER && \
    ./configure \
      --build=$CBUILD \
      --host=$CHOST \
      --prefix=/usr \
      --sysconfdir=/etc \
      --mandir=/usr/share/man \
      --infodir=/usr/share/info \
      --localstatedir=/var \
      --enable-shared \
      --disable-static \
      --with-modules \
      --with-threads \
      --with-gs-font-dir=/usr/share/fonts/Type1 \
      --with-quantum-depth=16 && \
    make && \
    make install && \
    cd / && \
    rm -rf GraphicsMagick-$PKGVER && \
    rm GraphicsMagick-$PKGVER.tar.lz

RUN npm install pm2@next -g

VOLUME ["/app"]

# Expose ports
EXPOSE 80 443

WORKDIR /app

# Start process.yml
CMD ["pm2-docker", "start", "--auto-exit", "--env", "production", "server-pm2.json"]
