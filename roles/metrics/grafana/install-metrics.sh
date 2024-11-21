#!/bin/bash

echo "Install operator group and subscription"
kubectl apply -f operator-group.yaml
kubectl apply -f 1-subscription.yaml

oc project openshift-monitoring
oc get secret prometheus-k8s-htpasswd -o jsonpath='{.data.auth}' | base64 -d > /tmp/htpasswd-tmp
echo "" >> /tmp/htpasswd-tmp
htpasswd -s -b /tmp/htpasswd-tmp grafana-user mysupersecretpasswd
oc patch secret prometheus-k8s-htpasswd -p "{\"data\":{\"auth\":\"$(base64 -w0 /tmp/htpasswd-tmp)\"}}"
oc delete pods -l app=prometheus
sleep 5
oc get pods -l app=prometheus -o name

echo "wait for $WAITING_TIME_AFTER_OPERATOR seconds"
sleep $WAITING_TIME_AFTER_OPERATOR

OPERATOR_READY=1

while [ $OPERATOR_READY == 1 ];
do
	kubectl get grafana
	if [ $? == 0 ]; then
		echo " install datasource and grafana instance"
		kubectl apply -f datasource.yaml
		kubectl apply -f grafana-instance.yaml
		OPERATOR_READY=0
	else
		sleep 5
	fi
done
