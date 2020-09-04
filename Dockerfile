FROM quay.io/helmpack/chart-testing:v2.4.1

RUN helm plugin install https://github.com/instrumenta/helm-kubeval

