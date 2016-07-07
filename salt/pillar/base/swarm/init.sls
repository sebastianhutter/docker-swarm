swarm:
  is_master: False
  port: 2375
  # sometimes the dns is not properly working
  # need to use the consul dns service registry!
  consul:
    address: consul.service.vagrant.consul
    port: 8500
    prefix: swarm