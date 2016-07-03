# 
# install consul systemd service
#

# import all variables from a central location
{% import "consul/variables.jinja" as vars %}

# copy the systemd service file
{{vars.consul_systemd_service}}:
  file.managed:
    - template: jinja
    - source: salt://consul/files/etc/systemd/system/consul.service
    - watch_in:
      - cmd: systemctl-daemon-reload

# copy the environment file
{{vars.consul_systemd_environment}}:
  file.managed:
    - template: jinja
    - source: salt://consul/files/etc/default/consul.env

# reload the systemd daemon if the service file changes
systemctl-daemon-reload:
  cmd.wait:
    - name: systemctl daemon-reload

# make sure the consul service is enabled
service-consul:
  service.running:
    - name: {{vars.consul_systemd_service_name}}
    - enable: True
    - require:
      - file: {{vars.consul_systemd_service}}
      - cmd: systemctl-daemon-reload
