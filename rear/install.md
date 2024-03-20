### Установка:

```bash
echo 'deb http://download.opensuse.org/repositories/Archiving:/Backup:/Rear/xUbuntu_20.04/ /' | sudo tee /etc/apt/sources.list.d/Archiving:Backup:Rear.list
curl -fsSL https://download.opensuse.org/repositories/Archiving:Backup:Rear/xUbuntu_20.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/Archiving_Backup_Rear.gpg > /dev/null
sudo apt update
sudo apt install rear genisoimage syslinux nfs-common tmux -y
```

Меняем конфиг rear:
```bash
sudo nano /etc/rear/local.conf
```

В случае копирования архива в расшаренную папку добавляем:
```text
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
```bash
sudo nano /usr/share/rear/verify/NETFS/default/050_start_required_nfs_daemons.sh
```
меняем
```text
test "ok" = $attempt || Error "RPC portmapper '$portmapper_program' unavailable."
```
на
```text
test "ok" = $ attempt || LogPrint "RPC portmapper '$ portmapper_program' unavailable."
```
Запуск бекапа rear предпочтительно через tmux:
```bash
sudo rear -v -d mkbackup
```
## Если хотим сделать бекап по расписанию :
создадаем юнит сервиса:
```bash
nano /etc/systemd/system/rear.service
```
внесем следующий текст:
```bash
[Unit]
Description=Relax-and-Recover
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/sbin/rear mkbackup

[Install]
WantedBy=multi-user.target
```
Затем создаем юнит таймера:
```bash
nano /etc/systemd/system/rear.timer
```
Размещаем следующие строки:
```bash
[Unit]
Description=Relax-and-Recover timer

[Timer]
OnCalendar=daily
AccuracySec=1h
Persistent=true

[Install]
WantedBy=timers.target
```
В примере ежедневный запуск раз в 1 час точно в полночь, также будет выполнен автоматический запуск при пропуске задания.
Применим изменения в юнитах:
```bash 
systemctl daemon-reload
```
Запускаем юнит сервис:
```bash
systemctl start rear
```

После чего должно выполниться резервное копирование. Если все прошло хорошо, то просто включаем таймер для него в автозагрузку:
```bash
systemctl enable rear.timer
```