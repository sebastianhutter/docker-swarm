#
# install and configure dnsmasq
#

{% import "dnsmasq/variables.jinja" as vars %}

dnsmasq:
  pkg.installed

dnsmasq-service:
  service.running:
    - name: dnsmasq
    - enable: True
    - watch:
        - file: /etc/dnsmasq.d/10-servers.conf
        - file: /etc/dnsmasq.d/00-interfaces.conf

/etc/dnsmasq.d/10-servers.conf:
  file.managed:
    - source: salt://dnsmasq/files/etc/dnsmasq.d/10-servers.conf
    - template: jinja
    - require:
        - pkg: dnsmasq
    - context:
        servers: {{vars.dnsmasq_servers}}

/etc/dnsmasq.d/00-interfaces.conf:
  file.managed:
    - source: salt://dnsmasq/files/etc/dnsmasq.d/00-interfaces.conf
    - template: jinja
    - require:
        - pkg: dnsmasq
    - context:
        listen_interfaces: {{vars.dnsmasq_listen_interfaces}}