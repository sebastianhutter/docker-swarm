nomad:
  config:
    is_server: True
    bootstrap_expect: 1


#consul:
#  services:
#    nomad:
#      id: nomad
#      tags:
#        - nomad
#      checks:
#        - id: nomad-run-test
#          name: "check service state"
#          type: script
#          target: "systemctl status nomad"
#          shell: "/bin/bash"
#          interval: 10s
#          timeout: 1s
