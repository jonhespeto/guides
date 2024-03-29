## Запуск скриптов на события ИБП в Network UPS Tools , с отправкой сообщений в телеграм.

Для начала добавим в файл "/etc/nut/upsmon.conf" строки:
```
# Путь к утилите upssched
NOTIFYCMD /sbin/upssched

# Флаги событий
# События:
# * ONLINE: переход на питание от сети
# * ONBATT: переход на питание от батареи
# * LOWBATT: низкий заряд батареи
# * REPLBATT: батарея нуждается в замене
#
# Флаги:
# * SYSLOG: логирование события в syslog
# * WALL: послать оповещение всем пользователям через команду wall
# * EXEC: Выполнить скрипт
NOTIFYFLAG ONLINE	SYSLOG+WALL+EXEC
NOTIFYFLAG ONBATT	SYSLOG+WALL+EXEC
NOTIFYFLAG LOWBATT	SYSLOG+WALL+EXEC
NOTIFYFLAG REPLBATT	SYSLOG+WALL+EXEC
```
Далее приводим файл "/etc/nut/upssched.conf" к виду:
```
# Скрипт, который будет запускаться на события от ИБП
CMDSCRIPT /etc/nut/upssched.sh

# События, на которые будет запускаться скрипт
# Каждая строка имеет вид:
# AT событие ИБП команда
# Звёздочка означает любой ИБП
AT ONLINE * EXECUTE online
AT ONBATT * EXECUTE onbatt
AT LOWBATT * EXECUTE lowbatt
AT REPLBATT * EXECUTE replbatt

# Сокет, используемый для внутренних межпроцессных коммуникаций
PIPEFN /var/lib/nut/upssched.pipe

# Файл блокировки для исключения "состояния гонки",
# которая возможна при обработке нескольких событий одновременно
LOCKFN /var/lib/nut/upssched.lock
```

Ну и наконец создаём скрипт "/etc/nut/upssched.sh"
```
#!/bin/sh

# Этот скрипт будет запускаться nut-клиентом
# Ему дополнительно передаются следующие переменные окружения:
# * NOTIFYTYPE: тип события. Например ONLINE (см. upssched.conf)
# * UPSNAME: имя ИБП, сгенерировавшего событие. Например main@localhost

# Основная часть выполняемой команды.

case $1 in
        onbatt)
                        ${SMSCMD} curl -s -X POST https://api.telegram.org/bot<YOUR_BOT_TOKEN>/sendMessage -d chat_id=<YOUR_CHAT_ID> -d text='❌  UPS - переход на питание от батареи'
                ;;
        online)
                        ${SMSCMD} curl -s -X POST https://api.telegram.org/bot<YOUR_BOT_TOKEN>/sendMessage -d chat_id=<YOUR_CHAT_ID> -d text='✅  UPS - электричество восстановлено'
                ;;
        lowbatt)
                        ${SMSCMD} curl -s -X POST https://api.telegram.org/bot<YOUR_BOT_TOKEN>/sendMessage -d chat_id=<YOUR_CHAT_ID> -d text='UPS - низкий уровень заряда батареи'
                ;;
        replbatt)
                        ${SMSCMD} curl -s -X POST https://api.telegram.org/bot<YOUR_BOT_TOKEN>/sendMessage -d chat_id=<YOUR_CHAT_ID> -d text='UPS - требуется замена батареи'
                ;;
esac
```

Делаем скрипт исполняемым и перезапускаем NUT-клиент:

```
chmod +x /etc/nut/upssched.sh && service nut-client restart
```