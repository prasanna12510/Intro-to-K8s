output "cluster_name" {
  value = "germany-cluster.cto.logi.com"
}

output "master_security_group_ids" {
  value = ["${aws_security_group.masters-germany-cluster-cto-logi-com.id}"]
}

output "masters_role_arn" {
  value = "${aws_iam_role.masters-germany-cluster-cto-logi-com.arn}"
}

output "masters_role_name" {
  value = "${aws_iam_role.masters-germany-cluster-cto-logi-com.name}"
}

output "node_security_group_ids" {
  value = ["${aws_security_group.nodes-germany-cluster-cto-logi-com.id}"]
}

output "node_subnet_ids" {
  value = ["${aws_subnet.eu-central-1a-germany-cluster-cto-logi-com.id}"]
}

output "nodes_role_arn" {
  value = "${aws_iam_role.nodes-germany-cluster-cto-logi-com.arn}"
}

output "nodes_role_name" {
  value = "${aws_iam_role.nodes-germany-cluster-cto-logi-com.name}"
}

output "region" {
  value = "eu-central-1"
}

output "vpc_id" {
  value = "${aws_vpc.germany-cluster-cto-logi-com.id}"
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_autoscaling_group" "master-eu-central-1a-masters-germany-cluster-cto-logi-com" {
  name                 = "master-eu-central-1a.masters.germany-cluster.cto.logi.com"
  launch_configuration = "${aws_launch_configuration.master-eu-central-1a-masters-germany-cluster-cto-logi-com.id}"
  max_size             = 1
  min_size             = 1
  vpc_zone_identifier  = ["${aws_subnet.eu-central-1a-germany-cluster-cto-logi-com.id}"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "germany-cluster.cto.logi.com"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "master-eu-central-1a.masters.germany-cluster.cto.logi.com"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"
    value               = "master-eu-central-1a"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/master"
    value               = "1"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "nodes-germany-cluster-cto-logi-com" {
  name                 = "nodes.germany-cluster.cto.logi.com"
  launch_configuration = "${aws_launch_configuration.nodes-germany-cluster-cto-logi-com.id}"
  max_size             = 2
  min_size             = 2
  vpc_zone_identifier  = ["${aws_subnet.eu-central-1a-germany-cluster-cto-logi-com.id}"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "germany-cluster.cto.logi.com"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "nodes.germany-cluster.cto.logi.com"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"
    value               = "nodes"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/node"
    value               = "1"
    propagate_at_launch = true
  }
}

resource "aws_ebs_volume" "a-etcd-events-germany-cluster-cto-logi-com" {
  availability_zone = "eu-central-1a"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster    = "germany-cluster.cto.logi.com"
    Name                 = "a.etcd-events.germany-cluster.cto.logi.com"
    "k8s.io/etcd/events" = "a/a"
    "k8s.io/role/master" = "1"
  }
}

resource "aws_ebs_volume" "a-etcd-main-germany-cluster-cto-logi-com" {
  availability_zone = "eu-central-1a"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster    = "germany-cluster.cto.logi.com"
    Name                 = "a.etcd-main.germany-cluster.cto.logi.com"
    "k8s.io/etcd/main"   = "a/a"
    "k8s.io/role/master" = "1"
  }
}

resource "aws_iam_instance_profile" "masters-germany-cluster-cto-logi-com" {
  name = "masters.germany-cluster.cto.logi.com"
  role = "${aws_iam_role.masters-germany-cluster-cto-logi-com.name}"
}

resource "aws_iam_instance_profile" "nodes-germany-cluster-cto-logi-com" {
  name = "nodes.germany-cluster.cto.logi.com"
  role = "${aws_iam_role.nodes-germany-cluster-cto-logi-com.name}"
}

resource "aws_iam_role" "masters-germany-cluster-cto-logi-com" {
  name               = "masters.germany-cluster.cto.logi.com"
  assume_role_policy = "${file("${path.module}/data/aws_iam_role_masters.germany-cluster.cto.logi.com_policy")}"
}

