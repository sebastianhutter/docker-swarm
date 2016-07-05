
swarm:
  is_master: True

consul:
  services:
    swarm:
      id: swarm
      port: 4000
      tags:
        - swarm
      checks:
        - id: swarmping
          name: "HTTP api ping"
          type: http
          target: http://localhost:4000/_ping
          interval: 10s
          timeout: 1s