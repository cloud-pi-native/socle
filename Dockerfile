FROM debian:11-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
  python3 \
  python3-pip \
  age \
  wget && \
  rm -rf /var/lib/apt/lists/*

RUN pip3 install ansible pyyaml kubernetes python-gitlab
RUN ansible-galaxy collection install community.general kubernetes.core --force

RUN wget -c https://get.helm.sh/helm-v3.13.0-linux-amd64.tar.gz -O - | \
  tar -xz linux-amd64/helm && \
  mv /linux-amd64/helm /usr/local/bin/ && \
  rm -rf /linux-amd64/

RUN chmod 555 /usr/local/bin/helm
RUN mkdir playbooks /root/.kube

WORKDIR /playbooks