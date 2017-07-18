#!/bin/bash

set -e

# Allow the container to be started with `--user`
if [ "$2" = 'storm' -a "$(id -u)" = '0' ]; then
    chown -R "$STORM_USER" "$STORM_CONF_DIR" "$STORM_DATA_DIR" "$STORM_LOG_DIR"
    exec sudo -u "$STORM_USER" "$0" "${@:2}"
fi

# Generate the config only if it doesn't exist
CONFIG="$STORM_CONF_DIR/storm.yaml"
if [ ! -f "$CONFIG" ]; then
    cat << EOF > "$CONFIG"
storm.zookeeper.servers: [zookeeper]
nimbus.seeds: [nimbus]
storm.log.dir: "$STORM_LOG_DIR"
storm.local.dir: "$STORM_DATA_DIR"
EOF
fi
exec "$@"

if [[ "$1" = '-daemon' ]]; then
  tail -f /dev/null
fi
