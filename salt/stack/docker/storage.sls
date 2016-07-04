#
# setup the lvm disk for direct-lvm storage
#

{% import "docker/variables.jinja" as vars %}

{% if vars.docker_use_thinpool %}

/etc/lvm/profile/docker-thinpool.profile:
  file.managed:
    - source: salt://docker/files/etc/lvm/profile/docker-thinpool.profile
    - makedirs: True
    - watch_in:
      - cmd: apply-profile

setup-disk:
  module.run:
    - name: partition.mklabel
    - device: {{ vars.docker_storage_device }}
    - label_type: gpt
    - unless: parted -s {{ vars.docker_storage_device }}

{{ vars.docker_storage_device }}:
  lvm.pv_present

setup-vg:
  lvm.vg_present:
    - name: docker
    - devices: {{ vars.docker_storage_device }}

setup-thinpool-lv:
  cmd.run:
    - name: lvcreate --wipesignatures y -n thinpool docker -l 95%VG

setup-thinpoolmeta-lv:
  cmd.run:
    - name: lvcreate --wipesignatures y -n thinpoolmeta docker -l 1%VG
    - require: 
        - cmd: setup-thinpool-lv

convert-pool:
  cmd.run: 
    - name: lvconvert -y --zero n -c 512K --thinpool docker/thinpool --poolmetadata docker/thinpoolmeta

apply-profile:
  cmd.run: 
    - name: lvchange --metadataprofile docker-thinpool docker/thinpool

{% endif %} 
