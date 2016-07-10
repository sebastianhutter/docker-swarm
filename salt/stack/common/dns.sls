# set the local resolv.conf

/etc/resolv.conf:
  file.managed:
    - contents: |
        nameserver 192.168.56.101
        nameserver 192.168.56.102
        nameserver 8.8.8.8

# make sure dns is not upgraded
/etc/dhcp/dhclient-enter-hooks.d/nodnsupdate:
  file.managed:
    - contents: |
        #!/bin/sh
        make_resolv_conf(){
            :
        }
    - mode: 755