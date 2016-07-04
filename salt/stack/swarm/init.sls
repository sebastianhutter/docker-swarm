#
# setup a docker swarm cluster
#

{% import "swarm/variables.jinja" as vars %}

# copy the systemd configuration
/etc/systemd/system/swarm.service:
  file.managed:
    - source: salt://swarm/files/etc/systemd/system/swarm.service
    - template: jinja
    - context:
        swarm_master: {{vars.swarm_is_master}}
        advertise_ip: {{vars.swarm_advertise_ip}}
        consul_ip: {{vars.consul_address}}

# reload the daemon
reload:
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
        - file: /etc/systemd/system/swarm.service

# lets pull the swarm image
swarm-image:
  dockerng.image_present:
    - name: swarm

swarm-service:
  service.running:
    - name: swarm
    - require:
        - file: /etc/systemd/system/swarm.service
        - dockerng: swarm-image

