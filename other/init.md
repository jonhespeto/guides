### Проверить какая система инициализации на Linux можно множеством путей, как правила все они зависят от версии Linux дистрибутива и не все работают 100% на всех дистрибутивах, первоначально проверяем
```bash
ls -l `which init`
```
если покажет симлинк вида
```bash
lrwxrwxrwx 1 root root 20 фев 1  2020 /sbin/init -> /lib/systemd/systemd
```
то тут все понятно - systemd

если симлинка нет, то может помочь конструкция:
```bash
strings /sbin/init | awk 'match($0, /(upstart|systemd|sysvinit)/) { print toupper(substr($0, RSTART, RLENGTH));exit; }'
```
