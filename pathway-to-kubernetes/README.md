
# Getting Started

Pathway to Create cluster and Sample Workload using Kubernetes on AWS

### Prerequisites

**AWS Account:** Amazon will be the IaaS provider we will be using and therefore you will need to have an AWS account. If you don't have an account, you can [sign-up for an AWS Free Tier account](https://aws.amazon.com/free/), which will give you a certain amount of usage of specific AWS resources for free each month for 12 months.

**AWS Route 53 Domain:** In addition to the AWS account, you will also need to have a public domain hosted in AWS Route 53, which is a requirement to deploy clusters with Kops. If you don't already have a domain in Route 53 that you can use, refer to the [Kops documentation](https://github.com/kubernetes/kops/blob/master/docs/aws.md#configure-dns) for instructions on how to setup one of the three supported scenarios.

**Docker Hub Account:** The Docker images for the Hugo site need to be stored in a Docker Hub repository owned by you. If you don't already have a Docker Hub account, you can create a free account [here](https://hub.docker.com/).

### Setup Environment

For the execution of the labs, you can choose to use the provided [Vagrantfile](Vagrantfile) to provision a Vagrant box which has everything you will need already installed or you can install the required tools on your local host:

* [Using Vagrant](/docs/using-vagrant.md)
* [Using your local host](/docs/local-environment.md)
