from ubuntu:14.04.2

MAINTAINER Don Hsieh <don@cepave.com>

ENV GOPATH=/root/go
ENV PATH=$PATH:$GOPATH/bin

# Port
EXPOSE 3000
EXPOSE 4001

# Update system and install Grafana dependencies
RUN apt-get update && \
  apt-get install -y git wget nodejs npm && \
  ln -s /usr/bin/nodejs /usr/bin/node && \
  mkdir /root/go && \
  echo "node ~/go/src/github.com/Cepave/grafana/open-falcon/server.js &" > /run.sh && \
  echo "cd /root/go/src/github.com/Cepave/grafana; ./grafana" >> /run.sh && \
  chmod +x /run.sh
  
# Install Go
WORKDIR /root
RUN wget https://storage.googleapis.com/golang/go1.4.2.linux-amd64.tar.gz && \
  echo "Unzipping" && \
  tar -C /usr/local -xzf go1.4.2.linux-amd64.tar.gz && \
  echo "Unzipped. Link to /usr/bin/go" && \
  ln -s /usr/local/go/bin/go /usr/bin/go

# Install Cepave version of Grafana
RUN echo "go get gopkg.in/bufio.v1" && \
  go get gopkg.in/bufio.v1 && \
  echo "go get github.com/grafana/grafana" && \
  go get github.com/grafana/grafana && \
  echo "go get github.com/Cepave/grafana" && \
  go get github.com/Cepave/grafana && \
  echo "go get complete"

# Compile front end assets and build go backend server
WORKDIR /root/go/src/github.com/Cepave/grafana
RUN echo "Compile front end assets" && \
  npm config set registry="http://registry.npmjs.org/" && \
  npm install -g grunt-cli && \
  npm i express request body-parser && \
  npm i && \
  echo "grunt" && \
  grunt && \
  echo "go build ." && \
  go build . && \
  echo "go build completed. Start apt-get clean" && \
  apt-get clean

CMD ["./grafana"]