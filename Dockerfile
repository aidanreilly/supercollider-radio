FROM nginxproxy/forego:latest as forego-container

FROM ubuntu:20.04 as builder

ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

ENV SC_VERSION 3.12.0
ENV SC_MAJORVERSION 3.12
ENV SC_PLUGIN_VERSION 3.11.1

RUN apt-get update \
  && apt-get -y upgrade \
  && apt-get install -yq --no-install-recommends \
  build-essential \
  bzip2 \
  ca-certificates \
  cmake \
  git \
  jackd \
  libasound2-dev \
  libavahi-client-dev \
  libcwiid-dev \
  libfftw3-dev \
  libicu-dev \
  libjack-dev \
  libjack0 \
  libreadline6-dev \
  libsndfile1-dev \
  libudev-dev \
  libxt-dev \
  pkg-config \
  unzip \
  wget \
  xvfb \
  libncurses5-dev \
  ffmpeg \
  gpg \
  gnupg \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p $HOME/src \
  && cd $HOME/src \
  && wget -q https://github.com/supercollider/supercollider/releases/download/Version-$SC_VERSION/SuperCollider-$SC_VERSION-Source.tar.bz2 -O sc.tar.bz2 \
  && tar xvf sc.tar.bz2 \
  && cd SuperCollider* \
  && mkdir -p build \
  && cd build \
  && cmake -DCMAKE_BUILD_TYPE="Release" -DNATIVE=ON -DBUILD_TESTING=OFF -DSUPERNOVA=OFF -DSC_WII=OFF -DSC_QT=OFF -DSC_ED=OFF -DSC_EL=OFF -DSC_VIM=OFF .. \
  && make -j1 \
  && make install \
  && ldconfig
  #&& ls -R /usr/local/share/SuperCollider \
  #&& rm -f /usr/local/share/SuperCollider/SCClassLibrary/deprecated/$SC_MAJORVERSION/deprecated-$SC_MAJORVERSION.sc \
  
RUN cd $HOME/src \
  && wget -q https://github.com/supercollider/sc3-plugins/releases/download/Version-$SC_PLUGIN_VERSION/sc3-plugins-$SC_PLUGIN_VERSION-Source.tar.bz2 -O scplugins.tar.bz2 \
  && tar xvf scplugins.tar.bz2 \
  && cd sc3-plugins-$SC_PLUGIN_VERSION-Source \
  && mkdir -p build \
  && cd build \
  && cmake -DSC_PATH=$HOME/src/SuperCollider-$SC_VERSION-Source -DCMAKE_BUILD_TYPE=Release -DHOA_UGENS=OFF -DSUPERNOVA=OFF -DAY=OFF .. \
  && cmake --build . --config Release --target install \
  && rm -rf $HOME/src

COPY install.scd /install.scd
COPY asoundrc /root/.asoundrc
COPY startup.scd /root/.config/SuperCollider/

# Copy the forego binary from the forego-container
COPY --from=forego-container /usr/local/bin/forego /usr/local/bin/forego

RUN chmod +x /usr/local/bin/forego && \
    xvfb-run -a sclang -D /install.scd && \
    echo "ok"

FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
  && apt-get -y upgrade \
  && apt-get install -yq --no-install-recommends \
    build-essential \
    bzip2 \
    ca-certificates \
    wget \
    gnupg \
  && apt-get install -yq icecast2 darkice libasound2 libasound2-plugins alsa-utils alsa-oss jackd1 jack-tools xvfb libreadline-dev \
  && wget -qO - https://apt.kitware.com/keys/kitware-archive-latest.asc | gpg --dearmor > /usr/share/keyrings/kitware-archive-keyring.gpg \
  && echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ bionic main' | tee /etc/apt/sources.list.d/kitware.list > /dev/null \
  && apt-get update \
  && apt-get install -yq cmake \
  && apt-get clean

COPY --from=builder /usr/local /usr/local
COPY --from=builder /root /root

COPY icecast.xml /etc/icecast2/icecast.xml
COPY darkice.cfg /etc/darkice.cfg
COPY darkice.sh /etc/darkice.sh
RUN chmod +x /etc/darkice.sh
COPY sclang.sh /etc/sclang.sh
RUN chmod +x /etc/sclang.sh
COPY icecast.sh /etc/icecast.sh
RUN chmod +x /etc/icecast.sh

COPY radio /radio
COPY config.scd /radio/config.scd

COPY Procfile Procfile

EXPOSE 8000
RUN mv /etc/security/limits.d/audio.conf.disabled /etc/security/limits.d/audio.conf && \
  usermod -a -G audio root

CMD ["forego", "start"]
