#！/bin/sh

tar -zxvf  redis_exporter-v1.14.0.linux-amd64.tar.gz

mkdir -p /data/monitor

mv redis_exporter-v1.14.0.linux-amd64 /data/monitor/redis_exporter

cp redis_exporter.service /etc/systemd/system/redis_exporter.service

systemctl daemon-reload
systemctl enable redis_exporter
systemctl start redis_exporter
