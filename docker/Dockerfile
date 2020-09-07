FROM garethr/kubeval:latest

ENV HELM_HOME="/root/.helm"
ENV K8S_VERSION=""

RUN apk --no-cache add \
    bash \
    curl \
    git \
    libc6-compat \
    openssh-client \
    py3-pip \
    python3 \
    && pip3 install --upgrade pip==20.2.2 \
    && pip3 install wheel

# Install a YAML Linter
ARG yamllint_version=1.24.2
LABEL yamllint_version=$yamllint_version
RUN pip install "yamllint==$yamllint_version"

# Install Yamale YAML schema validator
ARG yamale_version=3.0.2
LABEL yamale_version=$yamale_version
RUN pip install "yamale==$yamale_version"

# Install kubectl
ARG kubectl_version=v1.18.6
LABEL kubectl_version=$kubectl_version
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$kubectl_version/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/

# Install Helm
ARG helm_version=v2.16.10
LABEL helm_version=$helm_version
RUN curl -LO "https://get.helm.sh/helm-$helm_version-linux-amd64.tar.gz" && \
    mkdir -p "/usr/local/helm-$helm_version" && \
    tar -xzf "helm-$helm_version-linux-amd64.tar.gz" -C "/usr/local/helm-$helm_version" && \
    ln -s "/usr/local/helm-$helm_version/linux-amd64/helm" /usr/local/bin/helm && \
    rm -f "helm-$helm_version-linux-amd64.tar.gz"

RUN helm init --client-only --kubeconfig=/root/.kube/kubeconfig
RUN helm version --client

# Install Kube-score
ARG kubescore_version=1.8.1
LABEL kubescore_version=$kubescore_version
RUN curl -LO "https://github.com/zegl/kube-score/releases/download/v${kubescore_version}/kube-score_${kubescore_version}_linux_amd64.tar.gz" && \
    mkdir -p "/usr/local/kube-score-${kubescore_version}" && \
    tar -xzf "kube-score_${kubescore_version}_linux_amd64.tar.gz" -C "/usr/local/kube-score-${kubescore_version}" && \
    chown -R 775 "/usr/local/kube-score-${kubescore_version}" && \
    ln -s "/usr/local/kube-score-${kubescore_version}/kube-score" /usr/local/bin/kube-score && \
    rm -f "kube-score_${kubescore_version}_linux_amd64.tar.gz"

COPY ./docker/docker-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

VOLUME /charts
WORKDIR /charts

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

CMD ["helm kubeval . -v $K8S_VERSION"]
