#!/bin/bash

BASE_VERSION=latest

NOME_APP=sonarqube-custom
NOME_PROJETO_APP=cicd-tools

set -e

echo "---------------------------------------------------------------------------------"
echo "- delete all (bc, is)-"
echo "---------------------------------------------------------------------------------"
oc -n ${NOME_PROJETO_APP} delete all -l app=${NOME_APP} --ignore-not-found=true
# oc -n cicd-tools-v3 delete all -l app=sonarqube --ignore-not-found=true

echo "---------------------------------------------------------------------------------"
echo "- new-build-"
echo "---------------------------------------------------------------------------------"
# cat Dockerfile | oc  -n ${NOME_PROJETO_APP} new-build --name=${NOME_APP} --dockerfile='-'  --labels="app=${NOME_APP}"

oc -n ${NOME_PROJETO_APP} new-build . --name=${NOME_APP} \
  --strategy="docker" --labels="app=${NOME_APP}"
# oc -n ${NOME_PROJETO_APP} new-build --name=${NOME_APP} \
  # --image-stream=${KIND_IMAGE_BASE}:${BASE_VERSION} \
  # --binary --labels="app=${NOME_APP}"

echo "---------------------------------------------------------------------------------"
echo "- start-build-"
echo "---------------------------------------------------------------------------------"
oc -n ${NOME_PROJETO_APP} start-build ${NOME_APP} --from-dir=. --wait

echo "---------------------------------------------------------------------------------"
echo "- get is-"
echo "---------------------------------------------------------------------------------"
oc -n ${NOME_PROJETO_APP} get is | grep ${NOME_APP}
echo "---------------------------------------------------------------------------------"
echo "- describe is-"
echo "---------------------------------------------------------------------------------"
oc -n ${NOME_PROJETO_APP} describe is | grep ${NOME_APP}

