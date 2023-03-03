# "mw-demo3"

## Description
"Sample"

## Layout
[apps](apps): Directories containing a `config.yaml` that are used to deploy applications to child Kubernetes clusters. The `config.yaml` file will contain a path to a directory in this repo that contains Kubernetes manifests for applications.

[infrastructure](infrastructure): Directories containing a `config.yaml` that are used to deploy infrastructure. This folder is used by the parent ArgoCD instance. The `config.yaml` file will contain a path to a directory in this repo that contains Kubernetes manifests for infrastructure.
