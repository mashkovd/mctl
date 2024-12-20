terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    helm = {
      source = "hashicorp/helm"
    }
  }
}


resource "helm_release" "vault-secrets-operator" {
  name             = "vault-secrets-operator"
  repository       = "https://helm.releases.hashicorp.com"
  chart            = "vault-secrets-operator"
  version          = "0.5.2"
  namespace        = "vault-secrets-operator-system"
  create_namespace = true
  wait             = true
  wait_for_jobs    = true
  #  values           = [
  #    file("${path.module}/helm-values/argocd.yaml")
  #  ]
}

resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "prometheus"
  version          = "25.19.1"
  namespace        = "prometheus"
  create_namespace = true
  wait             = false
  wait_for_jobs    = false

  #   values = [
  #     file("${path.module}/helm-values/prometheus.yaml")
  #   ]
}

resource "helm_release" "grafana" {
  name             = "grafana"
  repository       = "https://grafana.github.io/helm-charts"
  chart = "grafana"
  #   version          = "7.0.61"
  namespace        = "grafana"
  create_namespace = true
  wait             = true
  wait_for_jobs    = true

  values = [
    file("${path.module}/helm-values/grafana.yaml")
  ]
}
resource "helm_release" "mariadb" {
  name             = "mariadb"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "mariadb"
  version          = "18.0.2"
  namespace        = "mariadb"
  create_namespace = true
  wait             = true
  wait_for_jobs    = true
  set {
    name  = "persistence.size"
    value = "10Gi"
  }
  set {
    name  = "auth.rootPassword"
    value = "admin"
  }
    values = [
      file("${path.module}/helm-values/mariadb.yaml")
    ]
}

resource "helm_release" "nfs" {
  name             = "nfs"
  repository       = "https://kubernetes-sigs.github.io/nfs-ganesha-server-and-external-provisioner"
  chart            = "nfs-server-provisioner"
  version          = "1.8.0"
  namespace        = "nfs"
  create_namespace = true
  wait             = false
  wait_for_jobs    = false

  values = [
    #     file("${path.module}/helm-values/nfs.yaml")
  ]
}

# resource "helm_release" "erpnext" {
#   name             = "erpnext"
#   repository       = "https://helm.erpnext.com"
#   chart            = "erpnext"
#   version          = "7.0.61"
#   namespace        = "erpnext"
#   create_namespace = true
#   wait             = false
#   wait_for_jobs    = false
#
#   values = [
#     file("${path.module}/helm-values/erpnext.yaml")
#   ]
# }

# resource "helm_release" "kubernetes-dashboard" {
#  name             = "kubernetes-dashboard"
#  repository       = "https://kubernetes.github.io/dashboard"
#  chart            = "kubernetes-dashboard"
#  version          = "6.0.8"
#  namespace        = "kubernetes-dashboard"
#  create_namespace = true
#  wait             = false
#  wait_for_jobs    = false
#  values           = [
#    file("${path.module}/helm-values/kubernetes-dashboard.yaml")
#  ]
# }

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

