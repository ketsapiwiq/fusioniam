ARG DEPEND
ARG VERSION

FROM $DEPEND:$VERSION

EXPOSE 8080

COPY ansible/ ./

RUN bash ./run-playbook.sh install.yaml &&\
    sed -i 's/listen *80/listen 8080/g' /etc/nginx/nginx.conf ;\
    sed -i 's/:80/:8080/g' /etc/nginx/nginx.conf ;\
    sed -i 's/user *nginx/user fusioniam/g' /etc/nginx/nginx.conf ;\
    sed -i 's@fastcgi_pass.*@fastcgi_pass unix:/var/run/php-fpm/www.sock;@g' /etc/nginx/default.d/php.conf ;\
    chown -R fusioniam:fusioniam /usr/share/white-pages/templates_c ;\
    chown -R fusioniam:fusioniam /usr/share/white-pages/cache ;\
    rm -f install.yaml 

RUN cp /usr/share/white-pages/conf/config.inc.php /usr/share/white-pages/
