# disk
default[:chef_elasticsearch][:elasticsearch_disk] = "/dev/sdb"

# networking
default[:chef_elasticsearch][:network_host] = "_eth0:ipv4_"
default[:chef_elasticsearch][:cluster_name] = "elasticsearch"
default[:chef_elasticsearch][:http_bind_host] = "0.0.0.0"

# standalone-ness
default[:chef_elasticsearch][:standalone] = false

# java
default[:java][:install_flavor] = "oracle"
default[:java][:jdk_version] = "8"
default[:java][:oracle][:accept_oracle_download_terms] = true

# elasticsearch version
override[:elasticsearch][:version] = "2.2.0"
default[:elasticsearch][:discovery][:node_attribute] = "cloud_v2.local_ipv4"
default[:elasticsearch][:discovery][:search_query] = "tags:elasticsearch AND chef_environment:#{node.chef_environment}"
