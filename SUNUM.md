## Dry-Run

Server tarafinda objeleri onceden kontrol etmenizi saglar.

### Server tarafinda kontrol

kubectl delete --dry-run=server -f deployment.yaml
Error from server (NotFound): error when deleting "deployment.yaml": deployments.apps "nginx-deployment-2" not found

### Client tarafinda kontrol
kubectl delete --dry-run=client -f deployment.yaml
deployment.apps "nginx-deployment-2" deleted (dry run)


