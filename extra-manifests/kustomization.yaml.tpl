apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - letsencrypt-prod.yaml
  - letsencrypt-staging.yaml
