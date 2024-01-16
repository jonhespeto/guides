# Удаление правил iptables
Для начала смотрим какие правила и цепочки у нас имеются:
```
iptables -L -n -v
```
Выводим список правил с нумерацией строк:
```
iptables -L INPUT --line-numbers
```
### Чтобы удалить используем:
```
iptables -D INPUT номер_строки
```
Для цепочки  POSTROUTING.
```
iptables -t nat -L POSTROUTING --line-numbers
iptables -t nat -D POSTROUTING номер_строки