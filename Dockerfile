FROM alpine:latest

RUN apk --update --no-cache add curl ca-certificates nginx
RUN apk add php8 php8-xml php8-exif php8-fpm php8-session php8-soap php8-openssl php8-gmp php8-pdo_odbc php8-json php8-dom php8-pdo php8-zip php8-mysqli php8-sqlite3 php8-pdo_pgsql php8-bcmath php8-gd php8-odbc php8-pdo_mysql php8-pdo_sqlite php8-gettext php8-xmlreader php8-bz2 php8-iconv php8-pdo_dblib php8-curl php8-ctype php8-phar php8-fileinfo php8-mbstring php8-tokenizer php8-simplexml
COPY --from=composer:latest  /usr/bin/composer /usr/bin/composer

USER container
ENV  USER container
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
