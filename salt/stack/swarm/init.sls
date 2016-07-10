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

/etc/default/swarm.env:
  file.managed:
    - source: salt://swarm/files/etc/default/swarm.env
    - template: jinja
    - context:
        advertise_ip: {{vars.swarm_advertise_ip}}
        advertise_port: {{vars.swarm_advertise_port|int}}
        consul_ip: {{vars.consul_address}}
        consul_port: {{vars.consul_port|int}}
        consul_prefix: {{vars.consul_prefix}}

# reload the daemon
reload-swarm:
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
    - enable: True
    - require:
        - file: /etc/systemd/system/swarm.service
        - file: /etc/default/swarm.env
        - dockerng: swarm-image
    - watch:
        - file: /etc/systemd/system/swarm.service
        - file: /etc/default/swarm.env
        - dockerng: swarm-image

