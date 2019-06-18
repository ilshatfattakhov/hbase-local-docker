FROM alpine:latest
MAINTAINER Ilshat Fattakhov <ifattakhov@fix.ru>

ARG HBASE_VERSION=2.1.2

ENV PATH $PATH:/hbase/bin

ENV JAVA_HOME=/usr

LABEL Description="HBase Dev", \
      "HBase Version"="$HBASE_VERSION"

WORKDIR /

# bash => entrypoint.sh
# java => hbase engine
RUN set -euxo pipefail && \
    apk add --no-cache bash openjdk8-jre-base

RUN set -euxo pipefail && \
    apk add --no-cache wget tar && \
    url="http://www.apache.org/dyn/closer.lua?filename=hbase/$HBASE_VERSION/hbase-$HBASE_VERSION-bin.tar.gz&action=download"; \
    url_archive="http://archive.apache.org/dist/hbase/$HBASE_VERSION/hbase-$HBASE_VERSION-bin.tar.gz"; \
    wget -t 10 --max-redirect 1 --retry-connrefused -O "hbase-$HBASE_VERSION-bin.tar.gz" "$url" || \
    wget -t 10 --max-redirect 1 --retry-connrefused -O "hbase-$HBASE_VERSION-bin.tar.gz" "$url_archive" && \
    mkdir "hbase-$HBASE_VERSION" && \
    tar zxf "hbase-$HBASE_VERSION-bin.tar.gz" -C "hbase-$HBASE_VERSION" --strip 1 && \
    test -d "hbase-$HBASE_VERSION" && \
    ln -sv "hbase-$HBASE_VERSION" hbase && \
    rm -fv "hbase-$HBASE_VERSION-bin.tar.gz" && \
    rm -rf hbase-$HBASE_VERSION/docs && \
    rm -rf hbase-$HBASE_VERSION/src && \
    mkdir /data && \
    apk del tar wget

# Needed for HBase 2.0+ hbase-shell
# asciidoctor solves 'NotImplementedError: fstat unimplemented unsupported or native support failed to load'
# RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
#    apk update && \
#    apk add jruby && \
#    apk add jruby-irb && \
#    apk add asciidoctor && \
#    echo exit | hbase shell
    # jruby-maven jruby-minitest jruby-rdoc jruby-rake jruby-testunit && \

RUN set -euxo pipefail && \
    wget -q "https://github.com/ilshatfattakhov/hbase-local-docker/raw/master/libhadoop.so" && \
    mkdir /hadoop-native && \
    mv libhadoop.so /hadoop-native

#ADD hbase-daemon.sh /hbase-$VERSION/bin/hbase-daemon.sh

ENV HBASE_DATA_DIR=/data
ENV ZOOKEEPER_QUORUM=zookeeper-quorum:2181
ENV MASTER_HOSTNAME=master-hostname
ENV MASTER_PORT=16000
ENV REGIONSERVER_PORT=16030
ENV REGIONSERVERS=regionserver1,regionserver2    
ENV LD_LIBRARY_PATH=/hadoop-native:/usr/lib:/usr/local/lib
ENV HBASE_ROLE=dummy

VOLUME ["/data"]

EXPOSE 16000 16010 16020 16030

WORKDIR /hbase-$HBASE_VERSION

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
