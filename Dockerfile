FROM golang:1.4.2

MAINTAINER Don Hsieh <don@cepave.com>

ENV GRAFANA_DIR=/go/src/github.com/Cepave/grafana

# Install Grafana
RUN \
  apt-get update && \
  apt-get -y install nodejs npm && \
  ln -s /usr/bin/nodejs /usr/bin/node && \
  go get github.com/Cepave/grafana

WORKDIR $GRAFANA_DIR

RUN \
  npm config set registry="http://registry.npmjs.org/" && \
  npm install -g grunt-cli && \
  npm i && \
  grunt build && \
  go build .

COPY run.sh /run.sh
COPY cfg.json $GRAFANA_DIR/cfg.json

# Port
EXPOSE 3000 4001

# Start
CMD ["/run.sh"]