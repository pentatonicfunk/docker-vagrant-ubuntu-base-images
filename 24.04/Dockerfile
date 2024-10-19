FROM ubuntu:24.04

LABEL maintainer="pentatonicfunk@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

# install common dependencies
# ca-certificates usually needed by vagrant to download stuff
# some others are just attempt to speed the provision up
# python-is-python3: https://askubuntu.com/a/1455214, python3 is default python in 22.04
RUN apt-get update && apt-get install -y \
    locales \
    curl \
    lsb-release \
    openssh-server \
    sudo \
    python-is-python3 \
    ca-certificates \
    gnupg2 \
    software-properties-common \
    apt-utils \
    iputils-ping \
    net-tools \
    nano \
    less

## in case ca-cert already installed, force upgrade ( to get latest chain )
RUN apt-get upgrade -y ca-certificates

# ensure we have the en_US.UTF-8 locale available
RUN locale-gen en_US.UTF-8

# reuse ( rename ) `ubuntu` user as `vagrant`
# background story: https://bugs.launchpad.net/cloud-images/+bug/2005129 https://askubuntu.com/questions/1513927/ubuntu-24-04-docker-images-now-includes-user-ubuntu-with-uid-gid-1000
RUN usermod -l vagrant ubuntu
RUN usermod -d /home/vagrant -m vagrant
RUN usermod -s /bin/bash vagrant

# setup the vagrant user to comply with vagrant's expectations
RUN echo vagrant:vagrant | chpasswd \
    && echo 'vagrant ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && mkdir -p /etc/sudoers.d \
    && echo 'vagrant ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/vagrant \
    && chmod 0440 /etc/sudoers.d/vagrant

# add the vagrant insecure public key
RUN mkdir -p /home/vagrant/.ssh \
    && chmod 0700 /home/vagrant/.ssh \
    && wget --no-check-certificate \
      https://raw.githubusercontent.com/hashicorp/vagrant/main/keys/vagrant.pub \
      -O /home/vagrant/.ssh/authorized_keys \
    && chmod 0600 /home/vagrant/.ssh/authorized_keys \
    && chown -R vagrant /home/vagrant/.ssh

# don't clean packages, we might be using vagrant-cachier
RUN rm /etc/apt/apt.conf.d/docker-clean

# create the privilege separation directory for sshd
RUN mkdir -p /run/sshd

# run sshd in the foreground
CMD /usr/sbin/sshd -D \
    -o UseDNS=no\
    -o UsePAM=no\
    -o PasswordAuthentication=yes\
    -o PidFile=/tmp/sshd.pid
