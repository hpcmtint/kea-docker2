# Docker files for building Kea containers




# Building image

You need to have Docker installed. The image can be built using the following
command:

```shell
docker build - < docker/kea-dhcp4.Dockerfile
```

This will end up with something like the following:

```shell
Successfully built <image-id>
```

# Running the image

Now you can run this image:

```shell
docker run <image-id>
```
