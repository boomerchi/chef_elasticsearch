# disk
default[:raintank_elasticsearch][:elasticsearch_disk] = "/dev/sdb"

# networking
default[:raintank_elasticsearch][:network_host] = "_eth0:ipv4_"
default[:raintank_elasticsearch][:cluster_name] = "elasticsearch"
default[:raintank_elasticsearch][:http_bind_host] = "0.0.0.0"

# java
default[:java][:install_flavor] = "oracle"
default[:java][:jdk_version] = "8"
default[:java][:oracle][:accept_oracle_download_terms] = true

# elasticsearch version
override[:elasticsearch][:version] = "2.2.0"
default[:elasticsearch][:discovery][:node_attribute] = "cloud_v2.local_ipv4"
default[:elasticsearch][:discovery][:search_query] = "tags:elasticsearch AND chef_environment:#{node.chef_environment}"
