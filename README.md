# KUBERNETES 1.18 Yenilikler

## Dry-Run

Server tarafinda objeleri onceden kontrol etmenizi saglar.

### Server tarafinda kontrol

kubectl delete --dry-run=server -f deployment.yaml
Error from server (NotFound): error when deleting "deployment.yaml": deployments.apps "nginx-deployment-2" not found

### Client tarafinda kontrol
kubectl delete --dry-run=client -f deployment.yaml
deployment.apps "nginx-deployment-2" deleted (dry run)

<hr></hr>

## Taint Based Eviction

Kubernetes memory ve cpu usage'a gore hehangi bir kaynagin pressure yaratmasi durumunda node'u taintlemektedir.

###Kubernetes 1.13'den sonra asagidaki feature-gate opsiyonlari asagidaki gibi set edilmesi gerekiyor.

* ApiServer: TaintNodesByCondition=true
* ControllerManager: TaintNodesByCondition=true
* Scheduler: TaintNodesByCondition=true

<br>Notice:</br> Kubernetes 1.18'de ise --enable-taint-manager sayesinde default hale gelmis durumda.
Pressure Olusturmak icin Worker Node uzerinde ornek bir yuk olusturacak ve memorypressure yaratacak pod uzerinden deployment yaptiginizda bir eviction yaratacak ve node ilgili duruma taintlenecek.

```sh

$ kubectl exec -it example-pod sh

$ apt-get update && apt-get install -y stress
$ stress --vm 1 --vm-bytes 100M --vm-hang 3000 -t 3600

```
Evict olan podlari silmeniz icin :smile: => ```kubectl get po |grep -i evicted|awk '{ print $1}'  |xargs kubectl delete po```

Memory Pressure seklinde taintlendigini gormeniz icin asagidaki komutu calistirabilirsiniz : 

```
$ kubectl get nodes -o jsonpath='{range .items[*]}{@.metadata.name}{"\n"}{range @.status.conditions[*]}{@.type}={@.status}{"\n"}{end}{end}'|grep True

```

## Kubectl Diff

Uygulanmadan onceki manifest dosyasi ve akabinde cluster uzerinde konumlanmis olan obje arasindaki farklari gostermektedir.


meld ya diff gibi linux uzerindeki programlar ile farklari bulmaktadir `KUBECTL_EXTERNAL_DIFF` degiskenine bakmaktadir.

## IMMUTABLE SECRETS

Kubernetes 1.18'de artik secretlara immutable eklentisi yaparak degistirilemez olmalarini sagliyoruz. Burada secretlarin takip edilemez sekilde update edilmesini, en update olmasi gerekmeyen degerler icin koruma altina almamizi sagliyor.

Bu ozellik icinde kube-apiserver ve kube-controller-manager uzerinde su feature gateleri acmaniz gerekmektedir.

```
kube-apiserver.yaml:    - --feature-gates=ImmutableEphemeralVolumes=true
kube-controller-manager.yaml:    - --feature-gates=ImmutableEphemeralVolumes=true
```

