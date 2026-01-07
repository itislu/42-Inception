FROM alpine:3.22

ARG CADVISOR_VERSION=v0.55.1

ADD --chmod=755 https://github.com/google/cadvisor/releases/download/${CADVISOR_VERSION}/cadvisor-${CADVISOR_VERSION}-linux-amd64 \
	/usr/bin/cadvisor

CMD ["/usr/bin/cadvisor", "-logtostderr"]
