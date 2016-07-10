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
      - 192.168.56.101
