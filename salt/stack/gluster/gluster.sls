
{% import "gluster/variables.jinja" as vars %}

# register peers
{% for p in vars.gluster_peers %}
{% if salt['grains.get']('host') != p %}
gluster peer probe {{p}}:
  cmd.run
{% endif %}
{% endfor %}

# first lets create the brick directories
"{{vars.gluster_volume_directory}}/{{vars.gluster_volume_name}}/brick":
  file.directory:
    - mode: 755
    - makedirs: True

# this command is only executed on one node
# for now we just use the first node in the array
{% if salt['grains.get']('host') == vars.gluster_peers[0] %}
create-gluster-volume:
  cmd.run:
    - name: |
        gluster volume create {{vars.gluster_volume_name}} replica {{vars.gluster_peers|length}} transport tcp \
        {% for p in vars.gluster_peers -%}
        {{p}}:{{vars.gluster_volume_directory}}/{{vars.gluster_volume_name}}/brick \
        {% endfor -%}
        && gluster volume start {{vars.gluster_volume_name}}
    - shell: /bin/bash
{% endif %}
