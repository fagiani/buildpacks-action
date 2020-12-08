#!/bin/bash -l

set -ex

image_name=""
if [ -n "$INPUT_REGISTRY" ]; then
  image_name="${INPUT_REGISTRY}/${INPUT_IMAGE}:${INPUT_TAG}"
else
  image_name="${INPUT_IMAGE}:${INPUT_TAG}"
fi

env_str=""
if [ -n "$INPUT_ENV" ]; then
  arr=(${INPUT_ENV})
  for e in "${arr[@]}"
  do
    env_str+=" --env "
    env_str+='"'$e'"'
  done
fi

buildpacks=""
if [ -n "$INPUT_BUILDPACKS" ]; then
  arr=(${INPUT_BUILDPACKS})
  for p in "${arr[@]}"
  do
    buildpacks+=" --buildpack "
    buildpacks+='"'$p'"'
  done
fi

publish=""
if [ -n "$INPUT_PUBLISH" ]; then
  publish=" --publish"
fi

command="pack build ${image_name} ${env_str} --path ${INPUT_PATH} ${buildpacks} --builder ${INPUT_BUILDER} ${publish}"
echo "::set-output name=command::${command}"
echo "::set-output name=image-name::${image_name}"
docker login --username AWS -p $(aws ecr get-login-password --region ${AWS_REGION}) ${INPUT_REGISTRY}
sh -c "${command}"
