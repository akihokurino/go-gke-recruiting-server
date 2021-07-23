#!/usr/bin/env bash

APP_ROOT=$(dirname $0)/..
cd ${APP_ROOT}

VER=${VER:-local-$(date +%Y%m%d%H%M)}
PROJECT=gke-go-sample-dev
K8S_PATH=$1

gcloud config set project ${PROJECT}

export IMAGE=gcr.io/${PROJECT}/batch:${VER}
docker build . -t ${IMAGE} --build-arg _ENTRYPOINT=entrypoint/batch/main.go --target deploy
docker login -u oauth2accesstoken -p "$(gcloud auth print-access-token)" https://gcr.io
docker push ${IMAGE}

gcloud container clusters get-credentials batch-cluster --zone=asia-northeast1-c
envsubst < ${K8S_PATH} | cat | kubectl apply -f -

docker rmi -f `docker images | grep "gcr.io/gke-go-sample" | awk '{print $3}'`
docker rmi -f `docker images | grep "<none>" | awk '{print $3}'`
