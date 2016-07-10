# 
# install nomad systemd service
#

# import all variables from a central location
{% import "nomad/variables.jinja" as vars %}

# copy the systemd service file
{{vars.nomad_systemd_service}}:
  file.managed:
    - template: jinja
    - source: salt://nomad/files/etc/systemd/system/nomad.service
    - watch_in:
      - cmd: systemctl-daemon-reload-nomad
    - context:
        environmentfile: {{vars.nomad_systemd_environment}}
        isserver:  {{vars.nomad_isserver}}
        datadir: {{vars.nomad_data}}
        user: {{vars.nomad_user}}


# copy the environment file
{{vars.nomad_systemd_environment}}:
  file.managed:
    - template: jinja
    - source: salt://nomad/files/etc/default/nomad.env
    - context:
        config_dir: {{vars.nomad_config}}
        

# reload the systemd daemon if the service file changes
systemctl-daemon-reload-nomad:
  cmd.wait:
    - name: systemctl daemon-reload

# make sure the nomad service is enabled
service-nomad:
  service.running:
    - name: {{vars.nomad_systemd_service_name}}
    - enable: True
    - require:
      - file: {{vars.nomad_systemd_service}}
      - cmd: systemctl-daemon-reload-nomad
