#!/bin/bash

IMAGE_NAME="cbr24_simulation"

XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth-n
touch $XAUTH
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

CONTAINER_NAME="${IMAGE_NAME}_container"
running_container="$(docker container ls -al | grep $CONTAINER_NAME)"
if [ -z "$running_container" ]; then
  echo "Iniciando o container $CONTAINER_NAME pela primeira vez!"
else
  echo "Perceba que o container $CONTAINER_NAME já existe. Vou tentar conectar para você."
  eval "docker start $CONTAINER_NAME"
  exit 0
fi

gpu="" # "--gpus all"

docker run \
  $gpu \
  -it \
  --network host \
  --privileged \
  --volume=$XSOCK:$XSOCK:rw \
  --volume=$XAUTH:$XAUTH:rw \
  --env="XAUTHORITY=${XAUTH}" \
  --env DISPLAY=$DISPLAY \
  --env TERM=xterm-256color \
  --name $CONTAINER_NAME \
  $IMAGE_NAME \
  /bin/bash

