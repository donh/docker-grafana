FROM golang:1.4.2

MAINTAINER Don Hsieh <don@cepave.com>

ENV GRAFANA_DIR=/go/src/grafana

RUN \
  apt-get update && \
  apt-get -y install nodejs npm && \
  ln -s /usr/bin/nodejs /usr/bin/node && \
  git clone https://github.com/Cepave/grafana.git $GRAFANA_DIR

WORKDIR $GRAFANA_DIR

RUN \
  npm config set registry="http://registry.npmjs.org/" && \
  npm install -g grunt-cli && \
  npm i express request body-parser && \
  npm i && \
  grunt && \
  go get ./... && \
  go build

COPY run.sh /run.sh

# Port
EXPOSE 3000 4001

# Start
CMD /run.sh
