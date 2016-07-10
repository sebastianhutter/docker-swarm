nomad:
  #basic system configuration
  config_dir: /etc/nomad.d
  data_dir: /var/lib/nomad
  user: nomad
  version: 0.4.0
  # service configuration
  config:
    advertise_port_http: 4646
    advertise_port_rpc: 4647
    advertise_port_serf: 4648
    loglevel: info
    enable_syslog: true
    bootstrap_expect: 1
    is_server: false

  consul:
    ip: consul.service.vagrant.consul
    port: 8500

#consul:
#  services:
#    nomad-client:
#      id: nomad-client
#      tags:
#        - nomad-client
#      checks:
#        - id: nomad-run-test
#          name: "check service state"
#          type: script
#          target: "systemctl status nomad"
#          shell: "/bin/bash"
#          interval: 10s
#          timeout: 1s
