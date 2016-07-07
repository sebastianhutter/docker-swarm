#
# setup a docker swarm cluster
#

{% import "registrator/variables.jinja" as vars %}

# copy the systemd configuration
/etc/systemd/system/registrator.service:
  file.managed:
    - source: salt://registrator/files/etc/systemd/system/registrator.service
    - template: jinja

/etc/default/registrator.env:
  file.managed:
    - source: salt://registrator/files/etc/default/registrator.env
    - template: jinja
    - context:
        consul_ip: {{vars.consul_address}}
        consul_port: {{vars.consul_port|int}}
        consul_prefix: {{vars.consul_prefix}}

# reload the daemon
reload:
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
        - file: /etc/systemd/system/registrator.service

# lets pull the swarm image
registrator-image:
  dockerng.image_present:
    - name: gliderlabs/registrator

registrator-service:
  service.running:
    - name: registrator
    - enable: True
    - require:
        - file: /etc/systemd/system/registrator.service
        - file: /etc/default/registrator.env
        - dockerng: registrator-image
    - watch:
        - file: /etc/systemd/system/registrator.service
        - file: /etc/default/registrator.env
        - dockerng: registrator-image

