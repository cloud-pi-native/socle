```
docker run -it -v ${PWD}/sdid:/config -e KUBECONFIG=/config/kubeconfig-sdid.yaml --rm rg.fr-par.scw.cloud/service-team/ansible-socle bash

ansible-playbook install.yaml
k apply -f /config/dso.yaml
ansible-playbook install.yaml
```