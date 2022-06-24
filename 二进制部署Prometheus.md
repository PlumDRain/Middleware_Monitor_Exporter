# 二进制部署Prometheus

## 1 下载地址

```shell
https://github.com/prometheus/prometheus
```

## 2 Systemd管理二进制prometheus

### 2.1 软件包

```shell
这里使用的是 prometheus-2.36.2.linux-amd64.tar.gz
```

### 2.2 上传服务器

```shell
mkdir -p /data/prometheus/
cd /data/prometheus/
wget https://github.com/prometheus/prometheus/releases/tag/v2.36.2/prometheus-2.36.2.linux-amd64.tar.gz
tar zxvf prometheus-2.36.2.linux-amd64.tar.gz 
cd prometheus-2.36.2.linux-amd64

#查看软件包内容
[root@10-2-39-210 prometheus-2.36.2.linux-amd64]# ll
total 203048
drwxr-xr-x 2 3434 3434        38 Jun 20 21:27 console_libraries
drwxr-xr-x 2 3434 3434       173 Jun 20 21:27 consoles
-rw-r--r-- 1 3434 3434     11357 Jun 20 21:27 LICENSE
-rw-r--r-- 1 3434 3434      3773 Jun 20 21:27 NOTICE
-rwxr-xr-x 1 3434 3434 108069824 Jun 20 21:24 prometheus            #二进制程序        
-rw-r--r-- 1 3434 3434       934 Jun 20 21:27 prometheus.yml        #配置清单
-rwxr-xr-x 1 3434 3434  99826736 Jun 20 21:26 promtool
```

### 2.3 添加systemd管理

#### 2.3.1 创建Prometheus.service

```shell
cat << 'EOF' > /etc/systemd/system/prometheus.service
[Unit]
Description=prometheus
After=network.target
[Service]
Type=simple
Restart=on-failure
ExecStart=/data/prometheus/prometheus-2.36.2.linux-amd64/prometheus \
         --config.file=/data/prometheus/prometheus-2.36.2.linux-amd64/prometheus.yml \
         --storage.tsdb.path=/data/prometheus/prometheus-2.36.2.linux-amd64/data/ \
         --web.enable-lifecycle \
         --storage.tsdb.retention.time=15d
ExecReload=/usr/bin/curl -X POST http://localhost:9090/-/reload
[Install]
WantedBy=multi-user.target
EOF
```

#### 2.3.2 启动并设置开机自启

```shell
netstat -lntup|grep 9090

systemctl start prometheus.service 
systemctl status prometheus.service

netstat -lntup|grep 9090

systemctl is-enabled prometheus.service
systemctl enable prometheus.service
systemctl is-enabled prometheus.service
```

## 3 部署二进制exporter

### 3.1 下载exporter

#### 3.1.1 下载地址

```shell
https://github.com/PlumDRain/Middleware_Monitor_Exporter
```

#### 3.1.2 下载exporter

```shell
mkdir -p /data/prometheus/exporter-packages
cd /data/prometheus/exporter-packages
wget https://github.com/PlumDRain/Middleware_Monitor_Exporter/archive/refs/tags/v0.2.tar.gz
tar zxvf Middleware_Monitor_Exporter-0.2.tar.gz
cd Middleware_Monitor_Exporter-0.2/

#查看软件包内容
[root@10-2-39-210 Middleware_Monitor_Exporter-0.2]# ll
total 0
drwxrwxr-x 2 root root 202 Jun 22 14:55 kafka_exporter
drwxrwxr-x 2 root root 212 Jun 22 14:55 mongodb_exporter
drwxrwxr-x 2 root root 238 Jun 22 14:55 mysqld_exporter
drwxrwxr-x 2 root root 206 Jun 22 14:55 redis_exporter
```

### 3.2 安装exporter

#### 3.2.1 Mysql_exporter

```shell
cd /data/prometheus/exporter-packages/Middleware_Monitor_Exporter-0.2/mysqld_exporter

#查看mysqld_exporter内容
[root@10-2-39-210 mysqld_exporter]# ll
total 6968
-rw-r--r-- 1 root root     952 Jun 22 15:23 install.sh      #安装脚本，仅支持大园区，可根据自身业务修改
-rw-r--r-- 1 root root      69 Jun 22 15:22 my.cnf          #mysqld_exporter监控的数据库及用户信息      
-rw-r--r-- 1 root root 7121565 Jun 22 15:22 mysqld_exporter-0.12.1.linux-amd64.tar.gz
-rw-r--r-- 1 root root     231 Jun 22 15:22 mysqld_exporter.service

netstat -lntup|grep 9104
bash install.sh
netstat -lntup|grep 9104

curl 127.0.0.1:9104/metrics|grep mysql_up
#需创建exporter监控用户，才可正常监控
```

