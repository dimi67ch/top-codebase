# Playbook Usage

## Prerequisites

- Install Ansible on your local device. You can follow the guide [here](https://docs.ansible.com/ansible/latest/installation_guide/index.html).
- Copy your public key to targets with:
  ```bash 
  ssh-copy-id <username>@<targetIP>
  ```

## Roles

The Playbook consists of 4 roles:
- **snapd**: Installs and enables snapd, required for installing microk8s later.
- **microk8s**: Installs a single-node microk8s cluster and its CLI tool kubectl.
- **helm**: Downloads the helm binary, extracts it, moves it into the target directory, and installs python3-yaml.
- **helm-deploy**: Downloads requested helm repositories and deploys images via helm into the Kubernetes cluster.

## Inventory file

The inventory file is located at `codebase/ansible/quick_deploy/inventory.ini`. There you can list your target host with their IP addresses or domain names and the user of the target.
For example:
```bash
[target]
securityplayground.projekte.it.hs-worms.de ansible_connection=ssh ansible_ssh_user=securityplayground
```

## Setting Playbook

You can find the playbook at `codebase/ansible/quick_deploy/playbook.yml`. This main playbook includes the roles, and you can decide which of them you want to be executed. By default, every one of them is run.

In the file `codebase/ansible/quick_deploy/group_vars/all.yml`:

### You can configure:
  - Your **processor architecture** (for downloading the correct Helm binary).

### You can list:
  - which **Helm repositories** you want to download.
    - For example, you can download the `bitnami` repository like this:
      ```yaml
      repositories:
        - repo_name: "bitnami"
          repo_url: "https://charts.bitnami.com/bitnami"
      ```
      You can download every Helm chart repo you want by listing its `repo_name` and `repo_url` under the `repositories` section. 
  - which **container images** you want to deploy on your Kubernetes cluster.
    - After downloading the required repos, you can install Helm charts like this:
    ```yaml
    deployments:
      - name: "wordpress"
        chart_ref: "bitnami/wordpress"
    ```
    In this case we deployed **wordpress** from the **bitnami repo** we downloaded before. You can install every Helm chart you want by listing its `name` and `chart_ref` under the `deployments` section.

## Set attribute on deployments
You can set attributes of your helm chart deployments in the playbook by overriding the existing ones.
For that, you can use the `set_values:` key and list your wished attributes in key:value style:
```yaml
deployments:
  - name: "wordpress"
    chart_ref: "bitnami/wordpress"
    set_values:
      - value: "service.nodePorts.http=32000"
      - value: "replicaCount=3"
```
For example, you can set Kubernetes specific attributes like `replicas` or the `exposed ports` by services (like shown above) or others like `service type` and many more.

In this case, we set the `replicaCount`, which corresponds to Kubernetes' `replicas` attribute, to *3*. The designation of Kubernetes attributes can vary across different Helm charts.
e.g., changing *replicas* in *PhpMyAdmin* Helm chart:
```yaml
  - name: "phpmyadmin"
    chart_ref: bitnami/phpmyadmin
    set_values:
    - value: "replicas=2" # 'replicas' in phpmyadmin = 'replicaCount' in wordpress
```

You can verify these designations in the documentation of the Helm charts, such as for **wordpress** available at [https://artifacthub.io/packages/helm/bitnami/wordpress](https://artifacthub.io/packages/helm/bitnami/wordpress).

Additionally, the **port** exposed by the Wordpress service is configured to **32000**. Therefore, your Wordpress deployment remains accessible at that port.
To specify the **Wordpress version** to a specific release, like **6.0.0**, you can include `- value: "image.tag=6.0.0"` in the list of `set_values`. However, it's important to note that the method for changing versions may vary from one Helm chart to another.

If you apply changes on this file, save and push it, a pipeline will be triggered and deploys the changes automatically on the Kubernetes cluster. See [Chapter Pipelines](https://gitlab.rlp.net/groups/top/24s/secplay/-/wikis/Pipelines)

## Deploy own Helm Charts

## Port rules
The **port range** that our Kubernetes cluster can use is between **30000 and 32767** without using Kubernetes Ingress ressources.
To make it easier we chose to set the following port rules:
- for **own Helm chart deployments** use **30000** to **32000**
- for **other** Helm char tdeployments use **32001** to **32767**
- we assign the port numbers in the `codebase/ansible/quick_deploy/group_vars/all.yml` in a **numeric way from up to down beginning on 30000 in ten steps**

## Execute the Playbook

To execute the whole playbook:
```bash
 ansible-playbook -i inventory.ini playbook.yml
```

To execute only the helm_deploy role to deploy new services:

```bash
 ansible all -i inventory.ini -m include_role -a name=helm_deploy -e @group_vars/all.yml
```