#
# install consul and requirements
# lots of inspiration from here: 
# https://www.digitalocean.com/community/tutorials/how-to-configure-consul-in-a-production-environment-on-ubuntu-14-04
#

# import all variables from a central location
{% import "consul/variables.jinja" as vars %}

# download the consul archive (if the consul version is not installed yet
# copied the cmd.run idea from philipps saltstack

setup:
  cmd.run:
      - name: |
          wget {{ vars.consul_url }} && unzip {{ vars.consul_archive }}
          mv /tmp/consul /usr/local/bin/{{vars.consul_bin}}
          ln -fs /usr/local/bin/{{vars.consul_bin}} /usr/local/bin/consul
          chmod 755 /usr/local/bin/{{vars.consul_bin}}
      - unless: test -x /usr/local/bin/consul && /usr/local/bin/consul version | grep {{ vars.consul_version }}
      - cwd: /tmp
      - shell: /bin/bash
      - timeout: 300

# create the necessary consul folders in etc
{{vars.consul_config}}:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

# create the consul service user
{{vars.consul_user}}:
  group:
    - present
  user: 
    - present
    - fullname: Consul service user
    - gid_from_name: true
    - shell: /bin/bash
    - home: /var/lib/{{vars.consul_user}}
    - createhome: false
    - system: true

# create the consul data directory
{{vars.consul_data}}:
  file.directory:
    - user: {{vars.consul_user}}
    - group: {{vars.consul_user}}
    - mode: 755
    - makedirs: True

# copy the basic consul configuration 
{{vars.consul_config}}/config.json:
  file.managed:
    - source: salt://consul/files/etc/consul.d/config.json
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - context:
        datacenter: {{vars.consul_datacenter}}
        datadir: {{vars.consul_data}}
        loglevel: {{vars.consul_loglevel}}
        syslog: {{vars.consul_enable_syslog}}
        nodename: {{vars.consul_nodename}}
        server: {{vars.consul_isserver}}
        ui: {{vars.consul_showsui}}
        advertise: {{vars.consul_advertise_ip}}
        bootstrap: {{vars.consul_bootstrap_expect}}
        client: {{vars.consul_advertise_ip}}
        port_dns: {{vars.consul_port_dns}}
        port_http: {{vars.consul_port_http}}
        port_https: {{vars.consul_port_https}}
        port_rpc: {{vars.consul_port_rpc}}
        port_serf_lan: {{vars.consul_port_serf_lan}}
        port_serf_wan: {{vars.consul_port_serf_wan}}
        port_server: {{vars.consul_port_server}}


