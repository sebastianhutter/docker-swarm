#bind_addr = "{{advertise}}"
bind_addr = "0.0.0.0"

data_dir = "{{datadir}}"
log_level = "debug"


region = "vagrant"
datacenter = "vagrant"

advertise {
  # We need to specify our host's IP because we can't
  # advertise 0.0.0.0 to other nodes in our cluster.
  rpc = "{{advertise}}:{{advertise_port_rpc}}"
  http = "{{advertise}}:{{advertise_port_http}}"
  serf = "{{advertise}}:{{advertise_port_serf}}"
}

{% if server %}
server {
  enabled = true
  bootstrap_expect = {{bootstrap|int}}
}
{% else %}
client {
  # it is not recommended to use a node as a server and as a client at the same time
  enabled = true
  network_speed = 10
  network_interface = "eth1"
  options {
    "driver.raw_exec.enable" = "1"
  }
}
{% endif %}

consul {
    # Consul's HTTP Address
    address = "{{consul_ip}}:{{consul_port}}"

    "server_service_name" = "nomad"
    "server_auto_join" = true
    "client_service_name" = "nomad-client"
    "client_auto_join" =  true
}
