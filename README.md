# docker-grafana
Dockerfile for Grafana

## Build

Enter the following command in the repo directory.

```
$sudo docker build --tag="grafana:v1" --force-rm=true .
```

## Run

```
sudo docker run -ti --name grafana -p 3000:3000 -p 4001:4001 grafana:v1 sh /run.sh
```

