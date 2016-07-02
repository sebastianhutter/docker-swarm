#
# install the official glusterfs repository
#

gluster-repo-key:
  cmd.run:
    - name: wget -O - http://download.gluster.org/pub/gluster/glusterfs/LATEST/rsa.pub | apt-key add -
    - unless: apt-key list | grep 'Elasticsearch (Elasticsearch Signing Key)'

gluster-repo:
  pkgrepo.managed:
    - humanname: Gluster Debian Repository
    - name: deb http://download.gluster.org/pub/gluster/glusterfs/LATEST/Debian/jessie/apt jessie main
    - dist: jessie
    - require:
      - cmd: gluster-repo-key