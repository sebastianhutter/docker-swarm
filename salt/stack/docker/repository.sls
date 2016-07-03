#
# install the official docker engine repo
#

base:
  pkgrepo.managed:
    - humanname: Docker Repository
    - name: deb https://apt.dockerproject.org/repo debian-jessie main
    - dist: debian-jessie
    - file: /etc/apt/sources.list.d/docker.list
    - keyid: 58118E89F3A912897C070ADBF76221572C52609D
    - keyserver: p80.pool.sks-keyservers.net

