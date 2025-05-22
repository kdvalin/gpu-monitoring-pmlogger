# gpu-monitoring-pmlogger
A simple container to monitor GPU metrics and other relevant details and export them to a PCP archive for later analysis.

## Usage
The container exports pmlogger archives to `/root` within the container, it is recommended to mount that as a volume for easy retrival.

### Nvidia
`podman run --device nvidia.com/gpu=all --security-opt label=disable -v <desired output directory>:/root quay.io/kvalin/gpu-monitoring-pmlogger:nvidia`
