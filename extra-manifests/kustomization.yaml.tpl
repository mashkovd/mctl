apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - letsencrypt-staging.yaml
  - letsencrypt-prod.yaml
  - dashboard.yaml
  - argocd.yaml


