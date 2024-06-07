#!/bin/bash

IMAGE_NAME="cbr24_simulation"

docker build -f Dockerfile -t $IMAGE_NAME .
