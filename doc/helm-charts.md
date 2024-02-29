# How to create Helm CHarts

## Structure
For creating a Helm chart you always require:
- a `Chart.yaml`
- a `values.yaml`
- a `templates` directory which contains:
    - your **Kubernetes resources**

For example we created a first Helm chart for the first version of our project website. The Stucture looks like this:
```bash
secplay-website
  |_Chart.yaml
  |_values.yaml
  |_templates
    |_secplayweb-svc.yaml  # Kubernetes Service
    |_secplayweb-dpl.yaml  # Kubernetes Deployment
    |_secplayweb-ingress.yaml  # Kubernetes Ingress
```

### Chart.yaml
This file contains the **metadata** of the Helm chart\
e.g. our website:
```yaml
apiVersion: v2
appVersion: 1.0.0
description: A Helm chart for deploying the Website on Kubernetes
name: secplay-website
type: application
version: 1.0.0
```

### values.yaml
This file contains the **values** of the Kubernetes resources of your application. You can outsource them from these files into this to have them more clearer.\
e.g. our website
```yaml
secplayWebsite:
  image:
    repository: registry.gitlab.rlp.net/top/24s/secplay/microservices project-homepage_api # image url (container registry) 
    pullPolicy: IfNotPresent
    pullSecret: gitlab-rlp
  ports:
    containerPort: 80
  service:
    type: LoadBalancer
    port: 80
    targetPort: 80
    protocol: TCP
```

### Templates Files

- **secplayweb-svc.yaml**
  ```yaml
    apiVersion: v1
    kind: Service
    metadata:
    name: secplay-website
    labels:
        app: secplay-website
    spec:
    type: {{ .Values.secplayWebsite.service.type }}
    ports:
        - port: {{ .Values.secplayWebsite.service.port }}
        targetPort: {{ .Values.secplayWebsite.service.targetPort }}
        protocol: {{ .Values.secplayWebsite.service.protocol }}
        name: secplay-website
    selector:
        app: secplay-website
  ```
  > **Note:** You can see that the actual values reference the entries in the **values.yaml** file
- **secplayweb-dpl.yaml**
  ```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
    name: secplay-website
    labels:
        app: secplay-website
    spec:
    selector:
        matchLabels:
        app: secplay-website
    template:
        metadata:
        labels:
            app: secplay-website
        spec:
        imagePullSecrets:
            - name: {{ .Values.secplayWebsite.image.pullSecret }}
        containers:
            - name: secplay-website
            image: {{ .Values.secplayWebsite.image.repository }}
            imagePullPolicy: {{ .Values.secplayWebsite.image.pullPolicy }}
            ports:
                - name: secplay-website
                containerPort: {{ .Values.secplayWebsite.ports.containerPort }}
  ```
- **secplayweb-ingress.yaml**
  ```yaml
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: http-ingress
    spec:
      rules:
      - http:
          paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: secplay-website
                port:
                  number: 80
  ```
  > **Note:** This ingress resource allows the website to be reachable from outside the cluster at port 80

## Package the Chart
See [chapter package registry](./gitlab-package-registry.md).

## Install the Chart