resource "aws_iam_role" "nodes-germany-cluster-cto-logi-com" {
  name               = "nodes.germany-cluster.cto.logi.com"
  assume_role_policy = "${file("${path.module}/data/aws_iam_role_nodes.germany-cluster.cto.logi.com_policy")}"
}

resource "aws_iam_role_policy" "masters-germany-cluster-cto-logi-com" {
  name   = "masters.germany-cluster.cto.logi.com"
  role   = "${aws_iam_role.masters-germany-cluster-cto-logi-com.name}"
  policy = "${file("${path.module}/data/aws_iam_role_policy_masters.germany-cluster.cto.logi.com_policy")}"
}

resource "aws_iam_role_policy" "nodes-germany-cluster-cto-logi-com" {
  name   = "nodes.germany-cluster.cto.logi.com"
  role   = "${aws_iam_role.nodes-germany-cluster-cto-logi-com.name}"
  policy = "${file("${path.module}/data/aws_iam_role_policy_nodes.germany-cluster.cto.logi.com_policy")}"
}

resource "aws_internet_gateway" "germany-cluster-cto-logi-com" {
  vpc_id = "${aws_vpc.germany-cluster-cto-logi-com.id}"

  tags = {
    KubernetesCluster = "germany-cluster.cto.logi.com"
    Name              = "germany-cluster.cto.logi.com"
  }
}

resource "aws_key_pair" "kubernetes-germany-cluster-cto-logi-com-70332db475ca341fdfa18cea7d053daf" {
  key_name   = "kubernetes.germany-cluster.cto.logi.com-70:33:2d:b4:75:ca:34:1f:df:a1:8c:ea:7d:05:3d:af"
  public_key = "${file("${path.module}/data/aws_key_pair_kubernetes.germany-cluster.cto.logi.com-70332db475ca341fdfa18cea7d053daf_public_key")}"
}

resource "aws_launch_configuration" "master-eu-central-1a-masters-germany-cluster-cto-logi-com" {
  name_prefix                 = "master-eu-central-1a.masters.germany-cluster.cto.logi.com-"
  image_id                    = "ami-6b204704"
  instance_type               = "t2.medium"
  key_name                    = "${aws_key_pair.kubernetes-germany-cluster-cto-logi-com-70332db475ca341fdfa18cea7d053daf.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.masters-germany-cluster-cto-logi-com.id}"
  security_groups             = ["${aws_security_group.masters-germany-cluster-cto-logi-com.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_master-eu-central-1a.masters.germany-cluster.cto.logi.com_user_data")}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 64
    delete_on_termination = true
  }

  lifecycle = {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "nodes-germany-cluster-cto-logi-com" {
  name_prefix                 = "nodes.germany-cluster.cto.logi.com-"
  image_id                    = "ami-6b204704"
  instance_type               = "t2.medium"
  key_name                    = "${aws_key_pair.kubernetes-germany-cluster-cto-logi-com-70332db475ca341fdfa18cea7d053daf.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.nodes-germany-cluster-cto-logi-com.id}"
  security_groups             = ["${aws_security_group.nodes-germany-cluster-cto-logi-com.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_nodes.germany-cluster.cto.logi.com_user_data")}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 128
    delete_on_termination = true
  }

  lifecycle = {
    create_before_destroy = true
  }
}

resource "aws_route" "0-0-0-0--0" {
  route_table_id         = "${aws_route_table.germany-cluster-cto-logi-com.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.germany-cluster-cto-logi-com.id}"
}

resource "aws_route_table" "germany-cluster-cto-logi-com" {
  vpc_id = "${aws_vpc.germany-cluster-cto-logi-com.id}"

  tags = {
    KubernetesCluster = "germany-cluster.cto.logi.com"
    Name              = "germany-cluster.cto.logi.com"
  }
}

resource "aws_route_table_association" "eu-central-1a-germany-cluster-cto-logi-com" {
  subnet_id      = "${aws_subnet.eu-central-1a-germany-cluster-cto-logi-com.id}"
  route_table_id = "${aws_route_table.germany-cluster-cto-logi-com.id}"
}

