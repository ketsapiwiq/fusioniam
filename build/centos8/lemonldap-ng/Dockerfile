ARG DEPEND
ARG VERSION

FROM $DEPEND:$VERSION

EXPOSE 8080

COPY ansible/ ./

RUN bash ./run-playbook.sh install.yaml &&\
    sed -i 's/80 /8080 /g' /etc/nginx/nginx.conf &&\
    rm -f install.yaml
