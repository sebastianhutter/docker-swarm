consul:
  checks:
    dnsmasq:
      name: "check dnsmasq"
      type: script
      shell: /bin/bash
      target: "systemctl status dnsmasq"
      interval: 60s
      timeout: 1s

dnsmasq:
  servers:
    - "/consul/127.0.0.1#8600"
    - "8.8.8.8"
    - "8.8.4.4"