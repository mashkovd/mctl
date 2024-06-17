# resource "helm_release" "argocd" {
#   name             = "argocd"
#   repository       = "https://argoproj.github.io/argo-helm"
#   chart            = "argo-cd"
#   version          = "5.49.0"
#   namespace        = "argocd"
#   create_namespace = true
#   wait             = true
#   wait_for_jobs    = true
#   values           = [
#     file("${path.module}/helm-values/argocd.yaml"),
#   ]
#   set {
#     name  = "configs.credentialTemplates.https-creds.password"
#     value = var.argo_cd_private_key
#   }
# }
#
# variable "argo_cd_private_key" {
#   description = "Private key for Argo CD"
#   sensitive   = true
#   type        = string
# }