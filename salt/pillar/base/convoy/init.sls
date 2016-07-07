convoy:
  version: '0.4.3'
  storage:
    driver: glusterfs
    gluster_servers:
      - gluster.service.vagrant.consul
    gluster_volume: gvol0


consul:
  checks:
    convoy:
      name: "convoy information"
      type: script
      shell: /bin/bash
      target: "sudo convoy info"
      interval: 10s
      timeout: 1s