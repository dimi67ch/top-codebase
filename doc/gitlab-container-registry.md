# Gitlab Container Registry

The Gitlab container registry in the `microservices` project is used to upload every **Docker image** into it so **Kubernetes** can use these images to **pull and deploy** the customized docker images onto the kubernetes cluster.
## Upload Docker images to the registry
### Automatically via the pipeline
See [microservices pipeline](https://gitlab.rlp.net/groups/top/24s/secplay/-/wikis/Pipelines#microservices-pipeline)
### Manually
1. Login in the container registry
```bash
docker login -u "$CI_REGISTRY_USER" -p "$CI_REGISTRY_PASSWORD" "$CI_REGISTRY"
```
2. build image
```bash
docker build -t "$CI_REGISTRY/$CI_PROJECT_NAMESPACE/$CI_PROJECT_NAME/<image_name>" "/path/to/directory"
```
3. Push image to the container registry `
```bash
docker push "$CI_REGISTRY/$CI_PROJECT_NAMESPACE/$CI_PROJECT_NAME/<image_name>"
```
> Note: You see that we use **Gitlab Tokens** to authenticate to the registry as the registry is private.
See [Tokens]()

> Note: When Kubernetes tries to pull a Docker image from the container registry, Kubernetes has to authenticate to the container registry. Therefore we created a **Kubernetes Secret** resource. See [Secret]()



