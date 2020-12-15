#/bin/bash

IMAGE=msts/apache-prometheus-exporter

VERSION=$(grep "^# VERSION" Dockerfile | awk -F: '{ print $2 }')
RELEASE=${RELEASE:-0}
VSTRING=${VERSION}.${RELEASE}
COMMIT_HASH=$(git rev-parse HEAD)

REGISTRY=434875166128.dkr.ecr.us-east-1.amazonaws.com

echo "Building ${IMAGE} Release ${VSTRING} from commit hash ${COMMIT_HASH}"

build_args="--rm"

if [ ! -z ${SQUASH} ]
then
    build_args="--rm --squash"
fi

time docker build ${build_args} \
    -t ${REGISTRY}/${IMAGE}:${VSTRING} \
    -t ${REGISTRY}/${IMAGE}:latest \
    .

if [ ! -z ${SQUASH} ]
then
    echo -e "\nPush to registry ${REGISTRY}: \n"
    echo -e "\taws-mfa"
    echo -e "\teval \$(aws-mfa)"
    echo -e "\tdocker push ${REGISTRY}/${IMAGE}:${VSTRING}"
fi

exit 0
