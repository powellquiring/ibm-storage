resource "ibm_is_vpc" "openshift" {
  name           = "example-vpc"
  resource_group = local.resource_group
}

resource "ibm_is_security_group_rule" "open_inbound" {
  group     = ibm_is_vpc.openshift.default_security_group
  direction = "inbound"
}


resource "ibm_is_public_gateway" "openshift" {
  for_each       = local.zones
  name           = each.value.name
  vpc            = ibm_is_vpc.openshift.id
  zone           = each.value.zone
  resource_group = local.resource_group
}


resource "ibm_is_subnet" "openshift" {
  for_each                 = ibm_is_public_gateway.openshift
  name                     = each.value.name
  vpc                      = ibm_is_vpc.openshift.id
  zone                     = each.value.zone
  total_ipv4_address_count = 256
  public_gateway           = each.value.id
  resource_group           = local.resource_group
}