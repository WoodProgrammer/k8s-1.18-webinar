# NodeDNS Cache Local

Kubernetes ortaminda her zaman uygulamalar cluster icindeki bir adrese degil onun disina da cikabilir.
Bu tarz durumlarda kubernetes tarafinda her adres icin coredns'e sormaya ve onunda yine ilk olarak bulamadigi kayit icin node'a gitmesi beklenmektedir.

Burada coredns'e giderken herzaman bir iptables kurallari soz konusu bu DNAT kurallari her zaman bize disariya giderken bir latency olusturmakta.

Bu sorunu asabilmek icinde node uzerinde bu tarz adresleri icin, node'un dns cache'i uzerinden gidilmesi gerektiginden bahsetmektedir.

Direkt K8S dokumanlarindan aldigim bu YAML'i implemente edip daemonset olarak her node uzerinde konumlandiriyorum.

Ancak burada direkt olarak bir helmchart ile kendisinin herseyi configure edildigi bir paket henuz maalesef yok bazi guncellemeler yapmamiz gerekebilir.


## Konfigurasyon

Ilk olarak baktigimizda bazi parametreleri bizim vermemiz gerekiyor;

```

$ KUBEDNS=kubectl get svc kube-dns -n kube-system -o jsonpath={.spec.clusterIP}
$ wget https://github.com/kubernetes/kubernetes/blob/master/cluster/addons/dns/nodelocaldns/nodelocaldns.yaml -O nodelocaldns.yaml
$ sed -i -e "s/__PILLAR__DNS__DOMAIN__/${KUBE_DNS_NAME:-cluster.local}/g" nodelocaldns.yaml
$ sed -i -e "s/__PILLAR__DNS__SERVER__/${KUBE_DNS_SERVER_IP:-$KUBEDNS}/g" nodelocaldns.yaml
$ sed -i -e "s/__PILLAR__LOCAL__DNS__/${KUBE_LOCAL_DNS_IP:-169.254.20.10}/g" nodelocaldns.yaml

```

Bu configlerin ardindan nodelocaldns.yaml 'i apply edip daemonset olarak kurabiliyoruz artik her node uzerinde 169.254.20.10 dummy ip uzerinden dns sorgularina cevap verecek ve `miss` sorgulari da coredns tarafina yonlendirecek bir routing islemi kurguluyoruz.

## KUBELET Konfigurasyonu

Cluster icerisindeki podlarin nodelocal cache'e direkt gidebilmesi ve coredns DNAT kurallarindan en azindan cache'e giderken kacinmasi icin su sekilde bir kubelette parametre gecebiliriz:

Kuruluma bagli olarak `/var/lib/kubelet` altinda config.yaml'daki ClusterDNS degerini 169'lu verdigimiz adrese cekebiliriz.

``
apiVersion: kubelet.config.k8s.io/v1beta1
...
..
..
clusterDNS:
- 169.254.20.10
``
