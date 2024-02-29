# GitLab Tokens

Used for accessing the container and package registry.

In our project, it is used by the ansible playbook, which deploys the Helm charts into the Kubernetes cluster.

In **Ansible**:
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

## Local Mirror of Codebase Repository

The local mirror of the codebase repository is located at https://gitlab.ai.it.hs-worms.de/top24/codebase-local.
It is an exact copy of the [codebase](https://gitlab.rlp.net/top/24s/secplay/codebase) repository and is used for the CI/CD pipeline, because the codebase repository is located at gitlab.rlp.net and the CI/CD pipeline can only be run over gitlab.ai.it.hs-worms.de.

The repository located at gitlab.rlp.net pushes the changes to the local mirror repository at gitlab.ai.it.hs-worms.de and the CI/CD pipeline is triggered by the changes in the local mirror repository.
It authenticates via a access token, which is created in the project settings of the local mirror repository.

The CI/CD Pipeline checks for the repository name. If the repository name is `codebase-local`, it runs all the stages of the pipeline. If the repository name is `codebase`, it only runs the `lint` stage and skips the `deployment` stage.

The current token for the local mirror repository will expire by the end of march. To create a new token, follow the steps below.

### How to create a token for the local mirror repository

1. Go to the project settings of the local mirror repository
2. Go to `Access Tokens`
3. Create a new token with the `read_repository` and `write_repository` scope or `api` scope
4. Copy the token
5. Go to the project settings of the codebase repository located at gitlab.rlp.net
6. Go to `Repository` -> `Mirroring repositories`
7. Add the local mirror repository URL and paste the token as the password
8. Click on `Mirror repository`
9. Select Mirror direction as `Push`
10. The repository is now mirrored


