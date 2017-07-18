FROM hellgate75/oracle-server-jre:8

MAINTAINER Fabrizio Torelli <hellgate75@gmail.com>

# Install required packages
RUN yum install -y \
    git \
    wget \
    bash \
    python3 \
    python-pip3 \
    su-exec \
    apk \
    sudo

USER root

ENV STORM_USER=storm \
    STORM_CONF_DIR=/conf \
    STORM_DATA_DIR=/data \
    STORM_LOG_DIR=/logs

# Add a user and make dirs
RUN set -x \
    && adduser -m -d "/home/$STORM_USER" -p "$STORM_USER" -s /bin/bash "$STORM_USER" \
    && mkdir -p "$STORM_CONF_DIR" "$STORM_DATA_DIR" "$STORM_LOG_DIR" \
    && chown -R "$STORM_USER:$STORM_USER" "$STORM_CONF_DIR" "$STORM_DATA_DIR" "$STORM_LOG_DIR"

ARG GPG_KEY=ACEFE18DD2322E1E84587A148DE03962E80B8FFD
ARG DISTRO_NAME=apache-storm-1.1.0

# Download Apache Storm, verify its PGP signature, untar and clean up
RUN set -x \
    && apk add --no-cache --virtual .build-deps \
        gnupg \
    && wget -q "http://www.apache.org/dist/storm/$DISTRO_NAME/$DISTRO_NAME.tar.gz" \
    && wget -q "http://www.apache.org/dist/storm/$DISTRO_NAME/$DISTRO_NAME.tar.gz.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-key "$GPG_KEY" \
    && gpg --batch --verify "$DISTRO_NAME.tar.gz.asc" "$DISTRO_NAME.tar.gz" \
    && tar -xzf "$DISTRO_NAME.tar.gz" \
    && chown -R "$STORM_USER:$STORM_USER" "$DISTRO_NAME" \
    && rm -r "$GNUPGHOME" "$DISTRO_NAME.tar.gz" "$DISTRO_NAME.tar.gz.asc" \
    && apk del .build-deps

WORKDIR $DISTRO_NAME

ENV PATH $PATH:/$DISTRO_NAME/bin

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
