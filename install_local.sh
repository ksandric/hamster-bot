#!/bin/bash

# chmod +x install_local.sh
# ./install_local.sh
# wget -qO- https://raw.githubusercontent.com/ksandric/hamster-bot/refs/heads/master/install_local.sh | bash

SERVICE_FOLDER=$(basename "$(dirname "$(readlink -f "$0")")")
SERVICE_NAME=$(basename "$(dirname "$(readlink -f "$0")")")

# Функция проверки числа
is_number() {
    [[ "$1" =~ ^[0-9]+$ ]] && return 0 || return 1
}

# Функция проверки порта (быстрая и надежная)
is_port_available() {
    local port=$1
    ! (ss -tuln | grep -q ":${port}\s") && ! (nc -z 127.0.0.1 "$port" 2>/dev/null)
}

# Ввод порта с валидацией
while true; do
    read -p "Введите номер порта (80-65535): " SERVICE_PORT
    
    # Проверка на число
    if ! is_number "$SERVICE_PORT"; then
        echo "❌ Ошибка: Введите корректное число!"
        continue
    fi
    
    # Проверка диапазона
    if [ "$SERVICE_PORT" -lt 80 ] || [ "$SERVICE_PORT" -gt 65535 ]; then
        echo "❌ Ошибка: Порт должен быть между 80 и 65535"
        continue
    fi
    
    # Проверка доступности порта
    if ! is_port_available "$SERVICE_PORT"; then
        echo "❌ Ошибка: Порт $SERVICE_PORT уже занят!"
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


# Путь к JSON-файлу (можете изменить на актуальный)
JSON_FILE="settings_program.json"
# Проверяем существование файла
if [ ! -f "$JSON_FILE" ]; then
    echo "❌ Ошибка: Файл $JSON_FILE не найден!"
    exit 1
fi

# Временный файл для обработки
TMP_FILE=$(mktemp)

# Используем jq для изменения значения порта
if command -v jq &> /dev/null; then
    # Способ 1: с jq (рекомендуется)
    jq --arg port "$SERVICE_PORT" '.port = ($port | tonumber)' "$JSON_FILE" > "$TMP_FILE" && mv "$TMP_FILE" "$JSON_FILE"
    echo "✅ Порт успешно изменен на $SERVICE_PORT (использован jq)"
else
    # Способ 2: без jq (sed/awk)
    if grep -q '"port":' "$JSON_FILE"; then
        sed -i "s/\"port\":.*/\"port\": $SERVICE_PORT,/g" "$JSON_FILE"
        echo "✅ Порт успешно изменен на $SERVICE_PORT (использован sed)"
    else
        echo "❌ Ошибка: Параметр 'port' не найден в файле"
        exit 1
    fi
fi

# Проверяем результат
if grep -q "\"port\": $SERVICE_PORT" "$JSON_FILE"; then
    echo "🔍 Проверка: Новое значение порта в файле:"
    grep "\"port\":" "$JSON_FILE"
else
    echo "❌ Ошибка: Не удалось изменить порт!"
    exit 1
fi

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