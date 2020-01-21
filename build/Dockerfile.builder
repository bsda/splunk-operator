# Note that go-toolset on UBI8 provides a FIPS-compatible compiler: https://developers.redhat.com/blog/2019/06/24/go-and-fips-140-2-on-red-hat-enterprise-linux/
# Unfortunately, the latest release uses golang 1.12, which is no longer compatible with the operator-sdk
#FROM registry.access.redhat.com/ubi8/go-toolset

##################################################################
## BEGIN: REPLACE ME WHEN go-toolset IS UPDATED TO GOLANG 1.13  ##
## THIS IS A TEMPORARY HACK TO MIMIC go-toolset FOR GOLANG 1.13 ##
##################################################################
FROM registry.access.redhat.com/ubi8/ubi-minimal
ENV HOME /opt/app-root/src
ENV PATH ${PATH}:/usr/local/go/bin
WORKDIR ${HOME}
RUN ln -s /usr/bin/microdnf /usr/bin/dnf \
    && dnf install -y wget tar gzip ca-certificates shadow-utils \
    && dnf clean all \
    && wget -O /tmp/go.tar.gz https://dl.google.com/go/go1.13.6.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf /tmp/go.tar.gz \
    && rm -f /tmp/go.tar.gz \
    && mkdir -p /opt/app-root \
    && useradd -r -m -u 1000 -G root -d ${HOME} default \
    && chown -R default.root ${HOME}
###############################################################
## END: REPLACE ME WHEN go-toolset IS UPDATED TO GOLANG 1.13 ##
###############################################################

USER root

RUN dnf install -y git openssh tar gzip ca-certificates && dnf clean all

USER default

COPY --chown=default:root go.mod go.sum ${HOME}/

RUN go mod download && rm -rf go/pkg/mod/cache/vcs
