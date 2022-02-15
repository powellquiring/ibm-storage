data "ibm_resource_group" "group" {
  name = var.resource_group
}

resource "ibm_resource_instance" "cos_instance" {
  name              = local.name
  location          = "global"
  resource_group_id = local.resource_group
  service           = "cloud-object-storage"
  plan              = "standard"
  tags              = local.tags
}

module "vpc_ocp_cluster" {
  source  = "terraform-ibm-modules/cluster/ibm//modules/vpc-openshift"
  version = "1.4.0"
  #depends_on = [
  #  null_resource.delete_default_egress_security_rule
  #]
  cluster_name                    = local.name
  vpc_id                          = ibm_is_vpc.openshift.id
  worker_pool_flavor              = var.flavor
  resource_group_id               = local.resource_group
  kube_version                    = "4.7.40_openshift"
  worker_zones                    = local.worker_zones
  worker_nodes_per_zone           = 1
  tags                            = local.tags
  disable_public_service_endpoint = false
  # entitlement                     = var.ocp_entitlement
  cos_instance_crn                = ibm_resource_instance.cos_instance.id
  # kms_config                      = local.kms_config
  worker_labels  = { worker = local.name }
  create_timeout = "4h"
  wait_till      = "ingressReady"
}
