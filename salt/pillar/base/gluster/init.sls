gluster:
  # disk config
  disk: /dev/sdb
  lvm:
    vg_name: vgglus1
    lv_name: gbrick1
  # gluster peers
  # needs to be handled via consul later on
  peers:
    - srv-gluster-01
    - srv-gluster-02
  # gluster volume
  volume:
    directory: '/var/lib/gluster'
    name: 'gvol0'

consul:
  services:
    gluster:
      id: gluster
      port: 24007
      tags:
        - gluster
      checks:
        - id: tcptest
          name: "Test Daemon listening"
          type: tcp
          target: localhost:24007
          interval: 10s
          timeout: 1s