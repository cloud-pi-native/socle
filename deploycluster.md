```
docker run -it -v ${PWD}/clusters/sdid:/config -e KUBECONFIG=/config/config.yaml --rm rg.fr-par.scw.cloud/service-team/ansible-socle bash

docker run -it -v ${PWD}:/app -v ${PWD}/clusters/sdid:/config -e KUBECONFIG=/config/config.yaml --rm rg.fr-par.scw.cloud/service-team/ansible-socle bash

ansible-playbook install.yaml
k apply -f /config/dso.yaml
ansible-playbook install.yaml

```