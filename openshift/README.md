# openshift
## create cluster - did not work
This did not work as is, needed to make following changes after provisioning:
- security group outbound (set to ANY, could ratchet down further)
- public gateways in each subnet to install software

DO NOT DO THIS:
Copied [secure-roks-cluster](https://github.com/terraform-ibm-modules/terraform-ibm-cluster/tree/master/examples/secure-roks-cluster)  See template.local.env for example configuration

## create cluster
This can take 3 or more hours.  This will create:
- vpc resources required to support the OpenShift cluster
- COS instance required by the cluster
- OpenShift cluster

```
cd roks-vpc
cp template.local.env local.env
edit local.env
source local.env
terraform init
terraform apply
```
## Deploying OpenShift Data Foundation on VPC clusters
[Deploying OpenShift Data Foundation on VPC clusters](https://cloud.ibm.com/docs/openshift?topic=openshift-deploy-odf-vpc)

```
ibmcloud oc clusters
c=nameOfCluster
ibmcloud oc cluster config -c  $c --admin
ibmcloud oc cluster addon versions
oc version
oc get storageclasses
ibmcloud oc cluster addon enable openshift-data-foundation -c $c --version 4.7.0

# repeat:
oc get storageclasses
sleep 60

# eventually you will see:
oc get storageclasses
NAME                                          PROVISIONER                             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
ibmc-vpc-block-10iops-tier (default)          vpc.block.csi.ibm.io                    Delete          Immediate              false                  18h
...
ocs-storagecluster-ceph-rbd                   openshift-storage.rbd.csi.ceph.com      Delete          Immediate              true                   41s
ocs-storagecluster-ceph-rgw                   openshift-storage.ceph.rook.io/bucket   Delete          Immediate              false                  40s
ocs-storagecluster-cephfs                     openshift-storage.cephfs.csi.ceph.com   Delete          Immediate              true                   41s
```

Output of addon enable:
```
$ ibmcloud oc cluster addon enable openshift-data-foundation -c $c --version 4.7.0
This add-on has customizable installation options. Continue with default values? [y/N]> y
Enabling add-on openshift-data-foundation(4.7.0) for cluster storage01...
The add-on might take several minutes to deploy and become ready for use.
Using installation options...

Add-on Options
Option                Value
ocsUpgrade            false
workerNodes           all
clusterEncryption     false
monDevicePaths        <Please provide IDs of the disks to be used for mon pods if using local disks or standard classic cluster>
monSize               20Gi
odfDeploy             true
osdDevicePaths        <Please provide IDs of the disks to be used for OSD pods if using local disks or standard classic cluster>
osdSize               250Gi
osdStorageClassName   ibmc-vpc-block-metro-10iops-tier
billingType           advanced
monStorageClassName   ibmc-vpc-block-metro-10iops-tier
numOfOsd              1
OK
```

## PVC

Create the PVC

```
# Take a look at stuff:
oc get sc | grep openshift
oc get projects
oc get pvc
# Expected: No resources found in default namespace.

# create pvc:
oc create -f pvc-cephfs.yaml

# repeat until not pending:
oc get pvc
# oc get pvc
# NAME      STATUS    VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS                AGE
# odf-pvc   Pending                                      ocs-storagecluster-cephfs   17s
oc get pvc
# NAME      STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS                AGE
# odf-pvc   Bound    pvc-4182f2ae-78f8-4646-9f5c-58ced7d27d0e   1Gi        RWO            ocs-storagecluster-cephfs   11m

oc apply -f pod.yaml
oc get pod
p=app
oc exec -it $p  -- bash
```
Look at the file created in the PVC:
```
root@app:~# cat /test/test.txt
Tue Feb 15 14:50:19 UTC 2022
```

Output of volumes:
```
$ ibmcloud is volumes
Listing volumes in resource group snaps and region us-south under account Powell Quiring's Account as user pquiring@us.ibm.com...
ID                                          Name                                       Status      Capacity   IOPS   Profile       Attachment type   Zone         Resource group
r006-052144a1-b0b0-4095-a4b1-6b2bbbed9740   pvc-a217278c-61ac-409b-9341-afbcaf739dd2   available   20         3000   10iops-tier   data              us-south-1   snaps
r006-470c068e-2083-48ae-b1d0-90815f87a7ee   pvc-bf90bb4b-1a04-438c-a644-e337303bf5e9   available   250        3000   10iops-tier   data              us-south-1   snaps
r006-7637d02b-33ec-4817-89c3-f05c3362479e   pvc-113457ee-737d-46d5-92bf-01761d3f15ac   available   250        3000   10iops-tier   data              us-south-2   snaps
r006-a1fac942-2c32-4d0e-870a-5dcaa36d4bad   pvc-3ea4cb89-29c2-4a3f-81d5-e457d7c4fa0b   available   20         3000   10iops-tier   data              us-south-2   snaps
r006-e03f98e6-39d3-481e-8ddf-00d5c2d02a18   pvc-1a89feca-5fa2-45e0-835e-7cc58e90fe50   available   250        3000   10iops-tier   data              us-south-3   snaps
r006-3fe887c5-53a1-42f0-a478-48276667258a   pvc-43ff18d4-27ec-45f1-9bf5-ca95270651a3   available   20         3000   10iops-tier   data              us-south-3   snaps
```
## Console Problem debug
```
oc get pod --all-namespaces | grep "openshift-console "
openshift-console                                  console-658d5f94df-lhph5                                 0/1     CrashLoopBackOff   109        10h
openshift-console                                  console-658d5f94df-m7xvf                                 0/1     CrashLoopBackOff   109        10h
openshift-console                                  console-7868699768-smxlv                                 0/1     CrashLoopBackOff   117        11h

p=openshift-console

```
for pod in console-658d5f94df-lhph5 console-658d5f94df-m7xvf console-7868699768-smxlv ; do 

for pod in console-658d5f94df-lhph5 ; do
  oc describe pod -n openshift-console $pod
  oc logs -n openshift-console  pod/$pod
done | tee /tmp/out.txt

  oc get pods --all-namespaces | grep Pending

  oc get pods -n kube-system -l app=vpn
  vpn_pod=vpn-5c899c6445-n7xlq
  oc logs -n kube-system $vpn_pod --tail 10




