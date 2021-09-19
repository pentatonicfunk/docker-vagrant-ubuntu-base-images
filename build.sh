#!/bin/bash

### For local/internal-build-machine use, not for CI/CD use!

image_versions=("18.04" "20.04")

for image_version in "${image_versions[@]}"
    do : 
        echo "[+] Checking Dockerfile: " $image_version
        DockerFile="$image_version/Dockerfile"

        if test -f "$DockerFile"; then
            echo "[+] $DockerFile ready."
        else 
            echo "[!] $DockerFile does not exist."
            exit 1
        fi
    done

 ### QEMU ?
docker run --rm --privileged docker/binfmt:a7996909642ee92942dcd6cff44b9b95f08dad64 

## okay to be error
docker buildx create --name vagrant-ubuntu-base-images

## use it
docker buildx use vagrant-ubuntu-base-images

docker buildx inspect --bootstrap
echo "[?] Verify output above, make sure platform you wanted exists, such as arm64? if you wanted it?"

echo "==========================================="
echo "[+] Pruning Build Cache"
docker builder prune \-f

for image_version in "${image_versions[@]}"
    do : 
        ## build
        echo "[+] Starting routine for $image_version"
        
        echo "[*] Building and pushing image"
        docker buildx build --no-cache --platform linux/arm64,linux/amd64 -t pentatonicfunk/vagrant-ubuntu-base-images:$image_version ./$image_version --push
        # docker buildx build --platform linux/arm64,linux/amd64 -t pentatonicfunk/vagrant-ubuntu-base-images:$image_version ./$image_version --push

        #echo "[*] Tagging image"
        #docker image tag vagrant-ubuntu-base-images/$image_version pentatonicfunk/vagrant-ubuntu-base-images:$image_version
        
        #echo "[*] Pushing image"
        #docker image push pentatonicfunk/vagrant-ubuntu-base-images:$image_version

        echo "[+] Finished routine for $image_version"
        echo "==========================================="
    done