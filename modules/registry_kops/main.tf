terraform {
  required_providers {
    kops = {
      source  = "eddycharly/kops"

# 해당 버전에서는 문서에 있던 TODO: networking으로 있던 spec attribuet들이 kops doc에 있는 위치와 동일하게 이동되고
# apply시에 생성되는 설정파일들의 내용이 변경됨. 내용은 아래와 같음
# config 설정파일에 spec.configBase 속성이 추가되었고 해당 속성을 제거하면 kops delete 시에 s3에 있는 객체도 같이 제거되고
# (가설) kops create 당시에 생성된 인증서를 이용해서 kubelet에 인증하지 못하므로 api 서버와 정상적으로 통신하지 못함
# instanceGroup 설정파일에 spec.kubelet.anonymousAuth 속성이 추가됨
# spec.kubelet.taints 속성이 추가됨
      version = "1.26.0-alpha.1"
    }
  }
}

provider "kops" {
  state_store = var.s3_bucket_id

  aws {
    region = "ap-northeast-2"
    profile = "default"
    access_key = var.aws_access_key_id
    secret_key = var.aws_access_key_secret
  }
}

# terraform apply 최초 실행 시에는 configBase가 잡히지 않지만 그 다음부터는 configBase가 kops 설정파일에 명세되므로 제거해야함
resource "kops_cluster" "cluster" {
  name                 = var.domain_name
  admin_ssh_key        = var.ssh_key

# 최신버전인 1.27.0 이상은 private network에 프로비저닝된 vpn 연결을 하든 안 하든 node를 식별할 수 없음 
  kubernetes_version   = "1.26.6"

#  dns_zone             = var.domain_name

  cloud_provider {
    aws {}
  }

  ssh_access = [var.public_subnets_cidr_blocks[0], var.private_subnets_cidr_blocks[0]]
  node_port_access = ["10.0.0.0/16"]
  ssh_key_name = var.key_name

  iam {
    allow_container_registry = true
  }

  kube_proxy {
    enabled = false
  }

  kubelet {

# cluster config 파일에는 spec.kubelet.anonymousAuth = false여도 api를 호출할 수 있으나 instance에 해당 속성이 설정될 경우 api 호출이 불가능함
    anonymous_auth {
      value = false
    }
  }

  kube_api_server {
    anonymous_auth {
      value = false
    }
  }

  networking {
    network_id = var.vpc_id

    subnet {
      name = var.private_subnet_name
      id = var.private_subnets[0]
      type = "Private"
      zone = var.azs[0]
    }

    topology {
      control_plane = "private"
      nodes   = "private"

      dns = "Private"
    }

# 사용 시 모든 노드들이 NotReady 상태에서 Ready 상태로 바뀌지 않음
#    calico {}

    cilium {
      preallocate_bpf_maps = true
      enable_remote_node_identity = true
      enable_node_port = true
    }
  }

  api {
    access = [var.vpc_cidr_block]
    dns {
    }
#    load_balancer {
#        class = "Classic"
#        type = "Internal"
#        subnets {
#            name = var.private_subnet_name
#        }
#    }
  }

  # etcd clusters
  etcd_cluster {
    name            = "main"

    member {
      name             = "${var.appname}-master-0"
      instance_group   = "${var.appname}-master-0"
    }
  }

  etcd_cluster {
    name            = "events"

    member {
      name             = "${var.appname}-master-0"
      instance_group   = "${var.appname}-master-0"
    }
  }
}

resource "kops_instance_group" "master-0" {
  cluster_name = kops_cluster.cluster.name
  name         = "${var.appname}-master-0"
  role         = "ControlPlane"
  image        = "ami-0c9c942bd7bf113a2"
  min_size     = 1
  max_size     = 1
  machine_type = "t3.medium"
  subnets      = [var.private_subnet_name]
  depends_on   = [kops_cluster.cluster]
}

resource "kops_instance_group" "node-0" {
  cluster_name = kops_cluster.cluster.id
  name         = "${var.appname}-node-0"
  role         = "Node"
  image        = "ami-0c9c942bd7bf113a2"
  min_size     = 1
  max_size     = 2
  machine_type = "t3.medium"
  subnets      = [var.private_subnet_name]
  depends_on   = [kops_cluster.cluster]
}

resource "kops_cluster_updater" "updater" {
  cluster_name = kops_cluster.cluster.id

  keepers = {
    cluster  = kops_cluster.cluster.revision
    master-0 = kops_instance_group.master-0.revision
    node-0   = kops_instance_group.node-0.revision
  }

  apply {
    skip = true
  }

  rolling_update {
    skip = true
  }

  validate {
    skip = true
  }
}