#### 3.2.2 Redis_exporter

```shell
cd /data/prometheus/exporter-packages/Middleware_Monitor_Exporter-0.2/redis_exporter

#查看redis_exporter内容
[root@10-2-39-210 redis_exporter]# ll
total 3176
-rw-r--r-- 1 root root     316 Jun 22 15:22 install.sh
-rw-r--r-- 1 root root     218 Jun 22 15:22 redis_exporter.service
-rw-r--r-- 1 root root 3242761 Jun 22 15:22 redis_exporter-v1.14.0.linux-amd64.tar.gz

netstat -lntup|grep 9121
bash install.sh
netstat -lntup|grep 9121

curl 127.0.0.1:9121/metrics|grep redis_up
```

#### 3.2.3 Mongodb_exporter

```shell
cd /data/prometheus/exporter-packages/Middleware_Monitor_Exporter-0.2/mongodb_exporter

#查看mongodb_exporter内容
[root@10-2-39-210 mongodb_exporter]# ll
total 8620
-rw-r--r-- 1 root root     339 Jun 22 15:22 install.sh
-rw-r--r-- 1 root root 8815853 Jun 22 15:22 mongodb_exporter-0.11.2.linux-amd64.tar.gz
-rw-r--r-- 1 root root     270 Jun 22 15:22 mongodb_exporter.service

netstat -lntup|grep 9216
bash install.sh
netstat -lntup|grep 9216

curl 127.0.0.1:9216/metrics|grep mongodb_up
```

#### 3.2.4 Kafka_exporter

```shell
cd /data/prometheus/exporter-packages/Middleware_Monitor_Exporter-0.2/kafka_exporter

#查看kafka_exporter内容
[root@10-2-39-210 kafka_exporter]# ll
total 4140
-rw-r--r-- 1 root root     924 Jun 22 15:22 install.sh
-rw-r--r-- 1 root root 4228589 Jun 22 15:22 kafka_exporter-1.2.0.linux-amd64.tar.gz
-rw-r--r-- 1 root root     230 Jun 22 15:22 kafka_exporter.service

netstat -lntup|grep 9308
bash install.sh
netstat -lntup|grep 9308

curl 127.0.0.1:9308/metrics 
```

## 4 编写Prometheus.yml

### 4.1 初始prometheus.yml

```yaml
# my global config
global:
  scrape_interval: 15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.
  # scrape_timeout is set to the global default (10s).

# Alertmanager configuration
alerting:
  alertmanagers:
    - static_configs:
        - targets:
          # - alertmanager:9093

# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
  # - "first_rules.yml"
  # - "second_rules.yml"

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: "prometheus"

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
      - targets: ["localhost:9090"]
```

### 4.2 配置中间件Metrics采集

```yaml
# my global config
global:
  scrape_interval: 15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.
  # scrape_timeout is set to the global default (10s).

# Alertmanager configuration
alerting:
  alertmanagers:
    - static_configs:
        - targets:
          # - alertmanager:9093

# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
  # - "first_rules.yml"
  # - "second_rules.yml"

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: "prometheus"

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
      -scrape_configs:
  - job_name: "prometheus"
    static_configs:
      - targets: ["localhost:9090"]

  - job_name: 'Node-Healthy'
    static_configs:
    - targets:
      - 10.2.39.210:9100
      - 10.2.39.211:9100
      - 10.2.39.212:9100
      - 10.2.39.213:9100
      labels:
        mozu: b2-1-dy

  - job_name: 'Mysql-Healthy'
    static_configs:
    - targets:
      - 10.2.39.211:9104
      - 10.2.39.212:9104
      - 10.2.39.213:9104
      labels:
        mozu: b2-1-dy

  - job_name: 'Redis-Healthy'
    static_configs:
    - targets:
      - 10.2.39.211:9121
      - 10.2.39.212:9121
      - 10.2.39.213:9121
      labels:
        mozu: b2-1-dy

  - job_name: 'MongoDB-Healthy'
    static_configs:
    - targets:
      - 10.2.39.211:9216
      - 10.2.39.212:9216
      - 10.2.39.213:9216
      labels:
        mozu: b2-1-dy

  - job_name: 'Kafka-Healthy'
    static_configs:
    - targets:
      - 10.2.39.211:9308
      - 10.2.39.212:9308
      - 10.2.39.213:9308
      labels:
        mozu: b2-1-dy

remote_write:
  - name: Tnebula_prometheus # Remote write 的名称
    url: http://106.55.235.73:29090/api/v1/prom/write  # 从 Prometheus 基本信息中获取 Remote Write 地址
    remote_timeout: 60s # 根据实际情况设置
    bearer_token: KBsSRbMlrmrtWxxpbTbV # 从 Prometheus 基本信息中获取 Token 信息
```
