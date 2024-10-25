; установка языка операционной системы (ru_RU)
("/sysconfig-base/language" action "write" lang ("ru_RU"))
; установка переключателя раскладки клавиатуры на Ctrl+Shift
("/sysconfig-base/kbd" action "write" layout "ctrl_shift_toggle")
; установка часового пояса в Europe/Moscow, время в BIOS будет храниться в UTC
("/datetime-installer" language ("en_US") action "write" commit #t name "Europe" zone "Europe/Moscow" utc #t ctime "set automatically")
; автоматическая разбивка жёсткого диска
("/evms/control" action "write" control open installer #t)
("/evms/control" action "write" control update)
("/evms/profiles/workstation" action apply commit #f clearall #t exclude ())
("/evms/control" action "write" control commit)
("/evms/control" action "write" control close)
("/remount-destination" action "write")
; монтирование файловой системы и создание базовых директорий
; для p10 и ниже скрипт нужно переименовать в pkg-init
("pkg-init" action "write")
;("/pkg-groups" language ("ru_RU") action "list")
;("/pkg-install/slideshow-config" language ("ru_RU") action "read")
; установка базовой системы и дополнительных групп пакетов из pkg-groups.tar,
; которые указываются по именам через пробел в параметре lists
("/pkg-install" action "write" lists "" auto #t)
("/preinstall" action "write")
; установка загрузчика GRUB в MBR на первый жёсткий диск
("/grub" action "write" device "/dev/vda" passwd #f passwd_1 "123" passwd_2 "123")
; настройка сетевого интерфейса на получение адреса по DHCP
("/net-eth" action "write" reset #t)
("/net-eth" action "write" name "eth0" configuration "dhcp" default "" search "" dns "" computer_name "c245")
; настройка сетевого интерфейса на статический IPv4
; ("/net-eth" action "write" name "eth0" configuration "static" default "192.168.1.1" search "localhost.com" dns "192.168.1.1" computer_name "c245" ipv "4" ipv_enabled #t)
; ("/net-eth" action "add_iface_address" name "eth0" addip "192.168.1.2" addmask "24" ipv "4")
("/net-eth" action "write" commit #t)
; установка пароля суперпользователя root '123'
("/root/change_password" language ("ru_RU") passwd_2 "123" passwd_1 "123")
; задание первого пользователя 'user' с паролем '123456789'
("/users/create_account" new_name "user" gecos "" allow_su #t auto #f passwd_1 "123456789" passwd_2 "123456789")