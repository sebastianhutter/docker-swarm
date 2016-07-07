base:
  '*':
    - common
    - consul
    - dnsmasq
    
  'G@roles:gluster':
    - gluster
    
  'G@roles:docker':
    - docker
    - gluster.repository
    - gluster.client
    - swarm
  
  'G@roles:nginx':
    - nginx

  'G@roles:convoy':
    - convoy

