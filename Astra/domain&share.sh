#!/bin/bash

# Проверка запущен ли скрипт от рута
[ "$(id -u)" -ne 0 ] && {
    echo -e "${red} Запускаем от суперпользователя! ${nc}"
    exit 1
}

dir="$(dirname "$0")"

# Цветовая схема
green="\033[1;32m" # Green
red="\033[31m"     # Red
nc="\033[0m"       # No Color

# Поменять переменные
DOMAIN_NAME="${DOMAIN_NAME}"
share_addr=nas-2."${DOMAIN_NAME}"
smb_share1=share1
smb_share2=share2
admin_login=login
admin_pass=pass
proxy_hostname=123

# Добавляем прокси
cat <<EOF >/etc/apt/apt.conf.d/05proxy
Acquire::https::Proxy "http://"${proxy_hostname}"."${DOMAIN_NAME}":8080/";
Acquire::http::Proxy "http://"${proxy_hostname}"."${DOMAIN_NAME}":8080/";
Acquire::ftp::Proxy "ftp://"${proxy_hostname}"."${DOMAIN_NAME}":8080/";
Acquire::::Proxy "true";
EOF

# Раскоментируем репы
sed -i 's/^#//' /etc/apt/sources.list

# Закоментируем cdrom и devel
sed -i '/cdrom/s/^/#/' /etc/apt/sources.list
sed -i '/devel/s/^/#/' /etc/apt/sources.list

# okularGOst
echo "deb http://packages.lab50.net/okular alse18 main non-free" >/etc/apt/sources.list.d/okulargost.list
cp "${dir}"/lab50.gpg /etc/apt/trusted.gpg.d/lab50.gpg
chmod 0644 /etc/apt/trusted.gpg.d/lab50.gpg

# Обновляем систему
if ! apt-get update; then
    echo -e "${red} Не удалось обновить список пакетов!${nc}"
    exit 1
fi

astra-update -A -r -T

# Устанавливаем autofs cifs-utils
apt install autofs cifs-utils -y

# Cоздаем файл auto.share
echo ""${smb_share1}"   -fstype=cifs,sec=krb5,vers=2.0,multiuser,cruid=\$USER,domain="${DOMAIN_NAME}" ://"${share_addr}"/"${smb_share1}"" >/etc/auto.share
#echo "${smb_share2}   -fstype=cifs,sec=krb5,multiuser,cruid=\$UID,domain="${DOMAIN_NAME}" ://"${share_addr}"/"${smb_share2}"" >>/etc/auto.share

# Делаем маску 644
chmod 644 /etc/auto.share

# В файл /etc/auto.master добавляем параметры куда монтировать
grep -q "^/mnt/.* /etc/auto.share browse$" "/etc/auto.master" || echo "/mnt/    /etc/auto.share browse" >>"/etc/auto.master"

# Запускаем и добавляем в автозапуск autofs
systemctl enable autofs --now

# sudoers
echo "%astra_sudoers ALL=(ALL:ALL) ALL" >>/etc/sudoers

# Яндекс
mkdir -p /etc/opt/yandex/browser/policies/managed/
cd /etc/opt/yandex/browser/policies/managed/
echo "{
  "AuthServerAllowlist": "*."${DOMAIN_NAME}",[*.]"${DOMAIN_NAME}":*",
  "AuthNegotiateDelegateAllowlist": "*."${DOMAIN_NAME}"",
  "AuthSchemes": "ntlm,negotiate",
  "ProxyMode": "fixed_servers",
  "ProxyServer": ""${proxy_hostname}"."${DOMAIN_NAME}":8080",
  "ProxyBypassList": "*."${DOMAIN_NAME}""
}
" >"${DOMAIN_NAME}".json

# Назначение браузера яндекс по умолчанию
echo "if ! [ $(xdg-settings get default-web-browser | grep yandex) ]; then xdg-settings set default-web-browser yandex-browser.desktop
fi" >>/etc/skel/.bashrc

apt install yandex-browser-stable -y

# Для нормальной работы с usb носителями

