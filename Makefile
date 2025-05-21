all: nvidia

nvidia:
	podman build -t quay.io/kvalin/gpu-monitoring-pmlogger:nvidia -t quay.io/kvalin/gpu-monitoring-pmlogger:latest .
	podman push quay.io/kvalin/gpu-monitoring-pmlogger:nvidia quay.io/kvalin/gpu-monitoring-pmlogger:latest
