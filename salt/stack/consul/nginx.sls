#
# install and configure nginx to show the consul ui page
# 
 
nginx:
  pkg:
    - installed
  service.running:
    - watch:
      - pkg: nginx
      - file: /etc/nginx/sites-available/consului.conf


# disable the default site
/etc/nginx/sites-enabled/default.conf:
  file.absent:
    - require:
      - pkg: nginx

/etc/nginx/sites-available/consului.conf:
  file.managed:
    - source: salt://consul/files/etc/nginx/sites-available/consului.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 640

/etc/nginx/sites-enabled/consului.conf:
  file.symlink:
    - target: /etc/nginx/sites-available/consului.conf
    - require:
      - file: /etc/nginx/sites-available/consului.conf
    - watch_in:
      - service: nginx

nginx-systemd-reload:
  cmd.wait:
    - name: systemctl daemon-reload