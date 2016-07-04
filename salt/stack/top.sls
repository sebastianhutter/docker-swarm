base:
  '*':
    - common
    - consul
    
  'G@roles:gluster':
    - gluster

  'G@roles:consul-bootstrap':
    - consul.nginx
    
  'G@roles:docker':
    - docker
    - gluster.repository
    - gluster.client

  'G@roles:swarm':
    - swarm