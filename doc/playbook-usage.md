# Playbook Usage

## Prerequisites

- Install Ansible on your local device. You can follow the guide [here](../README.md).
- Copy your public key to target(s) with:

  ```bash 
  ssh-copy-id <username>@<targetIP>
  ```

## Roles

The Playbook consists of 5 roles:
- **snapd**: Installs and enables snapd, required for installing microk8s later.
- **microk8s**: Installs a single-node microk8s cluster and its CLI tool kubectl.
- **helm**: Downloads the helm binary, extracts it, moves it into the target directory, and installs python3-yaml.
- **helm-deploy**: Downloads requested helm repositories and deploys images via helm into the Kubernetes cluster.
- **k8s_rbac**: Set up namespace and credentials for every user such as permissions. Allows also the addition and deletion of users.
- **kubevirt**: Installs the KubeVirt extension and virtctl for Kubernetes, which allows you to run virtual machines on microk8s.

## Inventory file

The inventory file is located at `codebase/ansible/inventory.ini`. There you can list your target host with their IP addresses or domain names and the user of the target.
For example:

```ini
[target]
securityplayground.projekte.it.hs-worms.de ansible_connection=ssh ansible_ssh_user=securityplayground
```

## Setting Playbook

You can find the playbook at `codebase/ansible/playbook.yml`. This main playbook includes the roles, by default, every one of them is run.

In the file `codebase/ansible/group_vars/all.yml`:

### You can configure:

  - You can set the amount of **users accounts** you want to access your Kubernetes cluster (in their own isolated **namespace**). See more [here](./kubernetes-add-users.md).

  ```yaml
  usercount: 3
  ```

  - Your **processor architecture** (for downloading the correct Helm binary).

  ```yaml
  arch: amd64 # or arm64
  ```

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

  - which additional **files** you want to apply to the Kubernetes cluster

    ```yaml
    files:
    - filename: "docker_registry_config.yaml"
    - filename: "docker_registry_config_fullstack.yaml"
    - filename: "http-ingress.yaml"
    ```

    That files have to be located in `codebase/ansible/roles/microk8s/files/` and automatically will be applied in a loop.
   

## Set attribute on deployments

You can set attributes of your Helm chart deployments in the playbook by overriding the existing ones.
For that, you can use the `set_values:` key and list your wished attributes in **key=value** style:

```yaml
deployments:
  - name: "wordpress"
    chart_ref: "bitnami/wordpress"
    set_values:
      - value: "service.nodePorts.http=32000"
      - value: "replicaCount=3"
```

For example, you can set Kubernetes specific attributes like `replicas` or the `exposed ports` by services (like shown above) or others like `service type`, `namespaces` and many more.

In this case, we set the `replicaCount`, which corresponds to Kubernetes' `replicas` attribute, to *3*. The designation of Kubernetes attributes can vary across different Helm charts.
e.g., changing **replicas in PhpMyAdmin** Helm chart:

```yaml
  - name: "phpmyadmin"
    chart_ref: bitnami/phpmyadmin
    set_values:
    - value: "replicas=2" # 'replicas' in phpmyadmin = 'replicaCount' in wordpress
```

You can verify these designations in the documentation of the Helm charts, such as for **wordpress** available at [artifacthub](https://artifacthub.io/packages/helm/bitnami/wordpress).

Additionally, the **port** exposed by the Wordpress service is configured to **32000**. Therefore, your Wordpress deployment remains accessible at that port.

> Note: The **port range** that our Kubernetes cluster can use is between **30000 and 32767**.

> Note: Kubernetes service type `ClusterIP` does not expose a port to outside the cluster.

To specify the **Wordpress version** to a specific release, like **6.0.0**, you can include `- value: "image.tag=6.0.0"` in the list of `set_values`. However, it's important to note that the method for changing versions may vary from one Helm chart to another.

If you apply changes on this file, save and push it, a pipeline will be triggered and deploys the changes automatically on the Kubernetes cluster. See [chapter Pipelines](./pipelines.md).

## Deploy own Helm Charts

See [chapter "Deploy own services](./deploy-own-services.md).

## Port rules

The **port range** that our Kubernetes cluster can use is between **30000 and 32767**.
To make it easier we chose to set the following port rules:
- for **own Helm chart deployments** use **30000** to **32000**
- for **other** Helm char tdeployments use **32001** to **32767**
- we assign the port numbers in the `codebase/ansible/group_vars/all.yml` in a **numeric way from up to down beginning on 30000 in ten steps**


## Execute the Playbook

You can use scripts that are in `codebase/scripts/`.

To execute the whole playbook:

```bash
./run_playbook.sh
```

To execute only the helm_deploy role to deploy new services:

```bash
./run_helm_deploy.sh
```

### Multiple executions of the playbook

- When you execute the playbook multiple times with nothing changed in the `all.yml` file, nothing will change because of Ansible's idempotence.
- When you execute it with a deployed service not in `all.yml` anymore, Ansible will use Helm to uninstall it.
- When you execute the playbook with changed a version number of a service, there a two scenarios:
  - higher version number: Helm will upgrade it (if possible)
  - lower version number: Helm will downgrade the deployment (if possible, e.g. in wordpress its not possible)
  > **Note:** Its still possible to deploy the same service with different versions as two separate deployments.

> **Caution:** If Helm ist not updating any of your newly edited configuration (like new port number etc.) by using the playbook, try do it manually by first uninstalling the Helm installation with `helm uninstall \<name>` and then executing the playbook again. This should deploy the service with your latest required settings.