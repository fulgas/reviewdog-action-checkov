FROM alpine:3.23@sha256:865b95f46d98cf867a156fe4a135ad3fe50d2056aa3f25ed31662dff6da4eb62 AS reviewdog-builder

ARG TARGETARCH
ENV REVIEWDOG_VERSION=v0.21.0

RUN apk add --no-cache curl && \
    case "${TARGETARCH}" in \
        "amd64") ARCH="x86_64" ;; \
        "arm64") ARCH="arm64" ;; \
        *) echo "Unsupported architecture: ${TARGETARCH}" && exit 1 ;; \
    esac && \
    curl -sfL https://github.com/reviewdog/reviewdog/releases/download/${REVIEWDOG_VERSION}/reviewdog_${REVIEWDOG_VERSION#v}_Linux_${ARCH}.tar.gz | \
    tar -xz -C /usr/local/bin reviewdog && \
    chmod +x /usr/local/bin/reviewdog


FROM python:3.14-slim@sha256:3955a7dd66ccf92b68d0232f7f86d892eaf75255511dc7e98961bdc990dc6c9b AS python-builder

ENV CHECKOV_VERSION=3.2.497

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    gcc \
    g++ \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*


RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN pip install --no-cache-dir checkov==${CHECKOV_VERSION};

FROM python:3.14-slim@sha256:3955a7dd66ccf92b68d0232f7f86d892eaf75255511dc7e98961bdc990dc6c9b

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean


COPY --from=python-builder /opt/venv /opt/venv

COPY --from=reviewdog-builder /usr/local/bin/reviewdog /usr/local/bin/reviewdog

ENV PATH="/opt/venv/bin:$PATH"

COPY --chmod=755 entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]