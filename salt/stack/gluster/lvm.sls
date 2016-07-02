#
# setup the lvm for the brick
#

{% import "gluster/variables.jinja" as vars %}

setup-disk:
  module.run:
    - name: partition.mklabel
    - device: {{ vars.gluster_device }}
    - label_type: gpt
    - unless: parted -s {{ vars.gluster_device }}

{{ vars.gluster_device }}:
  lvm.pv_present

{{ vars.gluster_vg_name }}:
  lvm.vg_present:
    - devices: {{ vars.gluster_device }}

setup-lv:
  module.run:
    - name: lvm.lvcreate
    - lvname: {{ vars.gluster_lv_name }}
    - vgname: {{ vars.gluster_vg_name }}
    - extents: 100%FREE

create-xfs:
  module.run:
    - name: xfs.mkfs
    - device: "/dev/{{ vars.gluster_vg_name }}/{{ vars.gluster_lv_name }}"
    - noforce: True

"{{vars.gluster_volume_directory}}/{{vars.gluster_volume_name}}":
  mount.mounted:
    - device: "/dev/{{ vars.gluster_vg_name }}/{{ vars.gluster_lv_name }}"
    - fstype: xfs
    - opts: inode64,nobarrier
    - dump: 0
    - pass_num: 0
    - persist: True
    - mkmnt: True

