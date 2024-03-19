## Удаление кластера ProxMox если старые ноды висят серыми (неактивными) и новый кластер не собирается.

### Останавливаем кластер
```bash
rm -rf /etc/pve/nodes/*
systemctl stop pve-cluster
systemctl stop corosync
```

### Старуем кластер снова в одиночном режиме
```bash
pmxcfs -l
```
### Удаляем файлы конфигов
```bash
rm /etc/pve/corosync.conf
rm -r /etc/corosync/*
```
### Убиваем одиночный процесс, лучше несколько раз , пока не будет "pmxcfs: no process found".
```bash
killall pmxcfs
```
### Удаляем список нод с сервера, иначе они будут болтаться там «неживые».
```bash
rm -rf /etc/pve/nodes
```
### Включем кластер
```bash
systemctl start corosync
systemctl start pve-cluster
```
### Для рестарта веб морды выполняем
```bash
service pveproxy restart
```


## В случае если будут ошибки с сертификатами :
Delete the HTTPS certificates.
```bash
rm /etc/pve/pve-root-ca.pem
rm /etc/pve/priv/pve-root-ca.key
rm /etc/pve/nodes/pmx01/pve-ssl.pem
rm /etc/pve/nodes/pmx02/pve-ssl.pem
rm /etc/pve/nodes/pmx03/pve-ssl.pem
rm /etc/pve/nodes/pmx01/pve-ssl.key
rm /etc/pve/nodes/pmx02/pve-ssl.key
rm /etc/pve/nodes/pmx03/pve-ssl.key
rm /etc/pve/authkey.pub
rm /etc/pve/priv/authkey.key
rm /etc/pve/priv/authorized_keys
```
Generate new HTTPS certificates


```bash
pvecm updatecerts -f
```
Restart the pvedaemon and pveproxy services.
```bash
systemctl restart pvedaemon pveproxy
```
SSH Certificates
SSH is used to migrate VM's between nodes.

Move the ssh known_hosts file.
```bash
mv /root/.ssh/known_hosts /root/.ssh/known_hosts_old
```
Now SSH between all the nodes to ensure you have no SSH issues.

### After Reboot system
Finally, shutdown the VM's and reboot the hosts, one by one.
