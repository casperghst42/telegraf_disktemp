#!/bin/sh
export DOCKER_BUILDKIT=1
docker pull telegraf:latest
docker build -t casperghst42/telegraf .
