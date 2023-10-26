## Steps for create infrastructure

1. get hcloud_token

1. create directory and add kube.tf (fill hcloud_token) and check ssh_public_key and deploy

``` bash
cd mctl
terraform init --upgrade
terraform validate
```  

``` bash
terraform apply -auto-approve
```  



``` bash
terraform destroy -auto-approve
```    

``` bash
sudo ip addr add 116.202.7.239 dev eth0 # 116.202.7.239 - floating IP
```    

1. activate kube config

``` bash
export KUBECONFIG=./k3s_kubeconfig.yaml
cp k3s_kubeconfig.yaml ~/.kube/config_k3s
KUBECONFIG=~/.kube/config:~/.kube/config_k3s kubectl config view --flatten > ~/.kube/config
```    

1. deploy kubernetes dashboard and create user and role

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
kubectl apply -f ServiceAccount.yaml
kubectl apply -f ClusterRoleBinding.yaml
```

1. get user token

```bash
kubectl -n kubernetes-dashboard create token admin-user
```

1. install app by helm

```bash
export VERSION=8.3.1
export VALUES_FILE=values-$VERSION.yaml
helm upgrade --install camunda camunda/camunda-platform --version $VERSION -n camunda --create-namespace -f $VALUES_FILE
```

```bash
kubectl port-forward svc/camunda-zeebe-gateway 26500:26500 -n camunda
```
1. upgrade app by helm
```bash
export VERSION=8.3.1
export VALUES_FILE=values-$VERSION.yaml
export RELEASE_NAME=camunda

export TASKLIST_SECRET=$(kubectl get secret "camunda-tasklist-identity-secret" -o jsonpath="{.data.tasklist-secret}" -n $RELEASE_NAME | base64 -d)
export OPTIMIZE_SECRET=$(kubectl get secret "$RELEASE_NAME-optimize-identity-secret" -o jsonpath="{.data.optimize-secret}"   -n $RELEASE_NAME | base64 --decode)
export OPERATE_SECRET=$(kubectl get secret "$RELEASE_NAME-operate-identity-secret" -o jsonpath="{.data.operate-secret}"   -n $RELEASE_NAME | base64 --decode)
export CONNECTORS_SECRET=$(kubectl get secret "$RELEASE_NAME-connectors-identity-secret" -o jsonpath="{.data.connectors-secret}"   -n $RELEASE_NAME | base64 --decode)
export ZEEBE_SECRET=$(kubectl get secret "$RELEASE_NAME-zeebe-identity-secret" -o jsonpath="{.data.zeebe-secret}"   -n $RELEASE_NAME | base64 --decode)
export KEYCLOAK_ADMIN_SECRET=$(kubectl get secret "$RELEASE_NAME-keycloak" -o jsonpath="{.data.admin-password}"   -n $RELEASE_NAME | base64 --decode)
export KEYCLOAK_MANAGEMENT_SECRET=$(kubectl get secret "$RELEASE_NAME-keycloak" -o jsonpath="{.data.management-password}"   -n $RELEASE_NAME | base64 --decode)
export POSTGRESQL_SECRET=$(kubectl get secret "$RELEASE_NAME-postgresql" -o jsonpath="{.data.postgres-password}"   -n $RELEASE_NAME | base64 --decode)
export CONSOLE_SECRET=$(kubectl get secret --namespace $RELEASE_NAME "camunda-console-identity-secret" -o jsonpath="{.data.console-secret}" | base64 -d)

helm upgrade --install $RELEASE_NAME camunda/camunda-platform --version $VERSION   -n $RELEASE_NAME --create-namespace --set global.identity.auth.tasklist.existingSecret=$TASKLIST_SECRET,global.identity.auth.optimize.existingSecret=$OPTIMIZE_SECRET,global.identity.auth.operate.existingSecret=$OPERATE_SECRET,global.identity.auth.zeebe.existingSecret=$ZEEBE_SECRET,global.identity.auth.console.existingSecret=$CONSOLE_SECRET,global.identity.auth.connectors.existingSecret=$CONNECTORS_SECRET -f $VALUES_FILE
```

1 install cert-manager and ClusterIssuer
https://cert-manager.io/docs/installation/helm/

```bash
 kubect apply -f Issuers-staging.yaml
 ```

1 install argocd

```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm upgrade --install argocd argo/argo-cd --namespace argocd --create-namespace -f argocd-values.yaml
 ```

```bash
kubectl get secret argocd-initial-admin-secret  --template={{.data.password}}  -n argocd | base64 -d
```

```bash
kubectl port-forward service/argocd-server -n argocd 8080:443
argocd login localhost:8080 --username admin --password <password>
```
or 
```bash
kubectl apply -f argocd-IngressRoute.yaml
argocd login argocd.mctl.ru --username admin --password uzb5NsqQVEMOFjl3
```