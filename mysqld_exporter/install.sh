#！/bin/sh

tar -zxvf  mysqld_exporter-0.12.1.linux-amd64.tar.gz

mkdir -p /data/monitor

mv mysqld_exporter-0.12.1.linux-amd64 /data/monitor/mysqld_exporter

cp mysqld_exporter.service /etc/systemd/system/mysqld_exporter.service

cp my.cnf /data/monitor/mysqld_exporter

if [ -n /usr/sbin/ifconfig ];then

    ip=`ifconfig bond1|grep 'inet'|grep -v 'inet6'|awk '{print $2}'`
    echo $ip|egrep  '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' &> /dev/null
    if [[ $? != "0"  ]];then
        echo "bond0 ip检测失败，如果使用其他网卡，需手动配置/data/monitor/mysqld_exporter/my.cnf的监控ip"
    fi
    echo "默认使用bond0 IP: $ip"
    sed -i "s/10.50.38.82/$ip/g" /data/monitor/mysqld_exporter/my.cnf
else
    echo "ifconfig未安装，使用配置文件中默认ip，请手动修改/data/monitor/mysqld_exporter/my.cnf的监控ip"
fi

systemctl daemon-reload
systemctl enable mysqld_exporter
systemctl start mysqld_exporter