resource "aws_security_group" "masters-germany-cluster-cto-logi-com" {
  name        = "masters.germany-cluster.cto.logi.com"
  vpc_id      = "${aws_vpc.germany-cluster-cto-logi-com.id}"
  description = "Security group for masters"

  tags = {
    KubernetesCluster = "germany-cluster.cto.logi.com"
    Name              = "masters.germany-cluster.cto.logi.com"
  }
}

resource "aws_security_group" "nodes-germany-cluster-cto-logi-com" {
  name        = "nodes.germany-cluster.cto.logi.com"
  vpc_id      = "${aws_vpc.germany-cluster-cto-logi-com.id}"
  description = "Security group for nodes"

  tags = {
    KubernetesCluster = "germany-cluster.cto.logi.com"
    Name              = "nodes.germany-cluster.cto.logi.com"
  }
}

resource "aws_security_group_rule" "all-master-to-master" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-germany-cluster-cto-logi-com.id}"
  source_security_group_id = "${aws_security_group.masters-germany-cluster-cto-logi-com.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-master-to-node" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.nodes-germany-cluster-cto-logi-com.id}"
  source_security_group_id = "${aws_security_group.masters-germany-cluster-cto-logi-com.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-node-to-node" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.nodes-germany-cluster-cto-logi-com.id}"
  source_security_group_id = "${aws_security_group.nodes-germany-cluster-cto-logi-com.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "https-external-to-master-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.masters-germany-cluster-cto-logi-com.id}"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "master-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.masters-germany-cluster-cto-logi-com.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.nodes-germany-cluster-cto-logi-com.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-to-master-tcp-1-2379" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-germany-cluster-cto-logi-com.id}"
  source_security_group_id = "${aws_security_group.nodes-germany-cluster-cto-logi-com.id}"
  from_port                = 1
  to_port                  = 2379
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-tcp-2382-4000" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-germany-cluster-cto-logi-com.id}"
  source_security_group_id = "${aws_security_group.nodes-germany-cluster-cto-logi-com.id}"
  from_port                = 2382
  to_port                  = 4000
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-tcp-4003-65535" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-germany-cluster-cto-logi-com.id}"
  source_security_group_id = "${aws_security_group.nodes-germany-cluster-cto-logi-com.id}"
  from_port                = 4003
  to_port                  = 65535
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-udp-1-65535" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-germany-cluster-cto-logi-com.id}"
  source_security_group_id = "${aws_security_group.nodes-germany-cluster-cto-logi-com.id}"
  from_port                = 1
  to_port                  = 65535
  protocol                 = "udp"
}

resource "aws_security_group_rule" "ssh-external-to-master-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.masters-germany-cluster-cto-logi-com.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ssh-external-to-node-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.nodes-germany-cluster-cto-logi-com.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_subnet" "eu-central-1a-germany-cluster-cto-logi-com" {
  vpc_id            = "${aws_vpc.germany-cluster-cto-logi-com.id}"
  cidr_block        = "172.20.32.0/19"
  availability_zone = "eu-central-1a"

  tags = {
    KubernetesCluster                                    = "germany-cluster.cto.logi.com"
    Name                                                 = "eu-central-1a.germany-cluster.cto.logi.com"
    "kubernetes.io/cluster/germany-cluster.cto.logi.com" = "owned"
    "kubernetes.io/role/elb"                             = "1"
  }
}

resource "aws_vpc" "germany-cluster-cto-logi-com" {
  cidr_block           = "172.20.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    KubernetesCluster                                    = "germany-cluster.cto.logi.com"
    Name                                                 = "germany-cluster.cto.logi.com"
    "kubernetes.io/cluster/germany-cluster.cto.logi.com" = "owned"
  }
}

resource "aws_vpc_dhcp_options" "germany-cluster-cto-logi-com" {
  domain_name         = "eu-central-1.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = {
    KubernetesCluster = "germany-cluster.cto.logi.com"
    Name              = "germany-cluster.cto.logi.com"
  }
}

resource "aws_vpc_dhcp_options_association" "germany-cluster-cto-logi-com" {
  vpc_id          = "${aws_vpc.germany-cluster-cto-logi-com.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.germany-cluster-cto-logi-com.id}"
}

terraform = {
  required_version = ">= 0.9.3"
}
