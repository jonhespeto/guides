### Установка:

```
echo 'deb http://download.opensuse.org/repositories/Archiving:/Backup:/Rear/xUbuntu_20.04/ /' | sudo tee /etc/apt/sources.list.d/Archiving:Backup:Rear.list
curl -fsSL https://download.opensuse.org/repositories/Archiving:Backup:Rear/xUbuntu_20.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/Archiving_Backup_Rear.gpg > /dev/null
sudo apt update
sudo apt install rear genisoimage syslinux nfs-common tmux -y
```

меняем конфиг rear:
```
sudo nano /etc/rear/local.conf
```
В случае копирования архива в расшаренную папку добавляем:
```
OUTPUT=ISO
OUTPUT_URL=nfs://<IP_адрес>/volume1/Backups
BACKUP=NETFS
BACKUP_OPTIONS="nfsvers=4.1,nolock"
NETFS_KEEP_OLD_BACKUP_COPY=
USE_DHCLIENT=yes
BACKUP_URL=nfs://<IP_адресс>/volume1/Backups
BACKUP_PROG_EXCLUDE=("${BACKUP_PROG_EXCLUDE[@]}" '/media' '/var/tmp' '/var/crash')
OUTPUT_PREFIX="$HOSTNAME.ReaRBackup.$( date +%d-%m-%Y 2>/dev/null )"
NETFS_PREFIX="$HOSTNAME.ReaRBackup.$( date +%d-%m-%Y 2>/dev/null )"
PROGRESS_WAIT_SECONDS="10"
```
далее чтобы избежать ошибки правим:
``` 
sudo nano /usr/share/rear/verify/NETFS/default/050_start_required_nfs_daemons.sh
```

меняем
```
test "ok" = $attempt || Error "RPC portmapper '$portmapper_program' unavailable."
```
на
```
test "ok" = $ attempt || LogPrint "RPC portmapper '$ portmapper_program' unavailable."
```
запуск бекапа rear предпочтительно через tmux:
```
sudo rear -v -d mkbackup
```