FROM fedora

RUN dnf install -y pcp-zeroconf pcp-pmda-nvidia-gpu
WORKDIR /root
COPY . .

ENTRYPOINT ["entrypoint.sh"]
