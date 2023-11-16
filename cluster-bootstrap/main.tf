resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "5.49.0"
  namespace        = "argocd"
  create_namespace = true
  wait             = false
  wait_for_jobs    = false
  values           = [
    "${file("cluster-bootstrap/helm-values/argocd.yaml")}"
  ]
}

resource "helm_release" "kubernetes-dashboard" {
  name             = "kubernetes-dashboard"
  repository       = "https://kubernetes.github.io/dashboard"
  chart            = "kubernetes-dashboard"
  version          = "6.0.8"
  namespace        = "kubernetes-dashboard"
  create_namespace = true
  wait             = false
  wait_for_jobs    = false
  values           = [
    "${file("cluster-bootstrap/helm-values/kubernetes-dashboard.yaml")}"
  ]
}

#resource "helm_release" "gitlab" {
#  name             = "gitlab"
#  repository       = "https://charts.gitlab.io/"
#  chart            = "gitlab"
#  version          = "7.1.2"
#  namespace        = "gitlab"
#  create_namespace = true
#  wait             = true
#  wait_for_jobs    = false
#  values           = [
#    "${file("cluster-bootstrap/helm-values/gitlab.yaml")}"
#  ]
#}

variable "camunda-appname" {
  type    = string
  default = "camunda"
}
resource "helm_release" "camunda-platform" {
  name             = var.camunda-appname
  repository       = "https://helm.camunda.io/"
  chart            = "camunda-platform"
  version          = "8.3.1"
  namespace        = "camunda"
  create_namespace = true
  wait             = false
  wait_for_jobs    = false
  values           = [
    "${file("cluster-bootstrap/helm-values/camunda-platform.yaml")}"
  ]
  set {
    name  = "global.identity.auth.tasklist.existingSecret"
    value = "${var.camunda-appname}-tasklist-identity-secret"
  }
  set {
    name  = "global.identity.auth.optimize.existingSecret"
    value = "${var.camunda-appname}-optimize-identity-secret"
  }
  set {
    name  = "global.identity.auth.operate.existingSecret"
    value = "${var.camunda-appname}-operate-identity-secret"
  }
  set {
    name  = "global.identity.auth.zeebe.existingSecret"
    value = "${var.camunda-appname}-zeebe-identity-secret"
  }
  set {
    name  = "global.identity.auth.console.existingSecret"
    value = "${var.camunda-appname}-console-identity-secret"
  }
  set {
    name  = "global.identity.auth.connectors.existingSecret"
    value = "${var.camunda-appname}-connectors-identity-secret"
  }
}


terraform {
  required_version = ">= 1.3.3"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.16"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.9.0"
    }
  }
}