#!/bin/sh
CONFIG_PATH=/data/options.json

USER=$(jq --raw-output '.auth_user' $CONFIG_PATH)
PASS=$(jq --raw-output '.auth_pass' $CONFIG_PATH)
LOG_LEVEL=$(jq --raw-output '.log_level // "Info"' $CONFIG_PATH)

# Tạo folder và phân quyền cho tinyproxy
mkdir -p /var/run/tinyproxy /var/log/tinyproxy /etc/tinyproxy
chown -R tinyproxy:tinyproxy /var/run/tinyproxy /var/log/tinyproxy /etc/tinyproxy

cat <<EOF > /etc/tinyproxy/tinyproxy.conf
User tinyproxy
Group tinyproxy
Port 8888
Timeout 600
DefaultErrorFile "/usr/share/tinyproxy/default.html"
StatFile "/usr/share/tinyproxy/stats.html"
Logfile "/dev/stdout"
LogLevel ${LOG_LEVEL}
PidFile "/var/run/tinyproxy/tinyproxy.pid"
MaxClients 100
Allow 0.0.0.0/0
BasicAuth ${USER} ${PASS}
EOF

exec /usr/bin/tinyproxy -d
