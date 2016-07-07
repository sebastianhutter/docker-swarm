base:
  '*':
    - common
    - consul
    
  'G@roles:gluster':
    - gluster
    - dnsmasq
    
  'G@roles:docker':
    - docker
    - gluster.repository
    - gluster.client
    - swarm
    - registrator
  
  'G@roles:nginx':
    - nginx

  'G@roles:convoy':
    - convoy

