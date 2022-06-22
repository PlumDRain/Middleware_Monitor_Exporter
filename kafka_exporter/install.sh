#！/bin/sh

tar -zxvf  kafka_exporter-1.2.0.linux-amd64.tar.gz

mkdir -p /data/monitor

mv kafka_exporter-1.2.0.linux-amd64 /data/monitor/kafka_exporter

cp kafka_exporter.service /etc/systemd/system/kafka_exporter.service


if [ -n /usr/sbin/ifconfig ];then

    ip=`ifconfig bond1|grep 'inet'|grep -v 'inet6'|awk '{print $2}'`
    echo $ip|egrep  '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' &> /dev/null
    if [[ $? != "0"  ]];then
        echo "bond0 ip检测失败，如果使用其他网卡，需手动配置/etc/systemd/system/kafka_exporter.service的监控ip"
    fi
    echo "默认使用bond0 IP: $ip"
    sed -i "s/10.102.168.4/$ip/g" /etc/systemd/system/kafka_exporter.service
else
    echo "ifconfig未安装，使用配置文件中默认ip，请手动修改/etc/systemd/system/kafka_exporter.service的监控ip"
fi

systemctl daemon-reload
systemctl enable kafka_exporter
systemctl start kafka_exporter
