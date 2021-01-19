# kbuildah
Fedora Kernel Builder for podman

This is a really easy to use container to automatically build fedora kernels with extra patches.

Building the vanilla kernel is as easy as running:
```bash
docker run --rm -v ${PWD}/out:/out:Z modzilla/kbuildah
```

If you want to change the kernel version, architecture, patches or fedora version use the follwing blueprint:

```bash
podman run --rm -v ${PWD}/out:/out:Z \
           -v ${PWD}/patches:/patches:Z \
           -e ARCH=x86_64 \
           -e FVER=33 \
           -e KVER=5.10.7-200 \
           -e NAME=patched \
           modzilla/kbuildah
```

### Building
To build the container image you only need to run the following command:
```bash
podman build -t local/kbuildah .
```
