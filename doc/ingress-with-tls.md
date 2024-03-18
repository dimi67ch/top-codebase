# Using Ingress with TLS

This is a guide to create a Kubernetes **ingress** resource that allows our project website to be reachable from outside the cluster at **port 80**. That ingress is encrypted with TLS.

> **Note:** The **TLS** setup has to be done manually and its **not** done by the playbook due to security reasons.

## Create Secret (manually)

We created a Kubernetes secret which contains the **certificate** and **public key** of our virtual machine.

```bash
kubectl create secret tls <name> --cert <path/to/cert> --key <path/to/public/key>
```

After that, you have to apply this configuration.

```bash
kubectl apply -f http-ingress.yaml
```

## Ingress.yaml

This work ist done by the playbook.

It creates a `ingress.yaml` and references the before mentioned secret on it. We did it like this on our `http-ingress.yaml` which you can find at `ansible/roles/microk8s/files/http-ingress.yaml`.

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: http-ingress
spec:
  tls: # TLS config
    - hosts:
      - securityplayground.projekte.it.hs-worms.de
      secretName: secplay-ssl
  rules:
  - host: securityplayground.projekte.it.hs-worms.de
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: secplay-website
            port:
              number: 80
```
