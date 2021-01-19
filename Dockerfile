FROM fedora:33
LABEL maintainer="modzilla99 <'github.com/modzilla99'>"

ENV ARCH x86_64
ENV FVER 33
ENV KVER 5.10.7-200
ENV NAME patched


RUN sudo dnf -y install fedpkg fedora-packager rpmdevtools ncurses-devel nss-tools pesign 'dnf-command(builddep)' && dnf -y clean all
RUN dnf -y builddep kernel && dnf -y clean all

RUN useradd -s /sbin/nologin -g mock mockbuild
ADD --chown=root:root compile.sh /bin/compile


WORKDIR /root

ENTRYPOINT ["/bin/compile"]