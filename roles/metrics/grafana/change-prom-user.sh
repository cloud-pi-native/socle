#!/bin/bash
# NEED : yum install -f httpd-tools
oc project openshift-monitoring
oc get secret prometheus-k8s-htpasswd -o jsonpath='{.data.auth}' | base64 -d > /tmp/htpasswd-tmp
echo "" >> /tmp/htpasswd-tmp
htpasswd -s -b /tmp/htpasswd-tmp grafana-user mysupersecretpasswd
oc patch secret prometheus-k8s-htpasswd -p "{\"data\":{\"auth\":\"$(base64 -w0 /tmp/htpasswd-tmp)\"}}"
oc delete pods -l app=prometheus
sleep 5
oc get pods -l app=prometheus -o name
