#!/bin/sh
interval="30s"
show_metrics=0

usage() {
    echo "$0 <options> [metric1 metric2 ...]" > /dev/stderr
    echo -e "Options" > /dev/stderr
    echo -e "\t-i/--interval: The frequency at which pmlogger gathers data" > /dev/stderr
    echo -e "\t\tDefault: 30s" > /dev/stderr
    echo -e "\t\tSupported units:"
    echo -e "\t\t\ts (seconds, default if unit not specified)" > /dev/stderr
    echo -e "\t\t\tm (minutes)" > /dev/stderr
    echo -e "\t\t\th (hours)" > /dev/stderr
    echo -e "\t-h/--help: Show this message and exit" > /dev/stderr
    echo -e "\t--show-metrics: Show all PCP metrics and exit" > /dev/stderr
}

setup_pcp() {
    /usr/libexec/pcp/lib/pmcd start > /dev/null

    cd /var/lib/pcp/pmdas/nvidia/
    echo "daemon" | ./Install > /dev/null
}

convert_interval() {
    #Default is seconds
    unit=${1: -1}
    out_unit="seconds"
    if echo "$unit" | grep -E '[0-9]' > /dev/null; then
        echo "$1 seconds"
        return
    fi

    case $unit in
        s)
            out_unit="seconds"
        ;;
        m)
            out_unit="minutes"
        ;;
        h)
            out_unit="hours"
        ;;
        *)
            echo "Unknown unit $unit" > /dev/stderr
            exit 1
        ;;
    esac

    amount=$(echo $1 | tr -d "$unit")
    echo "$amount $out_unit"
}

OPTS=$(getopt --options "i:h" --longoptions "interval:,help,show-metrics" -- $@)
eval set -- "$OPTS"
while [[ -n "$@" ]]; do
    case $1 in
        -i | --interval)
            interval=$2
            shift 2
        ;;
        -h | --help)
            usage $0
            exit 0
        ;;
        --show-metrics)
            show_metrics=1
            shift
        ;;
        --)
            shift
            break
        ;;
        *)
            usage $0
            exit 1
        ;;
    esac
done


if [[ "$show_metrics" -eq 1 ]]; then
    setup_pcp
    pminfo
else
    if [ "$#" -ge 1 ]; then
        convert_interval $interval > /dev/null
        echo "log mandatory on $(convert_interval $interval) {" > /pmlogger.conf
        for metric in "$@"; do
            echo -e "\t$metric" >> /pmlogger.conf
        done
        echo "}" >> /pmlogger.conf
    fi
    
    setup_pcp

    cd /root
    
    echo "Starting pmlogger, CTL-C to kill"
    pmlogger -c /pmlogger.conf /root/thing.archive
fi
