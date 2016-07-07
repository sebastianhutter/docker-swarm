#
# install and configure dnsmasq
#


dnsmasq:
  pkg.installed

dnsmasq-service:
  service.running:
    - name: dnsmasq
    - enable: True
    - watch:
        - file: /etc/dnsmasq.d/10-consul.conf

/etc/dnsmasq.d/10-consul.conf:
  file.managed:
    - source: salt://dnsmasq/files/etc/dnsmasq.d/10-consul.conf
    - template: jinja
    - require:
        - pkg: dnsmasq

/etc/resolv.conf:
  file.prepend:
    - text: "nameserver 127.0.0.1"