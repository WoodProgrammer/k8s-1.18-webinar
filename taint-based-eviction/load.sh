#!/bin/bash


$ kubectl exec -it example-pod sh

$ apt-get update && apt-get install -y stress
$ stress --vm 1 --vm-bytes 100M --vm-hang 3000 -t 3600

$ kubectl get nodes -o jsonpath='{range .items[*]}{@.metadata.name}{"\n"}{range @.status.conditions[*]}{@.type}={@.status}{"\n"}{end}{end}'|grep True

## evicted podlari silmek icin

$ kubectl get po |grep -i evicted|awk '{ print $1}'  |xargs kubectl delete po

