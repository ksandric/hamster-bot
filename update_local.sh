#!/bin/bash

# chmod +x update_local.sh
# ./update_local.sh
# wget -qO- https://raw.githubusercontent.com/ksandric/hamster-bot/refs/heads/master/update_local.sh | bash

# Определяем текущую папку сервиса
SERVICE_FOLDER=$(basename "$(dirname "$(readlink -f "$0")")")
# Ищем .service-файл, содержащий упоминание SERVICE_FOLDER
SERVICE_NAME=$(grep -l "/opt/$SERVICE_FOLDER" /usr/lib/systemd/system/*.service 2>/dev/null | xargs basename 2>/dev/null | sed 's/\.service$//')
# Проверяем, найден ли сервис
if [ -z "$SERVICE_NAME" ]; then
    echo "❌ Ошибка: Не найден .service-файл для папки '$SERVICE_FOLDER' в /usr/lib/systemd/system/"
    exit 1
fi

echo "🔄 Обновление сервиса: $SERVICE_NAME.service (папка: /opt/$SERVICE_FOLDER)"

echo "Начало обновления бота /opt/$SERVICE_FOLDER"

echo "Остановка сервиса"
sudo systemctl stop $SERVICE_NAME.service

cd /opt/$SERVICE_FOLDER
echo "Скачивание новой версии бота"
yes | wget -O /opt/$SERVICE_FOLDER/new_ver.zip https://raw.githubusercontent.com/ksandric/hamster-bot/refs/heads/master/hb_linux-x64.zip
echo "Распаковка архива с заменой файлов"
yes | sudo apt install unzip
yes A | unzip -u new_ver.zip -x settings_program.json
echo "Удаление файла архива"
rm -rf new_ver.zip
chmod +x ./hb_c
echo "Запуск сервиса"
sudo systemctl restart $SERVICE_NAME.service
echo "Готово!"
echo "Log:"
sudo journalctl --follow -u $SERVICE_NAME.service