docker:
  storage:
    device: /dev/sdb
    vg_name: vg_name
    use_thinpool: False

consul:
  services:
    docker:
      id: docker
      address: '127.0.0.1'
      port: 2375
      tags:
        - docker
      checks:
        - id: ping
          name: "HTTP API ping"
          type: http
          target: http://localhost:2375/_ping
          interval: 10s
          timeout: 1s