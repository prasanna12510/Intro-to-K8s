# General variables
export DOMAIN_NAME="cto.logi.com" # Must be updated

# Cluster variables
export CLUSTER_ALIAS="usa"
export CLUSTER_FULL_NAME="${CLUSTER_ALIAS}.${DOMAIN_NAME}" 
export CLUSTER_AWS_REGION="us-east-1"
export CLUSTER_AWS_AZ="us-east-1a"
export CLUSTER_MASTER_SIZE="t2.medium"
export CLUSTER_NODE_SIZE="t2.medium"
export CLUSTER_NODE_COUNT="2"
export AWS_KEYPAIR_PUB_KEY_PATH="~/.ssh/id_rsa.pub"

# Federation variables
export FEDERATION_NAME="federation"

# Application variables
export HUGO_APP_DOCKER_IMAGE="prasanna1994/hugo-app"
export JENKINS_DOCKER_IMAGE_TAG="prasanna1994/hugo-app-jenkins:latest"
export DOMAIN_NAME_ZONE_ID=$(aws route53 list-hosted-zones \
       | jq -r '.HostedZones[] | select(.Name=="'${DOMAIN_NAME}'.") | .Id' \
       | sed 's/\/hostedzone\///') 
