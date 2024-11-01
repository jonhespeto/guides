Установка IPA

### Выполняем обновление пакетов

yum update


yum install bind-dyndb-ldap bind

Затем установим сам IPA сервер:

yum install ipa-server


dnf install freeipa-healthcheck

смотрим /etc/hosts добавляем сервер 

10.5.102.167 ipa01.rosa.demo ipa01

Перед установкой IPA сервера убедитесь, что hostname сервера у Вас задано строчными буквами

Если Вы устанавливаете IPA сервер первый раз, то используйте команду:

ipa-server-install --setup-dns

kinit admin

Install oVirt 3.5

yum install ovirt-engine -y