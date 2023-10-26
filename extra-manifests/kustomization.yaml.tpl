apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

namespace: argocd
resources:
- https://raw.githubusercontent.com/argoproj/argo-cd/v2.7.2/manifests/install.yaml


resources:
  - letsencrypt-staging.yaml
  - letsencrypt-prod.yaml
  - dashboard.yaml
  - admin-user.yaml
