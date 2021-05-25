FROM docker.io/library/centos:8  

LABEL app=fusioniam

COPY run.sh /

RUN bash /run.sh ;\
    chmod g=u /etc/passwd /etc/group

COPY run-playbook.sh ./

COPY ansible/ ./

RUN bash ./run-playbook.sh ./install.yaml

COPY run-ct.sh /

ENTRYPOINT bash /run-ct.sh
