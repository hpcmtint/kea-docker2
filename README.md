# Docker files for building Kea containers

This is a repository that one day hopes to rise to the rank of being an official
ISC Kea Docker repository. There is a long way ahead before this could happen.
Use with caution!

Those Docker files and images are based on Alpine 3.15.

You probably want to mount the following volumes:



Strictly speaking, you don't need to mount any of them. If you don't, Kea will
run on the defaults provided, but those will almost never work for you. At the
very least, you should mount `/etc/kea` with your own config file that
corresponds to your actual network.

# Building image

You need to have Docker installed. The image can be built using the following
command:

```shell
cd kea-dhcp4 && docker build -t kea4 .
```

If user wants to install specific Kea version, not the onde defined
in dockerfile build argument `VERSION` is required

```shell
cd kea-dhcp4 && docker build --build-arg VERSION=2.3.8-r20230530063557 -t kea4 .
```

If a user has access to premium packages, it should be added during the build process:

```shell
cd kea-dhcp4 && docker build --build-arg VERSION=2.3.8-r20230530063557 --build-arg TOKEN=<TOKEN> -t kea4 . 
```

If provided token grants access to subcribers or enterprise packages it should be specified:

```shell
cd kea-dhcp4 && docker build --build-arg VERSION=2.3.8-r20230530063557 --build-arg TOKEN=<TOKEN> --build-arg PREMIUM=ENTERPRISE -t kea4 . 
```

This will end up with something like the following:

```shell
Successfully built <image-id>
```

# Running the image

Containers are using supervisor to run two processes, control agent for exposing Kea
API channel and one kea process (kea-dhcp4, kea-dhcp6 and kea-dhcp-ddns)

Each container has its default configuration included, this is why it's possible to run it without any additional changes:

```shell
sudo docker run -p host_ip:host_port:container_port kea4
```

There are two ways to change Kea configuration. Via command control channel by sending `config-set` command or by overwritting files in docker:

```shell
sudo docker run --volume=./:/etc/kea  \
                -p host_ip:host_port:container_port <image-id>
```

or

```shell
sudo docker run --volume=./kea-dhcp4.conf:/etc/kea/kea-dhcp4.conf  \
                -p host_ip:host_port:container_port <image-id>
```

By default containers are exposing `/var/lib/kea` so users can have easy access to leases files. Option `--volume=./:/var/lib/kea` should be added on docker startup:

```shell
sudo docker run --volume=./config/kea:/etc/kea  \
                --volume=./:/var/lib/kea  \
                -p host_ip:host_port:container_port <image-id>
```

# OneClick Kea server

OneClick script allows for easy deployment of kea-dhcp server. (Including kea-dhcp4, kea-dhcp6 and postgresql lease database)

- Edit `.env` file to set your parameters.
- Run `./build_images.sh` to prepare kea images
- Run `docker compose up` to run all containers


## Support

For information about ISC, Stork, Kea and for purchasing professional technical support from ISC, see our website.
Development and maintenance of Kea and Stork is funded by your support contracts. The kea-users mailing list
(https://lists.isc.org/mailman/listinfo/kea-users) is a resource for free community support. Please subscribe in
order to post. We would love feedback about how this Docker image is working for you!

## Documentation

Documentation for Kea is available on [ReadTheDocs](https://kea.readthedocs.io).
Further documentation, including many short FAQs is available in [ISC's Knowledgebase](kb.isc.org/).

## Issues

To report a bug, navigate to our project repository. Please try searching for your issue first in case someone else
has already logged it.

## License

Kea and Stork are licensed under the MPL2.0 license.
