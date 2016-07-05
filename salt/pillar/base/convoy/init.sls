convoy:
  version: '0.4.3'
  storage:
    driver: glusterfs
    gluster_servers:
      - srv-gluster-01
      - srv-gluster-02
    gluster_volume: gvol0