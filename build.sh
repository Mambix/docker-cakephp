#!/bin/bash

docker build --build-arg debug_mode=--no-dev -t mambix/cakephpbase:php7.2.14-apache .
docker tag mambix/cakephpbase:php7.2.14-apache mambix/cakephpbase:php7.2.14-apache
docker push mambix/cakephpbase:php7.2.14-apache
