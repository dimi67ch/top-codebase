# Using TLS on Ingress

> **Note:** This setup has to be done manually and its **not** done by the playbook due to security reasons.

## Create Secret

We created a Kubernetes secret which contains the **certificate** and **public key** of our virtual machine.

```bash
kubectl create secret tls <name> --cert <path/to/cert> --key <path/to/public/key>
```

## Ingress.yaml

Then you have to reference this secret on your **ingress.yaml**. We did it like this on our `http-ingress.yaml` which you can find at `ansible/roles/microk8s/`.

```yaml
...
spec:
  tls:
    - hosts:
      - securityplayground.projekte.it.hs-worms.de
      secretName: secplay-ssl
  rules:
  - host: securityplayground.projekte.it.hs-worms.de
    http:
    ...
```

After that, you have to apply this configuration.

```bash
kubectl apply -f http-ingress.yaml
```
