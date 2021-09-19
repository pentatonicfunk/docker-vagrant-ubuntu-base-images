Vagrant compatible Ubuntu docker images


### Available Versions / tags
- 18.04
- 20.04


### Contributing / Building Note
> you wouldn't understand, because i don't

## Useful links
https://www.docker.com/blog/getting-started-with-docker-for-arm-on-linux/
https://medium.com/platformer-blog/lets-publish-a-docker-image-to-docker-hub-using-a-github-action-f0b17e5cceb3

## Verify docker buildx
```
docker buildx --help
```

## Register Arm executables to run on x64 machines
```
docker run --rm --privileged docker/binfmt:a7996909642ee92942dcd6cff44b9b95f08dad64 
```
a7996909642ee92942dcd6cff44b9b95f08dad64 = https://hub.docker.com/r/docker/binfmt/tags?page=1&ordering=last_updated

To verify the qemu handlers are registered properly, run the following and make sure the first line of the output is “enabled”.  Note that the handler registration doesn’t survive a reboot, but could be added to the system start-up scripts. REVERIFY AND REDO
```
$ cat /proc/sys/fs/binfmt_misc/qemu-aarch64
enabled
interpreter /usr/bin/qemu-aarch64
flags: OCF
offset 0
magic 7f454c460201010000000000000000000200b7
``` 