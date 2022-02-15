locals {
  resource_group = data.ibm_resource_group.group.id
  name           = var.basename
  zones = { for i in range(3) : i => {
    zone =  "${var.region}-${i + 1}"
    name =  "${local.name}-${var.region}-${i + 1}"
  }}
  worker_zones = {for k, v in ibm_is_subnet.openshift: 
    v.zone => {subnet_id = v.id}
  }
  tags = [
    "basename:${var.basename}",
    lower(replace("dir:${abspath(path.root)}", "/", "_")),
  ]
}
output zones {
  value = local.worker_zones
  }