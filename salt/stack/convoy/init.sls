#
# installs and configures the convoy storage plugin
#

{% import "convoy/variables.jinja" as vars %}

# download and install convoy
install-convoy:
  cmd.run:
    - name: |
        curl -Ls https://github.com/rancher/convoy/releases/download/v{{vars.convoy_version}}/convoy.tar.gz | tar xz --strip-components=1 -C /usr/local/bin
    - unless: test -x /usr/local/bin/convoy && /usr/local/bin/convoy -v | grep v{{vars.convoy_version}}
    - cwd: /tmp
    - shell: /bin/bash
    - timeout: 300

# install the convoy docker plugin
/etc/docker/plugins/convoy.spec:
  file.managed:
    - source: salt://convoy/files/etc/docker/plugins/convoy.spec
    - tempate: jinja
    - makedirs: True

# service defaults
/etc/default/convoy:
  file.managed:
    - source: salt://convoy/files/etc/default/convoy
    - template: jinja
    - context:
        storagedriver: {{vars.convoy_driver}}
        glusterservers: {{vars.convoy_gluster_servers|join(',')}}
        glustervolume: {{vars.convoy_gluster_volume}}

# create the systemd unit
/etc/systemd/system/convoy.service:
  file.managed:
    - source: salt://convoy/files/etc/systemd/system/convoy.service
    - template: jinja

# start the service
convoy-service:
  service.running:
    - name: convoy
    - enable: True
    - require:
        - file: /etc/systemd/system/convoy.service
        - file: /etc/default/convoy

# reload the daemon
reload-convoy:
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
        - file: /etc/systemd/system/convoy.service
        - file: /etc/default/convoy

# add a sudoers entry so consul can run a check command
/etc/sudoers.d/10-consul-check:
  file.managed:
    - contents: |
        consul ALL = NOPASSWD: /usr/local/bin/convoy info
