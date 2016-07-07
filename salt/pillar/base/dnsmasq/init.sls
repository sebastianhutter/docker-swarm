consul:
  checks:
    dnsmasq:
      name: "check dnsmasq"
      type: script
      shell: /bin/bash
      target: "systemctl status dnsmasq"
      interval: 60s
      timeout: 1s