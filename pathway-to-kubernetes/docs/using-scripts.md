# Using Scripts

In addition to the step-by-step instructions provided for each lab, this repository also contains scripts to automate some of the activities being performed in the labs.

You will need to review the [script variables](/docs/script-variables.md) guide before running any of the provided scripts.

If you are using the Vagrant box together with Windows & Git Bash, you may run into a issue where the script files are not marked as executable due to the underlying Windows file system. The easiest workaround for this issue is to clone the repository to a different folder from within the Vagrant box and you should then be able to run the scripts there:

```bash
git clone https://github.com/prasanna12510/pathway-to-kubernetes ~/pathway-to-kubernetes-scripts
cd ~/pathway-to-kubernetes-scripts
```

**Cluster Deployment**
* [Create Cluster](#create-cluster)
* [Delete Cluster](#delete-cluster)

**Cluster Add-ons**
* [Deploy Kubernetes Dashboard](#deploy-kubernetes-dashboard)
* [Deploy Heapster Monitoring](#deploy-heapster-monitoring)
* [Deploy Cluster Autoscaler](#deploy-cluster-autoscaler)

**Federation**
* [Create Federation](#create-federation)

**Application Deployment**
* [Deploy Hugo Site (Standalone)](#deploy-hugo-site-standalone)
* [Deploy Hugo Site (Federated)](#deploy-hugo-site-federated)
* [Deploy Jenkins](#deploy-jenkins)
* [Deploy Horizontal Pod Autoscaling Demo](#deploy-horizontal-pod-autoscaling-demo)


# Cluster Deployment


## Create Cluster

* Creates a S3 bucket which will be used by Kops for cluster configuration storage
* Creates a cluster
* Creates a cluster context alias

### Usage

```bash
./scripts/clusters/create-cluster.sh [CLUSTER_ALIAS] [CLUSTER_AWS_AZ]
```

* `[CLUSTER_ALIAS]` - Cluster context alias to use for the new cluster *(Optional)*
* `[CLUSTER_AWS_AZ]` - AWS availability zone where the new cluster will be deployed *(Optional)*

If you do provide the configuration options above for `[CLUSTER_ALIAS]` and `[CLUSTER_AWS_AZ]`, they will override the values specified in the variables.sh file.

### Example

The following will create two clusters, one with the values from the variables.sh file (default is `usa` & `us-east-1a`) and the other with a cluster alias of `eur`, which will be located in the `eu-west-1a` AWS availability zone:

```bash
./scripts/clusters/create-cluster.sh
./scripts/clusters/create-cluster.sh eur eu-west-1a
```


## Delete Cluster

* Deletes an existing cluster
* Deletes the S3 bucket used by Kops for cluster configuration storage

### Usage

```bash
./scripts/clusters/delete-cluster.sh [CLUSTER_ALIAS]
```

* `[CLUSTER_ALIAS]` - Cluster context alias of an existing cluster *(Optional)*

If you do provide the configuration option above for `[CLUSTER_ALIAS]`, it will override the value specified in the variables.sh file.

### Example

The following will delete two clusters, one with the value from the variables.sh file (default is `usa`) and the other with cluster alias `eur`:

```bash
./scripts/clusters/delete-cluster.sh
./scripts/clusters/delete-cluster.sh eur
```


# Cluster Add-ons


## Deploy Kubernetes Dashboard

* Deploys the Kubernetes dashboard add-on to an existing cluster

### Usage

```bash
./scripts/addons/kubernetes-dashboard/deploy-dashboard.sh [CLUSTER_ALIAS]
```

* `[CLUSTER_ALIAS]` - Cluster context alias of an existing cluster *(Optional)*

If you do provide the configuration option above for `[CLUSTER_ALIAS]`, it will override the value specified in the variables.sh file.

### Example

The following will deploy the Kubernetes dashboard add-on to two clusters, `usa` (default in the variables.sh file) and `eur`:

```bash
./scripts/addons/kubernetes-dashboard/deploy-dashboard.sh
./scripts/addons/kubernetes-dashboard/deploy-dashboard.sh eur
```


## Deploy Heapster Monitoring

* Deploys the Heapster monitoring add-on to an existing cluster

### Usage

```bash
./scripts/addons/heapster-monitoring/deploy-heapster-monitoring.sh [CLUSTER_ALIAS]
```

* `[CLUSTER_ALIAS]` - Cluster context alias of an existing cluster *(Optional)*

If you do provide the configuration option above for `[CLUSTER_ALIAS]`, it will override the value specified in the variables.sh file.

### Example

The following will deploy the Heapster monitoring add-on to two clusters, `usa` (default in the variables.sh file) and `eur`:

```bash
./scripts/addons/heapster-monitoring/deploy-heapster-monitoring.sh
./scripts/addons/heapster-monitoring/deploy-heapster-monitoring.sh eur
```


## Deploy Cluster Autoscaler

* Creates an IAM policy with permissions needed for the cluster autoscaler add-on
* Deploys the cluster autoscaler add-on to an existing cluster

### Usage

```bash
./scripts/addons/cluster-autoscaler/deploy-cluster-autoscaler.sh [CLUSTER_ALIAS] [CLUSTER_AWS_REGION] [MIN_NODES] [MAX_NODES]
```

* `[CLUSTER_ALIAS]` - Cluster context alias of an existing cluster *(Mandatory)*
* `[CLUSTER_AWS_REGION]` - AWS region of the existing cluster *(Mandatory)*
* `[MIN_NODES]` - Minimum number of nodes to configure for the AWS autoscaling group *(Mandatory)*
* `[MAX_NODES]` - Maximum number of nodes to configure for the AWS autoscaling group *(Mandatory)*

### Example

The following will deploy the cluster autoscaler add-on to two clusters, one with cluster alias `usa` located in the `us-east-1` AWS region with a minimum of `3` nodes and a maximum of `5` nodes. And the other with cluster alias `eur` located in the `eu-west-1` AWS region with a minimum of `4` nodes and a maximum of `6` nodes:

```bash
./scripts/addons/cluster-autoscaler/deploy-cluster-autoscaler.sh usa us-east-1 3 5
./scripts/addons/cluster-autoscaler/deploy-cluster-autoscaler.sh eur eu-west-1 4 6
```


# Federation


## Create Federation

* Creates a Federation between two or three existing clusters
* Name of the Federation is specified as `FEDERATION_NAME` in the [`/scripts/variables.sh`](/scripts/variables.sh#L16) file
* Creates two federated namespaces called `default` and `federation`
### Usage

```bash
./scripts/clusters/federation/create-federation.sh [HOST_CLUSTER_ALIAS] [CLUSTER_2_ALIAS] [CLUSTER_3_ALIAS]
```

* `[HOST_CLUSTER_ALIAS]` - Cluster context alias of an existing cluster, which will host the Federation services *(Mandatory)*
* `[CLUSTER_2_ALIAS]` - Cluster context alias of a second existing cluster, which will join the Federation with the host cluster *(Mandatory)*
* `[CLUSTER_3_ALIAS]` - Cluster context alias of a third existing cluster, which will join the Federation with the host cluster *(Optional)*

### Example

The following will create a Federation between two clusters, `usa` & `eur`. The `usa` cluster will host the Federation services:

```bash
./scripts/clusters/federation/create-federation.sh usa eur
```

The following will create a Federation between three clusters, `frankfurt`, `sydney` & `mumbai`. The `frankfurt` cluster will host the Federation services:

```bash
./scripts/clusters/federation/create-federation.sh frankfurt sydney mumbai
```


# Application Deployments


## Deploy Hugo Site (Standalone)

* Creates a Deployment of the Hugo site in a single cluster
* Docker image of the Hugo site is specified as `HUGO_APP_DOCKER_IMAGE` in the [`/scripts/variables.sh`](/scripts/variables.sh#L19) file
* Docker image tag `1.0` will be used
* Creates a load balancer Service for the Deployment, which exposes port 80
* Creates a DNS record with the prefix `hugo` in your domain in Route 53 (ex: hugo.cto.logi.com)

### Usage

```bash
./scripts/apps/hugo-app/deploy-hugo-app.sh [CLUSTER_ALIAS]
```

* `[CLUSTER_ALIAS]` - Cluster context alias of an existing cluster *(Optional)*

If you do provide the configuration option above for `[CLUSTER_ALIAS]`, it will override the value specified in the variables.sh file.

### Example

The following will deploy the Hugo site to two clusters, `usa` (default in the variables.sh file) and `eur`:

```bash
./scripts/apps/hugo-app/deploy-hugo-app.sh
./scripts/apps/hugo-app/deploy-hugo-app.sh eur
```


## Deploy Hugo Site (Federated)

* Creates a federated Deployment of the Hugo site in a Federation with two to three clusters
* Docker image of the Hugo site is specified as `HUGO_APP_DOCKER_IMAGE` in the [`/scripts/variables.sh`](/scripts/variables.sh#L19) file
* Docker image tag `1.0` will be used
* Creates a load balancer Service in each cluster for the federated Hugo site Deployment, which exposes port `80`
* Creates a DNS record for each cluster in the Federation, which uses latency-based routing with the prefix `hugo-fed` in your domain in Route 53 (ex: hugo-fed.cto.logi.com)

### Usage

```bash
./scripts/apps/hugo-app-federation/deploy-hugo-app-federation.sh [CLUSTER_1_ALIAS] [CLUSTER_1_AWS_REGION] [CLUSTER_2_ALIAS] [CLUSTER_2_AWS_REGION] [CLUSTER_3_ALIAS] [CLUSTER_3_AWS_REGION]
```

* `[CLUSTER_1_ALIAS]` - Cluster context alias of the first existing cluster in a Federation *(Mandatory)*
* `[CLUSTER_1_AWS_REGION]` - AWS region of the first existing cluster in a Federation *(Mandatory)*
* `[CLUSTER_2_ALIAS]` - Cluster context alias of the second existing cluster in a Federation *(Mandatory)*
* `[CLUSTER_2_AWS_REGION]` - AWS region of the second existing cluster in a Federation *(Mandatory)*
* `[CLUSTER_3_ALIAS]` - Cluster context alias of the third existing cluster in a Federation *(Optional)*
* `[CLUSTER_3_AWS_REGION]` - AWS region of the third existing cluster in a Federation *(Optional)*

### Example

The following will deploy the federated Hugo site to three clusters, `usa` in the `us-east-1` AWS region, `eur` in the `eu-west-1` AWS region and `tyo` in the `ap-northeast-1` AWS region:

```bash
./scripts/apps/hugo-app-federation/deploy-hugo-app-federation.sh usa us-east-1 eur eu-west-1 tyo ap-northeast-1
```

```bash


## Deploy Jenkins

* Creates a Deployment of Jenkins in a single cluster
* Docker image of Jenkins is specified as `JENKINS_DOCKER_IMAGE` in the [`/scripts/variables.sh`](/scripts/variables.sh#L20) file
* Creates a persistent volume claim for the Jenkins home directory (`/var/jenkins_home`)
* Creates a load balancer Service for the Jenkins Deployment, which exposes ports `80`
* Creates a DNS record with the prefix `jenkins` in your domain in Route 53 (ex: jenkins-kubernetes.cto.logi.com)


### Usage

```bash
./scripts/apps/jenkins/deploy-jenkins.sh [CLUSTER_ALIAS]
```

* `[CLUSTER_ALIAS]` - Cluster context alias of an existing cluster *(Optional)*

If you do provide the configuration option above for `[CLUSTER_ALIAS]`, it will override the value specified in the variables.sh file.

### Example

The following will deploy Jenkins to two clusters, `usa` (default in the variables.sh file) and `eur`:

```bash
./scripts/apps/jenkins/deploy-jenkins.sh
./scripts/apps/jenkins/deploy-jenkins.sh eur
```


## Deploy Horizontal Pod Autoscaling Demo

* Creates a Deployment of the horizontal pod autoscaling demo in a single cluster
* Creates a cluster internal Service (ClusterIP) for the horizontal pod autoscaling demo Deployment, which exposes port 80
* Configures horizontal pod autoscaling for the horizontal pod autoscaling demo Deployment

### Usage

```bash
./scripts/apps/horizontal-pod-autoscaling/deploy-hpa-app.sh [CLUSTER_ALIAS]
```

* `[CLUSTER_ALIAS]` - Cluster context alias of an existing cluster *(Optional)*

If you do provide the configuration option above for `[CLUSTER_ALIAS]`, it will override the value specified in the variables.sh file.

After running the script, open up a second terminal (if using Vagrant, browse to the root of the repository from a second terminal and connect with vagrant ssh) and run the following:

```bash
kubectl run -i --tty load-generator --image=busybox /bin/sh
```
```bash
# Hit enter for command prompt
while true; do wget -q -O- http://php-apache.default.svc.cluster.local; done
```
```console
OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!
OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!
OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!...
```

### Example

The following will deploy the horizontal pod autoscaling demo to two clusters, `usa` (default in the variables.sh file) and `eur`:

```bash
./scripts/apps/horizontal-pod-autoscaling/deploy-hpa-app.sh
./scripts/apps/horizontal-pod-autoscaling/deploy-hpa-app.sh eur
```
