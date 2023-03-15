# Gatekeeper

# Excluded Namespaces

Once you have installed the Operator, apply the policy-gatekeeper-config-exclude-namespaces.yaml to configure the namespaces where you do not want Gatekeeper to be handled. Check out the Exempting Namespaces from Gatekeeper README for more information.

List the namespaces that you want to exclude. View the following YAML example where several OpenShift and Open Cluster Management namespaces are excluded.

***objectDefinition***

```yaml
apiVersion: config.gatekeeper.sh/v1alpha1
kind: Config
metadata:
  name: config
  namespace: openshift-gatekeeper-system
spec:
  match:
    - excludedNamespaces:
        - hive
        - kube-system
        - kube-public
        - openshift-kube-apiserver
        - openshift-monitoring
        - open-cluster-management-agent
        - open-cluster-management
        - open-cluster-management-agent-addon
        - openshift-sdn
        - openshift-machine-config-operator
        - openshift-machine-api
        - openshift-ingress-operator
        - openshift-ingress
        - sdn-controller
        - openshift-cluster-csi-drivers
        - openshift-kube-controller-manager-operator
        - openshift-kube-controller-manager
      processes:
        - "*"

```

> ***Note***

* Dont execute the *operator-group.yaml* file.

* The solution is taken from the official redhat doc (check the PDF file), while adapting the version.

* At the CatalogSource, always pay attention to the image version, it must be compatible to the OpenShift cluster version. In my case I took this one *image: "registry.redhat.io/redhat/redhat-operator-index:v4.9*, since we're on a Openshit V4.9.

* At the subscription file, make sure to specify the most recent stable version, otherwise it will take the default one (not a smart move), in the file **operator-subscription.yaml** you'll find *startingCSV: gatekeeper-operator-product.v0.2.4*

* It took us 143 secondes to install the operator & create the instance.

* As a note, there is no official UI for Gatekeeper, but here is an unofficial one <https://github.com/sighupio/gatekeeper-policy-manager>.
