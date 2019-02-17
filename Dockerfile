FROM archlinux/base:latest AS builder
MAINTAINER hare1039 hare1039@hare1039.nctu.me

RUN yes | pacman -Syu &&\
    pacman -S --noconfirm git pkgconf gcc make curl sudo awk file fakeroot tar

RUN useradd --create-home --shell /bin/bash hare &&\
    echo "hare ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN git clone https://aur.archlinux.org/megatools.git megatools &&\
    chmod 777 megatools                                         &&\
    cd megatools                                                &&\
    sudo -u hare bash -c 'yes y | makepkg -sicr'

FROM archlinux/base:latest
MAINTAINER hare1039 hare1039@hare1039.nctu.me

RUN pacman -Syy &&\
    pacman -S --needed --noconfirm tar
COPY --from=builder /megatools/megatools-1.10.2-1-x86_64.pkg.tar.xz /tmp/megatools-1.10.2-1-x86_64.pkg.tar.xz

RUN cd /tmp                                                     &&\
    pacman -U --noconfirm megatools-1.10.2-1-x86_64.pkg.tar.xz
