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
docker build - < kea-dhcp4/Dockerfile
```

This will end up with something like the following:

```shell
Successfully built <image-id>
```

# Running the image

At the very least, you should tweak the following:

- add a configuration (subnets and options, probably also shared networks,
  classes and much more) to `/etc/kea/kea-dhcp4.conf`.
- configure TLS
- possibly configure leases, host, and/or config backends to point to specific databases

Now you can run this image:

```shell
docker run <image-id>
```

# Running multiple services together.

`kea-dhcp4` and `kea-ctrl-agent` services can be used together. Their images can be be built with command:

```shell
docker compose build
```

Both containers can then be run with:

```shell
docker compose up
```

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
