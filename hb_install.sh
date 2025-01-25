#!/bin/bash

# chmod +x hb_install.sh
# ./hb_install.sh

SERVICE_NAME="hamster-bot_1"
SERVICE_FOLDER="hb"
SERVICE_PORT="80"

echo "Начало установки бота /opt/$SERVICE_FOLDER"

echo "Установка: libfreetype6, libfontconfig1, fontconfig, fail2ban"
yes | apt-get update
yes | apt-get install -y libfreetype6
yes | apt-get install -y libfontconfig1
yes | apt-get install -y fontconfig
yes | sudo timedatectl set-timezone UTC
yes | apt-get install fail2ban

mkdir -p /opt/$SERVICE_FOLDER
cd /opt/$SERVICE_FOLDER

echo "Скачать zip архив"
yes | wget -O /opt/$SERVICE_FOLDER/new_ver.zip https://github.com/ksandric/hamster-bot/blob/master/hb_linux-x64.zip?raw=true
yes | sudo apt install unzip
echo "Распаковка архива"
yes A | unzip -u new_ver.zip
echo "Удаление файла архива"
rm -rf new_ver.zip

chmod +x ./hb_c
# Создание systemd сервисного файла и его запуск
# Определение пути к сервисному файлу и скрипту
SERVICE_PATH="/usr/lib/systemd/system/$SERVICE_NAME.service"

SERVICE_CONTENT="[Unit]
Description=hamster-bot-$SERVICE_NAME
After=multi-user.target
[Service]
Environment=\"DOTNET_BUNDLE_EXTRACT_BASE_DIR=%h/.net\"
Type=simple
ExecStart=/opt/$SERVICE_FOLDER/hb_c
WorkingDirectory=/opt/$SERVICE_FOLDER
RestartSec=61
Restart=always
[Install]
WantedBy=multi-user.target"

echo "Создание сервисного файла $SERVICE_PATH"
echo "$SERVICE_CONTENT" | sudo tee $SERVICE_PATH

echo "Перезагрузка systemd"
sudo systemctl daemon-reload
echo "Включение сервиса"
sudo systemctl enable $SERVICE_NAME.service
echo "Открытие порта $SERVICE_PORT"
iptables -I INPUT -p tcp --dport $SERVICE_PORT -j ACCEPT
ufw allow $SERVICE_PORT
echo "Запуск сервиса"
sudo systemctl start $SERVICE_NAME.service
echo "Готово!"
echo "Log:"
sudo journalctl --follow -u $SERVICE_NAME.service