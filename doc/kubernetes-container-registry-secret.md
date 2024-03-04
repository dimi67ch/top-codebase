# Kubernetes Container Registry Secret 'gitlab-rlp'

So that Kubernetes is able to **authenticate to the gitlab** container registry to pull docker images and deploy containers, we defined a Kubernetes Secret resource.\
## How to create a Secrets file
Our Secret file `docker_registry_config.yaml` looks like this:
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: gitlab-rlp
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: eyJhdXRocyI6eyJyZWdpc3RyeS5naXRsYWIucmxwLm5ldC90b3AvMjRzL3NlY3BsYXkvbWljcm9zZXJ2aWNlcyI6eyJ1c2VybmFtZSI6ImdpdGxhYitkZXBsb3ktdG9rZW4tMjQ4IiwicGFzc3dvcmQiOiJnbGR0LUdDMzZjcUxTaE1veVU4OUJQdWRvIiwiYXV0aCI6IloybDBiR0ZpSzJSbGNHeHZlUzEwYjJ0bGJpMHlORGc2WjJ4a2RDMUhRek0yWTNGTVUyaE5iM2xWT0RsQ1VIVmtidz09In19fQ==
```
The `.dockerconfigjson`-data is **base64** encrypted. In plain text it means the following:
```
{"auths":{"registry.gitlab.rlp.net/top/24s/secplay/microservices":{"username":"gitlab+deploy-token-248","password":"gldt-GC36cqLShMoyU89BPudo","auth":"Z2l0bGFiK2RlcGxveS10b2tlbi0yNDg6Z2xkdC1HQzM2Y3FMU2hNb3lVODlCUHVkbw=="}}}
```
We used this [base64 encoder/decoder](https://www.base64decode.org/).

> **Note:** These credentials are a Gitlab token and expire. You might have to create a new one. See [tokens](./gitlab-tokens.md).
 
## How to apply this Secret

There are three different ways:
1. via **Ansible**
2. applying **file** via CLI
3. **command** via CLI

### Ansible

This was our way to go.

1. We created a file `docker_registry_config.yaml`. You can find this file at `codebase/ansible/roles/microk8s/files/docker_registry_config.yaml`.

2. We copied the file to the target
```yaml
- name: Copy container registry secrets into target server
  ansible.builtin.copy:
    src: docker_registry_config.yaml
    dest: ~/docker_registry_config.yaml
```

3. We applied the Secret
```yaml
- name: Apply container registry secret
  ansible.builtin.shell:
    cmd: /snap/bin/kubectl apply -f ~/docker_registry_config.yaml
```

### File via CLI

1. Create the Secret file with the CLI of the Server which hosts your Kubernetes cluster

2. Apply the Secret

```bash
kubectl apply -f <secrets_filename>
```

### Command via CLI (imperative)

```bash
kubectl create secret docker-registry <secrets_name> --<registry_url> --docker-username=<username> --docker-password=<password>
```

in our case:

```bash
kubectl create secret docker-registry gitlab-rlp --docker-server=registry.gitlab.rlp.net/top/24s/secplay/microservices --docker-username=gitlab+deploy-token-248 --docker-password=gldt-GC36cqLShMoyU89BPudo
```

> **Note:** The authentication credentials for the container registry are gitlab tokens and expire at one point, so you have to renew the Kubernetes Secret and create new [Tokens](./gitlab-tokens.md).