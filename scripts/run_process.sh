#!/bin/bash

REGION="ap-northeast-2"
ECR_REPOSITORY="257307634175.dkr.ecr.ap-northeast-2.amazonaws.com/project01-spring-petclinic"
ECR_DOCKER_IMAGE="${ECR_REPOSITORY}/project01-spring-petclinic"
ECR_DOCKER_TAG="1.0"

aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ECR_REPOSITORY};

export IMAGE=${ECR_DOCKER_IMAGE};
export TAG=${ECR_DOCKER_TAG};
docker-compose -f /home/ubuntu/Jenkins_Scripts/docker-compos.yml up -d;
