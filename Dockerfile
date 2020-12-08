FROM docker:19.03-dind

ENV VERSION=v0.13.1

RUN apk add --update --no-cache \
        curl \
        bash \
        ca-certificates \
        groff \
        less \
        python \
        py-pip \
    && rm -rf /var/cache/apk/* \
    && pip install pip --upgrade \
    && pip install aws && \
    curl -LO https://github.com/buildpacks/pack/releases/download/${VERSION}/pack-${VERSION}-linux.tgz && \
    tar xfz pack-${VERSION}-linux.tgz && \
    mv pack /usr/bin/

RUN mkdir /work
COPY entrypoint.sh /work/entrypoint.sh
RUN chmod +x /work/entrypoint.sh

ENTRYPOINT [ "/work/entrypoint.sh" ]
