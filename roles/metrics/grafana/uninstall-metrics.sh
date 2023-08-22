#!/bin/bash


echo "Uninstall operator group and subscription"
kubectl delete -f operator-group.yaml
kubectl delete -f 1-subscription.yaml
kubectl delete -f datasource.yaml
kubectl delete -f grafana-instance.yaml

