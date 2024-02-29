# Pipelines

In this project we use **two** Pipelines:
- a pipeline in the subproject `codebase` which deploys your specified Helm charts in the `codebase/ansible/quick_deploy/group_vars/all.yaml` on the Kubernetes Cluster
- a pipeline in the subproject `microservices` which automatically builds docker images out of Dockerfiles and packages Helm specific files 

## `Codebase`-Pipeline
![codebase_pipeline.drawio.svg](img/codebase-pipeline-diagram.svg)

This pipeline listens if there are any changes in the `codebase/ansible/quick_deploy/group_vars/all.yaml` file.
Example:
If you change the file from this:
```yaml
deployments:
  # WORDPRESS
  - name: "wordpress"
    chart_ref: "bitnami/wordpress"
    set_values:
     - value: "service.nodePorts.http=32000" # Port
```
to this:
```yaml
deployments:
  # WORDPRESS
  - name: "wordpress"
    chart_ref: "bitnami/wordpress"
    set_values:
     - value: "service.nodePorts.http=32000" # Port
  # APACHE
  - name: "apache"
    chart_ref: bitnami/apache
    set_values:
     - value: "service.type=LoadBalancer" 
     - value: "service.nodePorts.http=32010" # Port
```
The pipeline will get triggered and automatically deploy an `apache` instance into the Kubernetes cluster.
In case the pipeline executes the **playbook role helm deploy**.

### Repository mirroring into gitlab.ai.it.hs-worms.de
The initial problem was that the VM refused the ansible ssh connection from the external **gitlab.rlp.net** server.
Therefore, we mirrored the `codebase` subproject to the internal **gitlab.ai.it.hs-worms** which synchronizes itself with gitlab.rlp.net server and triggers the same pipeline but internally.

### SSH-Authentification with Target Server
Normally, you would execute the ansible playbook like this:
```bash
 ansible-playbook -i inventory.ini playbook.yaml -K
```
The `-K` is the **ansible_become_password**, basically the sudo password, which is required to execute the playbook tasks.
We turned the password off the following way:
```bash
sudo visudo
```
```bash
%sudo   ALL=(ALL:ALL) NOPASSWD: ALL
```
Also, we changed the file `/etc/ssh/sshd_config` the following:
```bash
PasswordAuthentication no
ChallengeResponseAuthentication no
UsePAM no
```
```bash
systemctl reload sshd
```
So we turned off the sudo password and the ssh password authentification.
To connect with the VM from now on, your public Key has to be registered in the VMs `~/.ssh/authorized_keys` file.
This way, the pipeline can connect to the VM without the `-K` flag.

## Microservices-`Pipeline`
![microservice-pipeline.drawio.svg](img/microservice-pipeline-diagram.svg)

This pipeline does two things:
1) **Building Docker images** from newly pushed Dockerfiles. For the pipeline to be successfully triggered and the Dockerfile to be found, you have to place your Dockerfile like the following way `microservices/src/<service-name>/Dockerfile`. The image will be built and uploaded to the **container registry** (on gitlab.rlp.net).
2) **Packaging newly pushed Helm charts**. Therefore, if you want to create own Helm charts yourself, you have to push them like this: `microservices/src/<service-name>/*-service`. So the directory which contains the charts **must** be named <anything>**-service** e.g. costumer-**service. If this is the case, the pipeline will package the content of this directory like the **Chart.yaml**, **values.yaml** the **templates** directory into a **tgz** file and upload it to the **package registry** (on gitlab.rlp.net). The name of the package will be the same as the name of the directory which was packaged e.g. costumer-service.

Due to the pipeline to be successful, you should push your new services like [this](./deploy-own-services.md#push-a-new-service-in-this-way-example-with-frontend-service) in the repository.