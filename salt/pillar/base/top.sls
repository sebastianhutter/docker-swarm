base:
  '*':
    - common
    - consul
    
  'G@roles:gluster':
    - gluster

  'G@roles:docker':
    - docker
    - swarm
    - registrator

  'G@roles:convoy':
    - convoy

  'G@roles:swarm-master':
    - swarm-master

  'G@roles:consul-master':
    - consul-master
    - dnsmasq