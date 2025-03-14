## Уведомление в телеграм бот при входе в ssh сессию


### Создаем файл 
```
sudo nano /usr/bin/login-notify
sudo chmod 700 /usr/bin/login-notify 
```
с содержимым ( заменить переменные ):

```bash
#!/bin/bash
PATH=/bin:/usr/bin
token='<token_bot>'
chat=<chat_id>
subj="$PAM_TYPE  on  ${HOSTNAME} from ${PAM_USER}"
message="Service: $PAM_SERVICE. Login {$PAM_USER} from ${PAM_RHOST} - $(date)"
/usr/bin/curl --header 'Content-Type: application/json' --request 'POST' --data "{\"chat_id\":\"${chat}\",\"text\":\"${subj}\n${message}\"}" "https://api.telegram.org/bot${token}/sendMessage"
```

##### Далее в файле 
```
sudo nano /etc/pam.d/sshd
```
в секцию  "# Create a new session keyring." добавляем:
```
session    optional     pam_exec.so /usr/bin/login-notify
```

##### после выполняем:
```
pam-auth-update
```

### Важно!
#### В конфигурационном файле ssh (например /etc/ssh/sshd_config.d/ssh_config.conf) должно быть:
``` 
UsePAM yes
```