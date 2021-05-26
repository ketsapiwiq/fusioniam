ARG DEPEND
ARG VERSION

FROM $DEPEND:$VERSION

EXPOSE 33389

COPY ansible/ ./

RUN bash ./run-playbook.sh install.yaml &&\
    LDAPGROUP=$(grep ldap /etc/group) ;\
    sed -i 's/fusion.*//g' /etc/group ;\
    sed -i 's/fusion.*//g' /etc/passwd ;\
    sed -i 's/ldap.*/'$LDAPGROUP'fusioniam/g' /etc/group ;\
    rm -f install.yaml
