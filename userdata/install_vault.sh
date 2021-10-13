sudo yum update

# install yum-config-manager to manage repositories.
sudo yum install -y yum-utils

# use yum-config-manager to add the official HashiCorp Linux repository.
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo

# install Vault
sudo yum -y install vault

# write vault config to config.hcl
cat << EOF > ./config.hcl
storage "raft" {
  path    = "./vault/data"
  node_id = "node1"
}

listener "tcp" {
  address     = "127.0.0.1:8200"
  tls_disable = "true"
}

api_addr = "http://127.0.0.1:8200"
cluster_addr = "https://127.0.0.1:8201"
ui = true
EOF

# create folder for raft storage
mkdir -p ./vault/data

# start the server
vault server -config=config.hcl
