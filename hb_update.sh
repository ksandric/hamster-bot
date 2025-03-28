#!/bin/bash

# chmod +x hb_install.sh
# ./hb_install.sh
# wget -qO- https://raw.githubusercontent.com/ksandric/hamster-bot/refs/heads/master/hb_update.sh | bash

SERVICE_NAME="hamster-bot_1"
SERVICE_FOLDER="hb"

echo "Начало обновления бота /opt/$SERVICE_FOLDER"

echo "Остановка сервиса"
sudo systemctl stop $SERVICE_NAME.service

cd /opt/$SERVICE_FOLDER
echo "Скачивание новой версии бота"
yes | wget -O /opt/$SERVICE_FOLDER/new_ver.zip https://raw.githubusercontent.com/ksandric/hamster-bot/refs/heads/master/hb_linux-x64.zip
echo "Распаковка архива с заменой файлов"
yes A | unzip -u new_ver.zip -x settings_program.json
echo "Удаление файла архива"
rm -rf new_ver.zip
chmod +x ./hb_c
echo "Запуск сервиса"
sudo systemctl restart $SERVICE_NAME.service
echo "Готово!"
echo "Log:"
sudo journalctl --follow -u $SERVICE_NAME.service