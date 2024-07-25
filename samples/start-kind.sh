#!/bin/sh
set -o errexit

CURRENT_DIR=$(pwd)

# 0. Create ca
mkcert -install
cd /tmp
mkcert "127.0.0.1.nip.io" "*.127.0.0.1.nip.io"
cd $CURRENT_DIR

# 1. Create registry container unless it already exists
reg_name='kind-registry'
reg_port='5001'
if [ "$(docker inspect -f '{{.State.Running}}' "${reg_name}" 2>/dev/null || true)" != 'true' ]; then
	docker run \
		-d --restart=always -p "127.0.0.1:${reg_port}:5000" --network bridge --name "${reg_name}" \
		registry:2
fi

# 2. Create kind cluster with containerd registry config dir enabled
# TODO: kind will eventually enable this by default and this patch will
# be unnecessary.
#
# See:
# https://github.com/kubernetes-sigs/kind/issues/2875
# https://github.com/containerd/containerd/blob/main/docs/cri/config.md#registry-configuration
# See: https://github.com/containerd/containerd/blob/main/docs/hosts.md
cat <<EOF | kind create cluster --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
containerdConfigPatches:
- |-
  [plugins."io.containerd.grpc.v1.cri".registry]
    config_path = "/etc/containerd/certs.d"
nodes:
- role: control-plane
  image: kindest/node:v1.27.3
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
  extraMounts:
    - containerPath: /usr/local/share/ca-certificates/mkcert.crt
      hostPath: $HOME/.local/share/mkcert/rootCA.pem
- role: worker
  image: kindest/node:v1.27.3
  extraMounts:
    - containerPath: /usr/local/share/ca-certificates/mkcert.crt
      hostPath: $HOME/.local/share/mkcert/rootCA.pem
- role: worker
  image: kindest/node:v1.27.3
  extraMounts:
    - containerPath: /usr/local/share/ca-certificates/mkcert.crt
      hostPath: $HOME/.local/share/mkcert/rootCA.pem
- role: worker
  image: kindest/node:v1.27.3
  extraMounts:
    - containerPath: /usr/local/share/ca-certificates/mkcert.crt
      hostPath: $HOME/.local/share/mkcert/rootCA.pem
EOF

# 3. Add the registry config to the nodes
#
# This is necessary because localhost resolves to loopback addresses that are
# network-namespace local.
# In other words: localhost in the container is not localhost on the host.
#
# We want a consistent name that works from both ends, so we tell containerd to
# alias localhost:${reg_port} to the registry container when pulling images
REGISTRY_DIR="/etc/containerd/certs.d/localhost:${reg_port}"
for node in $(kind get nodes); do
	docker exec "${node}" mkdir -p "${REGISTRY_DIR}"
	cat <<EOF | docker exec -i "${node}" cp /dev/stdin "${REGISTRY_DIR}/hosts.toml"
[host."http://${reg_name}:5000"]
EOF
done

# 4. Connect the registry to the cluster network if not already connected
# This allows kind to bootstrap the network but ensures they're on the same network
if [ "$(docker inspect -f='{{json .NetworkSettings.Networks.kind}}' "${reg_name}")" = 'null' ]; then
	docker network connect "kind" "${reg_name}"
fi

# 5. Document the local registry
# https://github.com/kubernetes/enhancements/tree/master/keps/sig-cluster-lifecycle/generic/1755-communicating-a-local-registry
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: local-registry-hosting
  namespace: kube-public
data:
  localRegistryHosting.v1: |
    host: "localhost:${reg_port}"
    help: "https://kind.sigs.k8s.io/docs/user/local-registry/"
EOF

for i in kind-control-plane kind-worker kind-worker2 kind-worker3; do
	docker exec -it $i update-ca-certificates
done

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
kubectl -n ingress-nginx create secret tls mkcert --key /tmp/127.0.0.1.nip.io+1-key.pem --cert /tmp/127.0.0.1.nip.io+1.pem
kubectl -n ingress-nginx patch deployments.apps ingress-nginx-controller --type 'json' -p '[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value":"--default-ssl-certificate=ingress-nginx/mkcert"}]'

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: coredns
  namespace: kube-system
data:
  Corefile: |
    .:53 {
        errors
        health {
           lameduck 5s
        }
        ready
        kubernetes cluster.local in-addr.arpa ip6.arpa {
           pods insecure
           fallthrough in-addr.arpa ip6.arpa
           ttl 30
        }
        prometheus :9153
        forward . /etc/resolv.conf {
           max_concurrent 1000
        }
        rewrite stop {
           name regex (.*).127.0.0.1.nip.io ingress-nginx-controller.ingress-nginx.svc.cluster.local answer auto
        }
        cache 30
        loop
        reload
        loadbalance
    }
EOF

kubectl -n kube-system rollout restart deployments/coredns

sleep 30

kubectl -n ingress-nginx wait --for=condition=Available deployment/ingress-nginx-controller --timeout=300s
kubectl create ns dso-vault
kubectl -n dso-vault create configmap mkcert --from-file=ca.pem=${HOME}/.local/share/mkcert/rootCA.pem
kubectl -n ingress-nginx create configmap mkcert --from-file=ca.pem=${HOME}/.local/share/mkcert/rootCA.pem
