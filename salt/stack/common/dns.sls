# set the local resolv.conf

/etc/resolv.conf:
  file.managed:
    - contents: |
        nameserver 192.168.56.101
        nameserver 192.168.56.102
        nameserver 8.8.8.8