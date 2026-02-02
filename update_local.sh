#!/bin/bash

# chmod +x update_local.sh
# ./update_local.sh
# wget -qO- https://raw.githubusercontent.com/ksandric/hamster-bot/refs/heads/master/update_local.sh | bash

# Определяем текущую папку сервиса
SERVICE_FOLDER=$(basename "$(dirname "$(readlink -f "$0")")")
# Ищем .service-файл, содержащий упоминание SERVICE_FOLDER
SERVICE_NAME=$(grep -l "/opt/$SERVICE_FOLDER/" /usr/lib/systemd/system/*.service 2>/dev/null | xargs basename 2>/dev/null | sed 's/\.service$//')
# Цвета и форматирование
COLOR_RESET='\033[0m'
COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_YELLOW='\033[0;33m'
COLOR_BLUE='\033[0;34m'
COLOR_CYAN='\033[0;36m'
COLOR_BOLD='\033[1m'

TOTAL_STEPS=6
CURRENT_STEP=0

print_header() {
    echo -e "${COLOR_BOLD}${COLOR_CYAN}========================================${COLOR_RESET}"
    echo -e "${COLOR_BOLD}${COLOR_CYAN}$1${COLOR_RESET}"
    echo -e "${COLOR_BOLD}${COLOR_CYAN}========================================${COLOR_RESET}"
}

print_step() {
    CURRENT_STEP=$((CURRENT_STEP + 1))
    echo -e "${COLOR_BLUE}[${CURRENT_STEP}/${TOTAL_STEPS}]${COLOR_RESET} ${COLOR_BOLD}$1${COLOR_RESET}"
}

print_ok() {
    echo -e "${COLOR_GREEN}✔${COLOR_RESET} $1"
}

print_warn() {
    echo -e "${COLOR_YELLOW}⚠${COLOR_RESET} $1"
}

print_error() {
    echo -e "${COLOR_RED}❌ $1${COLOR_RESET}"
}

# Проверяем, найден ли сервис
if [ -z "$SERVICE_NAME" ]; then
    print_error "Ошибка: Не найден .service-файл для папки '$SERVICE_FOLDER' в /usr/lib/systemd/system/"
    exit 1
fi

print_header "🔄 Обновление сервиса: $SERVICE_NAME.service"
echo -e "${COLOR_CYAN}Папка:${COLOR_RESET} /opt/$SERVICE_FOLDER/"

print_step "Остановка сервиса"
sudo systemctl stop $SERVICE_NAME.service
print_ok "Сервис остановлен"

cd /opt/$SERVICE_FOLDER/
print_step "Скачивание новой версии бота"
yes | wget -O /opt/$SERVICE_FOLDER/new_ver.zip https://raw.githubusercontent.com/ksandric/hamster-bot/refs/heads/master/hb_linux-x64.zip
print_ok "Архив скачан"
print_step "Распаковка архива с заменой файлов"
yes | sudo apt install unzip
yes A | unzip -u new_ver.zip -x settings_program.json
print_ok "Файлы обновлены"
print_step "Удаление файла архива"
rm -rf new_ver.zip
chmod +x ./hb_c
print_ok "Архив удалён"
print_step "Рестарт сервиса (бота): $SERVICE_NAME.service"
sudo systemctl restart $SERVICE_NAME.service
print_ok "Готово!"
print_header "Log"
sudo journalctl --follow -u $SERVICE_NAME.service