#!/bin/sh
kubectl delete configmap backup-s3.sh -n keycloak-system
kubectl create configmap backup-s3.sh --from-file=backup-s3.sh -n keycloak-system

