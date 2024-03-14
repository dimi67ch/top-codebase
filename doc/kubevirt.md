# KubeVirt

## Installation

Installation is done via the `kubevirt` role in the `playbook.yml` file. The role installs the KubeVirt extension and virtctl for Kubernetes, which allows you to run virtual machines on microk8s.

## Usage

### Without Persistent Storage

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


### With Persistent Storage

tbd
