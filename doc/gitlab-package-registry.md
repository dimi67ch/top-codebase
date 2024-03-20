# Gitlab Package Registry

The Gitlab package registry (e.g. in the `microservices` project) is used to upload every **Helm chart package** into it so **ansible** can use these packages to install the customized helm charts onto the **Kubernetes** cluster.

## Upload Helm packages to the registry

You can upload them either [automatically via the pipeline](./gitlab-package-registry.md#automatically-via-the-pipeline) or [manually](./gitlab-package-registry.md#manually).

### Automatically via the pipeline

See [microservices pipeline](./pipelines.md#microservices-pipeline).

### Manually

1. Install [Helm](https://helm.sh/docs/intro/install/)

2. Install required Helm plugin

   ```bash
   helm plugin install https://github.com/chartmuseum/helm-push
   ```

3. Add our package registry as repository

   ```bash
   helm repo add gitlab-rlp "$CI_API_V4_URL/projects/$CI_PROJECT_ID/packages/helm/stable" --username gitlab-ci-token --password $CI_JOB_TOKEN 
   ```

4. Package chart

   ```bash
   helm package "/path/to/chart" --destination "/path/to/chart/package"
   ```

5. Push chart to the package registry

   ```bash
   helm cm-push "path/to/chart/package/<chartFileName>" --username gitlab-ci-token --password $CI_JOB_TOKEN "$CI_API_V4_URL/projects/$CI_PROJECT_ID/packages/helm/stable"
   ```

> Note: You see that we use **Gitlab Tokens** to authenticate to the registry as the registry is private.
See [Tokens](./gitlab-tokens.md).