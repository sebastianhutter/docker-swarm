#
# install the docker engine
#

# we need to install docker-engine 
# in a way it does not start automatically
# due to the custom storage config
install-docker:
  cmd.run:
    - name: RUNLEVEL=1 apt-get install -y docker-engine
    - shell: /bin/bash

# allow the vagrant user to access the docker stuff
docker-group:
  group.present:
    - name: docker
    - addusers:
      - vagrant

# configure the service
/etc/systemd/system/docker.service.d:
  file.recurse:
    - source: salt://docker/files/etc/systemd/system/docker.service.d
    - include_pat: "*.conf"

/etc/default:
  file.recurse:
    - source: salt://docker/files/etc/default

# reload systemd
systemctl daemon-reload:
  cmd.run:
    - onchanges:
      - file: /etc/systemd/system/docker.service.d
      - file: /etc/default

docker-service:
  service.running:
    - name: docker
    - enable: True