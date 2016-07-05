consul:
  #basic system configuration
  config_dir: /etc/consul.d
  data_dir: /var/lib/consul
  user: consul
  version: 0.6.4
  # service configuration
  config:
    datacenter: vagrant
    loglevel: info
    enable_syslog: true
    bootstrap_expect: 1
    cluster_addresses:
      - consul

  checks:
    ssh:
      name: "SSH TCP on port 22"
      type: tcp
      target: "localhost:22"
      interval: 10s
      timeout: 1s
