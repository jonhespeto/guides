## Удаление кластера ProxMox если старые ноды висят серыми (неактивными) и новый кластер не собирается.

### Останавливаем кластер
```bash
systemctl stop pve-cluster
systemctl stop corosync
rm -fr /etc/pve/nodes/*
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
### Убиваем одиночный процесс, лучше несколько раз.
```bash
killall pmxcfs
pmxcfs: no process found
```
### Удаляем список нод с сервера, иначе они будут болтаться там «неживые».
```bash
rm -fr /etc/pve/nodes
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