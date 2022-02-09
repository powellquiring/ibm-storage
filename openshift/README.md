# openshift
Copied [secure-roks-cluster](https://github.com/terraform-ibm-modules/terraform-ibm-cluster/tree/master/examples/secure-roks-cluster)See template.local.env

TODO create template

```
cd secure-roks-cluster
terraform init
terraform apply

module.vpc_ocp_cluster.ibm_container_vpc_cluster.cluster: Still creating... [1h33m2s elapsed]
module.vpc_ocp_cluster.ibm_container_vpc_cluster.cluster: Still creating... [1h33m12s elapsed]
module.vpc_ocp_cluster.ibm_container_vpc_cluster.cluster: Still creating... [1h33m22s elapsed]
module.vpc_ocp_cluster.ibm_container_vpc_cluster.cluster: Creation complete after 1h33m32s [id=c81cddgd0b8kv9b9bumg]
module.configure_cluster_logdna.ibm_ob_logging.logging: Creating...
module.configure_cluster_logdna.ibm_ob_logging.logging: Still creating... [10s elapsed]
module.configure_cluster_logdna.ibm_ob_logging.logging: Creation complete after 17s [id=c81cddgd0b8kv9b9bumg/50ef9439-aba7-453b-9ef7-28041dd2b1cf]
module.configure_cluster_sysdig.ibm_ob_monitoring.sysdig: Creating...
module.configure_cluster_sysdig.ibm_ob_monitoring.sysdig: Still creating... [10s elapsed]
module.configure_cluster_sysdig.ibm_ob_monitoring.sysdig: Creation complete after 16s [id=c81cddgd0b8kv9b9bumg/67987421-09cf-492e-a5c7-d2126e845137]
module.patch_monitoring.data.ibm_container_vpc_cluster.cluster: Reading...
module.patch_monitoring.time_sleep.wait_1m: Creating...
module.patch_monitoring.data.ibm_container_vpc_cluster.cluster: Still reading... [10s elapsed]
module.patch_monitoring.time_sleep.wait_1m: Still creating... [10s elapsed]
module.patch_monitoring.data.ibm_container_vpc_cluster.cluster: Read complete after 19s [id=c81cddgd0b8kv9b9bumg]
module.patch_monitoring.data.ibm_container_cluster_config.clusterConfig: Reading...
module.patch_monitoring.time_sleep.wait_1m: Still creating... [20s elapsed]
module.patch_monitoring.data.ibm_container_cluster_config.clusterConfig: Still reading... [10s elapsed]
module.patch_monitoring.time_sleep.wait_1m: Still creating... [30s elapsed]
module.patch_monitoring.data.ibm_container_cluster_config.clusterConfig: Still reading... [20s elapsed]
module.patch_monitoring.time_sleep.wait_1m: Still creating... [40s elapsed]
module.patch_monitoring.data.ibm_container_cluster_config.clusterConfig: Still reading... [30s elapsed]
module.patch_monitoring.time_sleep.wait_1m: Still creating... [50s elapsed]
module.patch_monitoring.data.ibm_container_cluster_config.clusterConfig: Still reading... [40s elapsed]
module.patch_monitoring.time_sleep.wait_1m: Creation complete after 1m0s [id=2022-02-08T21:13:33Z]
╷
│ Warning: Argument is deprecated
│
│   with module.kms.ibm_kms_key.key,
│   on .terraform/modules/kms/modules/key-protect/main.tf line 23, in resource "ibm_kms_key" "key":
│   23: resource "ibm_kms_key" "key" {
│
│ Support for creating Policies with the key will soon be removed, Utilise the new resource for creating policies for the keys => ibm_kms_key_policies
╵
╷
│ Error: Error downloading the cluster config [c81cddgd0b8kv9b9bumg]: Get "https://c107-e.private.us-south.containers.cloud.ibm.com:30272/.well-known/oauth-authorization-server": dial tcp 166.9.12.193:30272: i/o timeout
│
│   with module.patch_monitoring.data.ibm_container_cluster_config.clusterConfig,
│   on patch-sysdig/main.tf line 5, in data "ibm_container_cluster_config" "clusterConfig":
│    5: data "ibm_container_cluster_config" "clusterConfig" {
│
╵
```
