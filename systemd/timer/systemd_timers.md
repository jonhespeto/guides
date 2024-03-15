
```bash
nano /etc/systemd/system/<NAME>.service
```

Содержание примерно следующее:

```text
[Unit]
Description=<описание>

[Service]
Type=oneshot
ExecStart=/bin/echo "Hello, world!"

[Install]
WantedBy=multi-user.target
```

Перезагружаем службу systemd:
```bash
systemctl daemon-reload
```
Пробуем запустить сервис:
```bash
systemctl start <NAME>
```
Смотрим состояние:
```bash
systemctl status <NAME>
```
Если сервис работает переходим к созданию таймера:
```bash
nano /etc/systemd/system/<NAME>.timer
```