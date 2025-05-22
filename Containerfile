FROM fedora

RUN dnf install -y pcp-zeroconf pcp-pmda-nvidia-gpu util-linux
COPY . .

ENTRYPOINT ["/bin/sh", "entrypoint.sh"]