#variable "camunda-appname" {
#  type    = string
#  default = "camunda"
#}
#
#
#data "external" "tasklist_secret" {
#  program = [
#    "bash", "-c",
#    "kubectl get secret --namespace camunda camunda-tasklist-identity-secret -o jsonpath='{.data.tasklist-secret}' | base64 -d | jq -n --arg value $(cat) '{value: $value}'"
#  ]
#}
#
#data "external" "optimize_secret" {
#  program = [
#    "bash", "-c",
#    "kubectl get secret --namespace camunda camunda-optimize-identity-secret -o jsonpath='{.data.optimize-secret}' | base64 -d | jq -n --arg value $(cat) '{value: $value}'"
#  ]
#}
#
#data "external" "operate_secret" {
#  program = [
#    "bash", "-c",
#    "kubectl get secret --namespace camunda camunda-operate-identity-secret -o jsonpath='{.data.operate-secret}' | base64 -d | jq -n --arg value $(cat) '{value: $value}'"
#  ]
#}
#
#data "external" "connectors_secret" {
#  program = [
#    "bash", "-c",
#    "kubectl get secret --namespace camunda camunda-connectors-identity-secret -o jsonpath='{.data.connectors-secret}' | base64 -d | jq -n --arg value $(cat) '{value: $value}'"
#  ]
#}
#
#data "external" "zeebe_secret" {
#  program = [
#    "bash", "-c",
#    "kubectl get secret --namespace camunda camunda-zeebe-identity-secret -o jsonpath='{.data.zeebe-secret}' | base64 -d | jq -n --arg value $(cat) '{value: $value}'"
#  ]
#}
#
#data "external" "keycloak_admin_secret" {
#  program = [
#    "bash", "-c",
#    "kubectl get secret --namespace camunda camunda-keycloak -o jsonpath='{.data.admin-password}' | base64 -d | jq -n --arg value $(cat) '{value: $value}'"
#  ]
#}
#
#data "external" "keycloak_management_secret" {
#  program = [
#    "bash", "-c",
#    "kubectl get secret --namespace camunda camunda-keycloak -o jsonpath='{.data.management-password}' | base64 -d | jq -n --arg value $(cat) '{value: $value}'"
#  ]
#}
#
#data "external" "postgresql_secret" {
#  program = [
#    "bash", "-c",
#    "kubectl get secret --namespace camunda camunda-postgresql -o jsonpath='{.data.postgres-password}' | base64 -d | jq -n --arg value $(cat) '{value: $value}'"
#  ]
#}
#
#data "external" "console_secret" {
#  program = [
#    "bash", "-c",
#    "kubectl get secret --namespace camunda camunda-console-identity-secret -o jsonpath='{.data.console-password}' | base64 -d | jq -n --arg value $(cat) '{value: $value}'"
#  ]
#}
#
#
#resource "helm_release" "camunda-platform" {
#  name             = var.camunda-appname
#  repository       = "https://helm.camunda.io/"
#  chart            = "camunda-platform"
#  version          = "8.3.1"
#  namespace        = "camunda"
#  create_namespace = true
#  wait             = false
#  wait_for_jobs    = false
#  values = [
#    "${file("cluster-bootstrap/helm-values/camunda-platform.yaml")}"
#  ]
#  set {
#    name = "global.identity.auth.tasklist.existingSecret"
#    #    value = data.external.tasklist_secret.result["value"]
#    value = data.external.tasklist_secret.result != null ? data.external.tasklist_secret.result["value"] : "tasklist_secret"
#
#  }
#  set {
#    name = "global.identity.auth.optimize.existingSecret"
#    #    value = data.external.optimize_secret.result["value"]
#    value = data.external.optimize_secret.result != null ? data.external.optimize_secret.result["value"] : "optimize_secret"
#  }
#  set {
#    name = "global.identity.auth.operate.existingSecret"
#    #    value = data.external.operate_secret.result["value"]
#    value = data.external.operate_secret.result != null ? data.external.operate_secret.result["value"] : "operate_secret"
#  }
#  set {
#    name = "global.identity.auth.connectors.existingSecret"
#    #    value = data.external.connectors_secret.result["value"]
#    value = data.external.connectors_secret.result != null ? data.external.connectors_secret.result["value"] : "connectors_secret"
#  }
#  set {
#    name = "global.identity.auth.zeebe.existingSecret"
#    #    value = data.external.zeebe_secret.result["value"]
#    value = data.external.zeebe_secret.result != null ? data.external.zeebe_secret.result["value"] : "zeebe_secret"
#  }
#  set {
#    name = "identity.keycloak.auth.adminPassword"
#    #    value = data.external.keycloak_admin_secret.result["value"]
#    value = data.external.keycloak_admin_secret.result != null ? data.external.keycloak_admin_secret.result["value"] : "keycloak_admin_secret"
#  }
#  #  set {
#  #    name  = "identity.keycloak.auth.managementPassword"
#  #    value = data.external.keycloak_management_secret.result["value"]
#  #  }
#  set {
#    name = "identity.keycloak.postgresql.auth.password"
#    #    value = data.external.postgresql_secret.result["value"]
#    value = data.external.postgresql_secret.result != null ? data.external.postgresql_secret.result["value"] : "postgresql_secret"
#  }
#  set {
#    name = "global.identity.auth.console.existingSecret"
#    #    value = data.external.console_secret.result["value"]
#    value = data.external.console_secret.result != null ? data.external.console_secret.result["value"] : "console_secret"
#  }
#}
#
#
#terraform {
#  required_version = ">= 1.3.3"
#  required_providers {
#    kubernetes = {
#      source  = "hashicorp/kubernetes"
#      version = ">= 2.16"
#    }
#    helm = {
#      source  = "hashicorp/helm"
#      version = ">= 2.9.0"
#    }
#    argocd = {
#      source  = "oboukili/argocd"
#      version = ">= 6.0.3"
#    }
#  }
#}
#
#
#
#resource "argocd_application" "root-app" {
#  metadata {
#    name      = "root-app"
#    namespace = "argocd"
#  }
#
#  spec {
#    project = "default"
#    source {
#      path     = "apps"
#      repo_url = "https://github.com/mashkovd/argocdApps.git"
#    }
#    destination {
#      server    = "https://kubernetes.default.svc"
#      namespace = "argocd"
#    }
#  }
#}