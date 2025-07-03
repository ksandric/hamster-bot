#!/bin/bash

# chmod +x hb_install.sh
# ./hb_install.sh
# wget -qO- https://raw.githubusercontent.com/ksandric/hamster-bot/refs/heads/master/hb_install.sh | bash

SERVICE_FOLDER=$(basename "$(dirname "$(readlink -f "$0")")")
SERVICE_NAME=$(basename "$(dirname "$(readlink -f "$0")")")

# Функция проверки, является ли ввод числом
is_number() {
    local num=$1
    [[ "$num" =~ ^[0-9]+$ ]]
}

# Функция проверки занятости порта
is_port_used() {
    local port=$1
    (echo >/dev/tcp/localhost/$port) &>/dev/null
    return $?
}

# Запрашиваем порт с проверками
while true; do
    read -p "Введите номер порта (80-65535): " SERVICE_PORT
    
    # Проверка на число
    if ! is_number "$SERVICE_PORT"; then
        echo "❌ Ошибка: Введите корректное число!"
        continue
    fi
    
    # Проверка диапазона
    if [ "$PORT" -lt 80 ] || [ "$SERVICE_PORT" -gt 65535 ]; then
        echo "❌ Ошибка: Порт должен быть в диапазоне 80-65535"
        continue
    fi
    
    # Проверка занятости порта
    if is_port_used "$SERVICE_PORT"; then
        echo "❌ Ошибка: Порт $SERVICE_PORT уже занят другим приложением"
        continue
    fi
    
    break
done

echo "✅ Выбран свободный порт: $SERVICE_PORT"
echo "🔄 Установка сервиса: $SERVICE_NAME (папка: /opt/$SERVICE_FOLDER)"
echo "Установка: unzip, libfreetype6, libfontconfig1, fontconfig, fail2ban"
yes | apt-get update
yes | sudo apt install unzip
yes | apt-get install -y libfreetype6
yes | apt-get install -y libfontconfig1
yes | apt-get install -y fontconfig
yes | sudo timedatectl set-timezone UTC
yes | apt-get install fail2ban

mkdir -p /opt/$SERVICE_FOLDER
cd /opt/$SERVICE_FOLDER

echo "Скачать zip архив"
yes | wget -O /opt/$SERVICE_FOLDER/new_ver.zip https://raw.githubusercontent.com/ksandric/hamster-bot/refs/heads/master/hb_linux-x64.zip

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
sudo systemctl restart $SERVICE_NAME.service
echo "Готово!"
echo "Log:"
sudo journalctl --follow -u $SERVICE_NAME.service