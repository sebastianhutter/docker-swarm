base:
  '*':
    - common
    
  'G@roles:gluster':
    - gluster

  'G@roles:docker':
    - docker
    - gluster.repository
    - gluster.client
