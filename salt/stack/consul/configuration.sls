#
# configure services and checks
# services: https://www.consul.io/docs/agent/services.html
# checks: https://www.consul.io/docs/agent/checks.html

# import all variables from a central location
{% import "consul/variables.jinja" as vars %}

# copy the services file 
{{vars.consul_config}}/services.json:
  file.managed:
    - source: salt://consul/files/etc/consul.d/services.json
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - context:
        services: {{vars.consul_services}}

# copy the checks file 
{{vars.consul_config}}/checks.json:
  file.managed:
    - source: salt://consul/files/etc/consul.d/checks.json
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - context:
        checks: {{vars.consul_checks}}