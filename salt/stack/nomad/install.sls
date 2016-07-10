#
# install npmad and requirements
# lots of inspiration from here: 
#

# import all variables from a central location
{% import "nomad/variables.jinja" as vars %}

# download the nomad archive (if the nomad version is not installed yet
# copied the cmd.run idea from philipps saltstack

setup-nomad:
  cmd.run:
      - name: |
          wget {{ vars.nomad_url }} && unzip {{ vars.nomad_archive }}
          mv /tmp/nomad /usr/local/bin/{{vars.nomad_bin}}
          ln -fs /usr/local/bin/{{vars.nomad_bin}} /usr/local/bin/nomad
          chmod 755 /usr/local/bin/{{vars.nomad_bin}}
      - unless: test -x /usr/local/bin/nomad && /usr/local/bin/nomad version | grep {{ vars.nomad_version }}
      - cwd: /tmp
      - shell: /bin/bash
      - timeout: 300

# create the necessary nomad folders in etc
{{vars.nomad_config}}:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

# create the nomad service user
{{vars.nomad_user}}:
  group:
    - present
  user: 
    - present
    - fullname: nomad service user
    - gid_from_name: true
    - shell: /bin/bash
    - home: /var/lib/{{vars.nomad_user}}
    - createhome: false
    - system: true

# create the nomad data directory
{{vars.nomad_data}}:
  file.directory:
    - user: {{vars.nomad_user}}
    - group: {{vars.nomad_user}}
    - mode: 755
    - makedirs: True

# copy the basic nomad configuration 
{{vars.nomad_config}}/config.hcl:
  file.managed:
    - source: salt://nomad/files/etc/nomad.d/config.hcl
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - context:
        datadir: {{vars.nomad_data}}
        advertise: {{vars.nomad_advertise_ip}}
        advertise_port_rpc: {{vars.nomad_advertise_port_rpc|int}}
        advertise_port_http: {{vars.nomad_advertise_port_http|int}}
        advertise_port_serf: {{vars.nomad_advertise_port_serf|int}}
        server: {{vars.nomad_isserver}}
        bootstrap: {{vars.nomad_bootstrap_expect}}
        consul_ip: {{vars.nomad_consul_ip}}
        consul_port: {{vars.nomad_consul_port|int}}