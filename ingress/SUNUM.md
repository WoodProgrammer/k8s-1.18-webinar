## Ingress V1 Guncelleme

PathType ve ClassName eklendi `kubernetes.io/ingress.class` anotasyonu  artik kullanilmiyor ve ingress class ismi de resource icerisine eklendi.

```sh

$ kubectl get ingress
NAME           CLASS   HOSTS   ADDRESS   PORTS   AGE
test-ingress   nginx   *                 80      4m17s
```
## IngresClass

Declarative tanimlama ile artik hangi controller hangi ingress class'a atanmis bunu belirtebilecegiz su sekilde :

```

apiVersion: networking.k8s.io/v1beta1
kind: IngressClass
metadata:
  name: external-lb
spec:
  controller: example.com/ingress-controller
  parameters:
    apiGroup: k8s.example.com/v1alpha
    kind: IngressParameters
    name: external-lb
```

