FROM serversideup/ansible:8.7.0-bullseye-python3.12

RUN apt update && apt install -y vim

WORKDIR /app
COPY . /app/socle
RUN ansible-galaxy collection install -U community.general
RUN ansible-playbook -K socle/admin-tools/install-requirements.yaml
RUN echo 'export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH' >> ~/.bashrc
RUN echo 'alias k=kubectl' >> ~/.bashrc
