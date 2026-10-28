FROM alpine:3.24@sha256:71e9b7bae160ba167fa17414401b94cbcdaf3c32feeab9298bd794a2a0614c35 AS reviewdog-builder

ARG TARGETARCH
ENV REVIEWDOG_VERSION=v0.21.2

RUN apk add --no-cache curl && \
    case "${TARGETARCH}" in \
        "amd64") ARCH="x86_64" ;; \
        "arm64") ARCH="arm64" ;; \
        *) echo "Unsupported architecture: ${TARGETARCH}" && exit 1 ;; \
    esac && \
    curl -sfL https://github.com/reviewdog/reviewdog/releases/download/${REVIEWDOG_VERSION}/reviewdog_${REVIEWDOG_VERSION#v}_Linux_${ARCH}.tar.gz | \
    tar -xz -C /usr/local/bin reviewdog && \
    chmod +x /usr/local/bin/reviewdog


FROM python:3.14-slim@sha256:cd89c30eda26ee911a4611b18680086e0ea42e6f5f8cbe653d07fa7958c9cec8 AS python-builder

ENV CHECKOV_VERSION=3.3.30

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    gcc \
    g++ \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*


RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN pip install --no-cache-dir checkov==${CHECKOV_VERSION};

FROM python:3.14-slim@sha256:cd89c30eda26ee911a4611b18680086e0ea42e6f5f8cbe653d07fa7958c9cec8

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