FROM buildpack-deps:jessie

MAINTAINER "Jonas Lundberg <jonas@5monkeys.se>"

ENV TWEMPROXY_VERSION 0.4.1

# Download and extract distribution tarball
WORKDIR /tmp
RUN curl -L https://github.com/twitter/twemproxy/archive/v${TWEMPROXY_VERSION}.tar.gz | tar xz

# Build and install
RUN cd twemproxy-${TWEMPROXY_VERSION} && \
    autoreconf -fvi && \
    ./configure && \
    make && \
    make install

# Copy conf and cleanup
RUN cp /tmp/twemproxy-${TWEMPROXY_VERSION}/conf/nutcracker.yml /etc/ && \
    rm -rf /tmp/twemproxy-${TWEMPROXY_VERSION}

WORKDIR /

ENTRYPOINT ["/usr/local/sbin/nutcracker", "-c", "/etc/nutcracker.yml"]