# КриптоПро
# Пакеты зависят друг от друга, поэтому должны устанавливаться по порядку с учётом этих зависимостей

# Обязательные пакеты
# 1 - Базовый пакет КриптоПро CSP
# 2 - Модуль поддержки основных приложений, считывателей и ДСЧ
# 3 - Провайдер класса КС1
# 4 - CAPILite, программы и библиотеки для высокоуровневой работы с криптографией (сертификатами, CMS...)
apt install -y "${dir}"/CryptoPro_R3_deb/lsb-cprocsp-base_5.0.13000-7_all.deb \
    "${dir}"/CryptoPro_R3_deb/lsb-cprocsp-rdr-64_5.0.13000-7_amd64.deb \
    "${dir}"/CryptoPro_R3_deb/lsb-cprocsp-kc1-64_5.0.13000-7_amd64.deb \
    "${dir}"/CryptoPro_R3_deb/lsb-cprocsp-capilite-64_5.0.13000-7_amd64.deb

# Дополнительные пакеты
# 1 - Пакет для работы Curl с поддержкой российских алгоритмов
# 2 - Корневые сертификаты доверенных ЦС (сертификат Минцифры присутствует)
# 3 - Графический интерфейс для диалоговых операций
# 4 - Графическое приложение для доступа к основным функциям и настройкам КриптоПро CSP
# 5 - Модули поддержки PCSC-считывателей, смарт-карт
# 6 - Модуль поддержки PKCS#11
apt install -y "${dir}"/CryptoPro_R3_deb/cprocsp-curl-64_5.0.13000-7_amd64.deb \
    "${dir}"/CryptoPro_R3_deb/lsb-cprocsp-ca-certs_5.0.13000-7_all.deb \
    "${dir}"/CryptoPro_R3_deb/cprocsp-rdr-gui-gtk-64_5.0.13000-7_amd64.deb \
    "${dir}"/CryptoPro_R3_deb/cprocsp-cptools-gtk-64_5.0.13000-7_amd64.deb \
    "${dir}"/CryptoPro_R3_deb/cprocsp-rdr-pcsc-64_5.0.13000-7_amd64.deb \
    "${dir}"/CryptoPro_R3_deb/lsb-cprocsp-pkcs11-64_5.0.13000-7_amd64.deb

# Поддержка ключевых носителей
# 1 - Модуль поддержки смарт-карт и токенов Рутокен
# 2 - Модуль поддержки смарт-карт и токенов JaCarta
# 3 - Модуль поддержки ключей PKCS#11
apt install -y "${dir}"/CryptoPro_R3_deb/cprocsp-rdr-rutoken-64_5.0.13000-7_amd64.deb \
    "${dir}"/CryptoPro_R3_deb/cprocsp-rdr-jacarta-64_5.0.13000-7_amd64.deb \
    "${dir}"/CryptoPro_R3_deb/cprocsp-rdr-cryptoki-64_5.0.13000-7_amd64.deb

# Пакет с инструментарием разработчика для создания клиентских и серверных приложений для работы с ЭП
# (в соответствии с CAdES) с использованием российских криптографических алгоритмов
# Пакет для работы КриптоПро ЭЦП Browser plug-in
apt install -y "${dir}"/CryptoPro_R3_deb/cprocsp-pki-cades-64_2.0.15000-1_amd64.deb \
    "${dir}"/CryptoPro_R3_deb/cprocsp-pki-plugin-64_2.0.15000-1_amd64.deb

# Установка Okular_Gost
apt install -y okular-csp

# Установка дополнительных пакетов
apt install -y "${dir}"/install_deb/*

# KRDC
apt install krdc -y

# Ввод в домен
DEBIAN_FRONTEND=noninteractive apt install -y astra-ad-sssd-client
astra-ad-sssd-client -d ${DOMAIN_NAME} -u ${admin_login} -p ${admin_pass} -sn -y

# Монтирование usb носителей
sed -i '17i\auth\toptional\t\t\tpam_group.so' /etc/pam.d/common-auth
echo -e "\n*;*;*;Al0000-2400;floppy" >>/etc/security/group.conf

#reboot
