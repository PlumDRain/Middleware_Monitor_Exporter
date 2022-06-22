#！/bin/sh

mkdir mongodb_exporter
tar -zxvf  mongodb_exporter-0.11.2.linux-amd64.tar.gz -C  mongodb_exporter

mkdir -p /data/monitor/

mv mongodb_exporter /data/monitor/

cp mongodb_exporter.service /etc/systemd/system/mongodb_exporter.service

systemctl daemon-reload
systemctl enable mongodb_exporter
systemctl start mongodb_exporter

