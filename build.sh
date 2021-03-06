#!/bin/bash

### For local/internal-build-machine use, not for CI/CD use!

image_versions=("18.04" "20.04")
DOCKER_ID="pentatonicfunk"
DOCKER_IMAGE_BASE_NAME="vagrant-ubuntu-base-images"
DOCKER_QEMU_LATEST="a7996909642ee92942dcd6cff44b9b95f08dad64"

for image_version in "${image_versions[@]}"; do
  :
  echo "[+] Checking Dockerfile: " $image_version
  DockerFile="$image_version/Dockerfile"

  if test -f "$DockerFile"; then
    echo "[+] $DockerFile ready."
  else
    echo "[!] $DockerFile does not exist."
    exit 1
  fi
done

# delete previous builder instance
docker buildx rm $DOCKER_IMAGE_BASE_NAME

### QEMU ?
docker run --rm --privileged docker/binfmt:$DOCKER_QEMU_LATEST
## more arch ?
docker run --privileged --rm tonistiigi/binfmt --install all

## okay to be error
docker buildx create --name $DOCKER_IMAGE_BASE_NAME

## use it
docker buildx use $DOCKER_IMAGE_BASE_NAME

docker buildx inspect --bootstrap
echo "[?] Verify output above, make sure platform you wanted exists, such as arm64? if you wanted it?"

echo "==========================================="
echo "[+] Pruning Build Cache"
docker builder prune -f

for image_version in "${image_versions[@]}"; do
  :
  ## build
  echo "[+] Starting routine for $image_version"

  echo "[*] Building and pushing image"
  # honestly dont know arm64 vs arm64/v8 difference, me sad
  docker buildx build --no-cache --platform linux/arm64/v8,linux/amd64 -t $DOCKER_ID/$DOCKER_IMAGE_BASE_NAME:$image_version ./$image_version --push
  # docker buildx build --platform linux/arm64,linux/amd64 -t pentatonicfunk/vagrant-ubuntu-base-images:$image_version ./$image_version --push

  ## MANUAL TAG and PUSH
  #echo "[*] Tagging image"
  #docker image tag vagrant-ubuntu-base-images/$image_version pentatonicfunk/vagrant-ubuntu-base-images:$image_version

  #echo "[*] Pushing image"
  #docker image push pentatonicfunk/vagrant-ubuntu-base-images:$image_version

  echo "[+] Finished routine for $image_version"
  echo "==========================================="
done
