## Уведомление в телеграм бот при входе в ssh сессию


### Создаем файл 
```
nano /usr/bin/login-notify 
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