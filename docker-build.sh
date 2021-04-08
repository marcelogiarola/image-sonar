#!/bin/bash

## docker login 
## url do registry docker do openshift
# OCP_REGISTRY=$(oc get route docker-registry -n default -o 'jsonpath={.spec.host}{"\n"}') || exit 1
OCP_REGISTRY=docker-registry-default.ocp.ecad.org.br

## logar no registry docker do openshift
echo $OCP_REGISTRY
docker login -u $(oc whoami) -p $(oc whoami -t) ${OCP_REGISTRY} || exit 1

## Projeto onde a imagem será criada. Se colocar no projeto openshift todos os usuários vão poder ver.
#export TARGET_OCP_PROJECT=openshift
export TARGET_OCP_PROJECT=openshift
## nome da imagem a ser gerada
export KIND_IMAGE_BASE=sonarqube-custom
## versão da imagem a ser gerada
export BASE_VERSION=latest

# ## gera a imagem baseada no Dockerfile corrente 
# echo "---------------------------------------------------------------------------------"
# echo "- docker build-"
# echo "---------------------------------------------------------------------------------"
# docker build --no-cache -t $OCP_REGISTRY/$TARGET_OCP_PROJECT/$KIND_IMAGE_BASE:$BASE_VERSION . || exit 1
# # docker build --no-cache -t $OCP_REGISTRY/$TARGET_OCP_PROJECT/$KIND_IMAGE_BASE:$BASE_VERSION . || exit 1

# ## Apenas para exibir que a imagem ainda está local
# echo "---------------------------------------------------------------------------------"
# echo "- docker images-"
# echo "---------------------------------------------------------------------------------"
# docker images | grep $KIND_IMAGE_BASE

## envia a imagem para o docker registry do openshift
echo "---------------------------------------------------------------------------------"
echo "- docker push $OCP_REGISTRY/$TARGET_OCP_PROJECT/$KIND_IMAGE_BASE:$BASE_VERSION -"
echo "---------------------------------------------------------------------------------"
docker push $OCP_REGISTRY/$TARGET_OCP_PROJECT/$KIND_IMAGE_BASE:$BASE_VERSION 

## link da versão desejada para o latest
# oc tag -n $TARGET_OCP_PROJECT --alias=true $TARGET_OCP_PROJECT/$KIND_IMAGE_BASE:$BASE_VERSION $TARGET_OCP_PROJECT/$KIND_IMAGE_BASE:latest

echo "---------------------------------------------------------------------------------"
echo "- oc get is-"
echo "---------------------------------------------------------------------------------"
oc get is -n $TARGET_OCP_PROJECT | grep $KIND_IMAGE_BASE

echo "---------------------------------------------------------------------------------"
echo "- oc describe is-"
echo "---------------------------------------------------------------------------------"
oc describe is -n $TARGET_OCP_PROJECT $KIND_IMAGE_BASE 

