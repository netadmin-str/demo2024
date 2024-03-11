#!/bin/bash
INTERFACE_NAME=`ip -o link | awk '$2 != "lo:" {print $2, $(NF-4)}' | awk -v mac=$INTERFACE_MAC '$2 == mac {print $1}'`
INTERFACE_NAME=${INTERFACE_NAME//:/}

# Проверяем существует ли папка для интерейса $INTERFACE_NAME
if [ -d "/etc/net/ifaces/$INTERFACE_NAME" ]
then
# Удаляем всю папку, чтобы создать новую со своими параметрами
rm -rf "/etc/net/ifaces/$INTERFACE_NAME"
fi

mkdir /etc/net/ifaces/$INTERFACE_NAME

# Создаем файл /etc/net/ifaces/$INTERFACE_NAME/options
echo "TYPE=eth
DISABLED=no
NM_CONTROLLED=no
BOOTPROTO=static
CONFIG_IPv4=yes" > /etc/net/ifaces/$INTERFACE_NAME/options

# Настраиваем IP на интерфейс
echo $IP_ADDRESS$IP_MASK > /etc/net/ifaces/$INTERFACE_NAME/ipv4address

# Перезапускаем сеть
systemctl restart network