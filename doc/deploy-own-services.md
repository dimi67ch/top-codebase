# Deploy your own services

## Create a Helm Chart
The first step is to create a Helm chart for your service you want to deploy to the Kubernetes cluster.\
See [chapter Helm charts](./helm-charts.md).

## Add to Repository
Then you should add your folder to the repository in `microservices/src`.

### Push a new service in this way (example with frontend-service):

``` bash
microservices
|_src  # must be this directory
   |_frontend  # name doesnt matter
        |_frontend-service  # must be service name with '-service' at the end; this directory gets packaged
        |     |_Chart.yaml
        |     |_values.yaml
        |     |_templates
        |           |_deployment.yaml
        |           |_service.yaml
        |_Dockerfile  # That Dockerfile is built
        |_ ...
 
```

A pipeline will automatically build your Docker image out of your Dockerfile and package your Helm chart and will upload them to the [container registry](./gitlab-container-registry.md) and the [package registry](./gitlab-package-registry.md). You can also upload them manually.\
See for [Dockerfiles](./gitlab-container-registry.md#manually) and [packages](./gitlab-package-registry.md#manually).

## Deploy Helm Chart into the Kubernetes Cluster

If your image and Helm chart have succesfully been uploaded you are ready to deploy your service to the cluster.

### via Ansible Playbook

Go to the file `codebase/ansible/group_vars/all.yaml`.\
Add the following lines of code:

- under the section repositories for downloading the private repo (package registry)

  ```yaml
  repositories:
    - repo_name: "gitlab-rlp"
      repo_url: "https://gitlab.rlp.net/api/v4/projects/39843/packages/helm/stable"
      repo_username: "gitlab+deploy-token-247"
      repo_password: "gldt-G4NVnsZx8yx56MpXRvsC"
  ```
  > **Note:** `repo_username` and `repo_password` are a gitlab token which expires at some point so you might have to create a new one to access the private package registry. See [here](./gitlab-tokens.md).

- under the section deployments for deploying the service on the cluster

  ```yaml
  deployments:
    - name: "secplay-website"
      chart_ref: "gitlab-rlp/secplay-website"
  ```
  > **Note:** `name`is will be the pod name and `cart_ref` is the specified helm chart
  
  If you push the change the [pipeline](./pipelines.md#codebase-pipeline) will automatically execute the playbook.
  Otherwise you can execute the playbook manually with:

  ```bash
  ansible-playbook -i inventory.ini playbook.yaml
  ```

### Manually

If you want to deploy your service without using Ansible you can go to the command line of the system where your cluster is running and type in:

- add repository
  ```bash
  helm repo add "gitlab-abc" "https://gitlab.rlp.net/api/v4/projects/39843/packages/helm/stable" --username=gitlab+deploy-token-247 --password=gldt-G4NVnsZx8yx56MpXRvsC
  ```
  > **Note:** values of `username` and `password` are a gitlab token which expires at some point so you might have to create a new one to access the private package registry. See [here](./gitlab-tokens.md).

- deploy service

  ```bash
  helm install "secplay-website" "gitlab-rlp/secplay-website"
  ```