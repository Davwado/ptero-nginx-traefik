FROM alpine:latest


RUN apk --update --no-cache add curl ca-certificates nginx
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

USER container
ENV USER container
ENV HOME /home/container
ENV WEB_ADDRESS=

WORKDIR /home/container
COPY ./entrypoint.sh /entrypoint.sh

# Add Traefik labels
LABEL traefik.enable="true"
LABEL traefik.http.routers.app-router.rule="Host(\`${WEB_ADDRESS}\`)"
LABEL traefik.http.routers.app-router.entrypoints="http"
LABEL traefik.http.routers.app-router.middlewares=app-redirect
LABEL traefik.http.middlewares.app-redirect.redirectscheme.scheme="https"
LABEL traefik.http.routers.app-router-secure.rule="Host(\`${WEB_ADDRESS}\`)"
LABEL traefik.http.routers.app-router-secure.entrypoints="https"
LABEL traefik.http.routers.app-router-secure.tls="true"

CMD ["/bin/ash", "/entrypoint.sh"]

