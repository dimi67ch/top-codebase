# KubeVirt

## Installation

Installation is done via the `kubevirt` role in the `playbook.yml` file. The role installs the KubeVirt extension and virtctl for Kubernetes, which allows you to run virtual machines on microk8s.

## Usage

### Without Persistent Storage (does not work with microk8s)

To use KubeVirt without persistent storage, you can use the following steps:

1. **Create a VirtualMachineInstance**:
   ```yaml
   apiVersion: kubevirt.io/v1
   kind: VirtualMachineInstance
   metadata:
     name: <vmi-name>
   spec:
     domain:
       devices:
         disks:
           - name: containerdisk
             containerDisk:
               image: <container-image>
   ```

   Replace `<vmi-name>` with the name of the VirtualMachineInstance and `<container-image>` with the container image you want to use.

### OR

### With Persistent Storage

To use KubeVirt with persistent storage, you can use the following steps:

1. **Create a VirtualMachineInstance**:
   ```yaml
   apiVersion: kubevirt.io/v1
   kind: VirtualMachineInstance
   metadata:
     name: <vmi-name>
   spec:
     domain:
       devices:
         disks:
           - name: containerdisk
             persistentVolumeClaim:
               claimName: <pvc-name>
   ```

   Replace `<vmi-name>` with the name of the VirtualMachineInstance and `<pvc-name>` with the name of the PersistentVolumeClaim.

   ```yaml
    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
      name: <pvc-name>
    spec:
      accessModes:
        - ReadWriteOnce
      resources:
        requests:
          storage: 1Gi
    ```

### Basic Commands

2. **Create the VirtualMachineInstance**:
    ```shell
    kubectl apply -f <vmi-file>.yaml
    ```

    Replace `<vmi-file>` with the name of the file you created in the previous step.

3. **Start the VirtualMachineInstance**:
    ```shell
    virtctl start <vmi-name>
    ```

    Replace `<vmi-name>` with the name of the VirtualMachineInstance.

4. **Access the VirtualMachineInstance**:
    ```shell
    virtctl console <vmi-name>
    ```

    Replace `<vmi-name>` with the name of the VirtualMachineInstance.

5. **Stop the VirtualMachineInstance**:
    ```shell
    virtctl stop <vmi-name>
    ```

### Considerations

**1:** Working without Persistent Volume Claims does not work with microk8s, as it does not support creating VMS without the `PersistentVolume` and `PersistentVolumeClaim` resources. If you want to use KubeVirt without persistent storage, you will need to use a different Kubernetes distribution. We worked around this with the use of `CDI`, that automatically creates the `PersistentVolume` and `PersistentVolumeClaim` resources for you (see the `cdi` role in the `playbook.yml` file and the ubuntu helm chart).

**2:** The current VM does not have enough resources to run more than one Virtual Machine alongside the pods. You will need to allocate more resources to the VM in order to run many Virtual Machines side by side. Bear in mind that even the fresh installation of a VM with KubeVirt will consume a lot of resources, will slow down the Host-VM in general and will take a long time to start (up to 5 minutes).

**3:** To expose the ports of the VirtualMachineInstance, you can use the `Service` resource. The `Service` resource will expose the ports of the VirtualMachineInstance to the outside world (see Ubuntu Helm Chart for an example).













