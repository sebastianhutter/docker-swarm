base:
  '*':
    - common
    - consul
    
  'G@roles:gluster':
    - gluster

  'G@roles:docker':
    - docker
    - swarm

  'G@roles:convoy':
    - convoy

  'G@roles:swarm-master':
    - swarm-master

  'G@roles:consul-master':
    - consul-master