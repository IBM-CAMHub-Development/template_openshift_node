# Template OpenShift Node

The OpenShift Node Terraform template and inline modules will provision several virtual machines, install prerequisites and add node to existing OpenShift cluster within you vmWare Hypervisor environment.

##### This template can be used to add nodes to OCP deployed using [OCP Installer](https://github.com/IBM-CAMHub-Open/template_openshift_installer). 

The components of the deployment include:

- Compute Nodes (1 to n Nodes)

## OpenShift Container Platform Versions

| OpenShift Version | GitTag Reference|
|------|:-------------:|
| 3.11 | 3.11 |

## System Requirements

### Hardware requirements

OpenShift Container Platform must meet the following requirements:
<https://docs.openshift.com/container-platform/3.11/install/prerequisites.html#hardware>

This template will setup the following hardware minimum requirements:

| Node Type | CPU Cores | Memory (mb) | Disk 1 | Disk 2 | Number of hosts |
|------|:-------------:|:----:|:-----:|:-----:|:-----:|
| Compute Node | 1 | 8192 | 100 | n/a | 1 |
| Compute Node (with glusterfs | 1 | 8192 | 100 | 100 | 1 |

For minimum directory space requirements, i.e. /var/ or /usr/local/bin/, 
please refer to https://docs.openshift.com/container-platform/3.11/install/prerequisites.html#hardware

### Supported operating systems and platforms

The following operating systems and platforms are supported.

***Red Hat Enterprise Linux (RHEL) 7.4 or later***

- VMware Tools must be enabled in the image for VMWare template.
- Sudo User and password must exist and be allowed for use.
- SELinux must be enabled. 
https://access.redhat.com/documentation/en-us/red_hat_gluster_storage/3.1/html/installation_guide/chap-enabling_selinux
- Minimum recommended kernel version is '3.10.0-862.14.4'
