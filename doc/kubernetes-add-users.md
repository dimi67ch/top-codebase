# Kubernetes Add Users

This document describes how to configure local kubeconfig files for users to access a Kubernetes cluster.

## Prerequisites

### Install kubectl

- Windows
    ```
    choco install kubernetes-cli
    ```
- MacOS
    ```
    brew install kubernetes-cli
    ```
- Linux
  - Ubuntu
    ```
    sudo snap install kubectl --classic
    ```
  - Debian
    ```
    sudo apt install kubernetes-client
    ```
  - Fedora
    ```
    sudo dnf install kubernetes-client
    ```

## Steps

1. Create credentials for the cluster.

    ```
    kubectl config set-credentials <username> --client-key=<username>.key --client-certificate=<username>.crt --embed-certs=true
    ```

    Replace `<username>` with the appropriate values.

2. Set the cluster configuration.

    ```
    kubectl config set-cluster <cluster-name> --server=<server-url>:16443 --certificate-authority=<ca.crt> --embed-certs
    ```

    Replace `<cluster-name>`, `<server-url>`, and `<ca.crt>` with the appropriate values.

3. Set the context.

    ```
    kubectl config set-context <context-name> --cluster=<cluster-name> --user=<username>
    ```

    Replace `<context-name>` and `<cluster-name>` with the appropriate values.

4. Set the context as default.

    ```
    kubectl config set current-context <context-name>
    ```

    Replace `<context-name>` with the appropriate value.