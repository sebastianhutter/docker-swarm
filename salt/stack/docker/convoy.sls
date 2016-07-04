#
# installs and configures the convoy storage plugin
#


# here the manual installation steps

#wget https://github.com/rancher/convoy/releases/download/v0.4.3/convoy.tar.gz
#tar xvf convoy.tar.gz
#sudo cp convoy/convoy convoy/convoy-pdata_tools /usr/local/bin/
#sudo mkdir -p /etc/docker/plugins/
#sudo bash -c 'echo "unix:///var/run/convoy/convoy.sock" > /etc/docker/plugins/convoy.spec'

# and here how to run it with gluster
#sudo convoy daemon --drivers glusterfs --driver-opts glusterfs.servers=srv-gluster-01,srv-gluster-02 --driver-opts glusterfs.defaultvolumepool=gvol0


# needs to be saltified and also added to systemd
