#!/bin/bash

dockerLabel=`git branch | grep \* | cut -d ' ' -f2`
docker build --build-arg debug_mode=--no-dev -t mambix/cakephpdeploy:$dockerLabel .
docker tag mambix/cakephpdeploy:$dockerLabel mambix/cakephpdeploy:$dockerLabel
# docker push mambix/cakephpdeploy:$dockerLabel

# if [ $dockerLabel == "master" ]; then
#     tag=`php -r "include_once './config/build.php'; echo APP_VERSION;"`
#     echo "Tagging with $tag"
#     git tag "$tag" --force
#     # git push
#     git push --tags --force
#     docker tag mambix/cakephpdeploy:$dockerLabel mambix/cakephpdeploy:"$tag"
#     docker push mambix/cakephpdeploy:"$tag"
# fi
