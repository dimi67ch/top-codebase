# GitLab Tokens

Used for accessing the container- and package registry.

In our project, it is used by the ansible playbook, which deploys the Helm charts into the Kubernetes cluster.

In Ansible:
```yaml
repositories:
  - repo_name: "gitlab-rlp"
    repo_url: "https://gitlab.rlp.net/api/v4/projects/39843/packages/helm/stable"
    repo_username: "gitlab+deploy-token-247"
    repo_password: "gldt-G4NVnsZx8yx56MpXRvsC"
container_registry_url: registry.gitlab.rlp.net/top/24s/secplay/microservices
container_registry_username: gitlab+deploy-token-248
container_registry_password: gldt-GC36cqLShMoyU89BPudo
```

## How to get the token

1. Go to the project settings
2. Go to `Repository` -> `Deploy Tokens`
3. Create a new token with the `read_registry` and `read_package_registry` scope
4. Copy the token and use it in the ansible playbook

