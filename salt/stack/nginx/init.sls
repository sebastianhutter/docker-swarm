nginx:
  pkg:
    - installed
  service.running:
    - watch:
      - pkg: nginx
      - file: /etc/nginx/sites-available/proxy.conf

# disable the default site
/etc/nginx/sites-enabled/default.conf:
  file.absent:
    - require:
      - pkg: nginx

/etc/nginx/sites-available/proxy.conf:
  file.managed:
    - source: salt://nginx/files/etc/nginx/sites-available/proxy.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 640

/etc/nginx/sites-enabled/proxy.conf:
  file.symlink:
    - target: /etc/nginx/sites-available/proxy.conf
    - require:
      - file: /etc/nginx/sites-available/proxy.conf
    - watch_in:
      - service: nginx

nginx-systemd-reload:
  cmd.wait:
    - name: systemctl daemon-reload