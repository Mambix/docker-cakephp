#!/bin/bash

gitLabel=`git branch | grep \* | cut -d ' ' -f2`
docker build --build-arg debug_mode=--no-dev -t mambix/cakephpbase:$gitLabel .
docker tag mambix/cakephpbase:$gitLabel mambix/cakephpbase:$gitLabel
docker push mambix/cakephpbase:$gitLabel
