#!/bin/bash

# chmod +x update_all.sh
# ./update_all.sh

set -u

FOUND_SERVICES=()
RUNNING_SERVICES=()

SERVICE_DIRS=(
    "/etc/systemd/system"
    "/usr/lib/systemd/system"
    "/lib/systemd/system"
)

HB_URL="https://raw.githubusercontent.com/ksandric/hamster-bot/refs/heads/master/hb_linux-x64.zip"

for dir in "${SERVICE_DIRS[@]}"; do
    [ -d "$dir" ] || continue

    while IFS= read -r service_file; do
        if grep -qE '^[[:space:]]*ExecStart=.*hb_c' "$service_file"; then
            FOUND_SERVICES+=("$(basename "$service_file")")
        fi
    done < <(find "$dir" -maxdepth 1 -type f -name "*.service" 2>/dev/null)
done

if [ ${#FOUND_SERVICES[@]} -gt 0 ]; then
    mapfile -t FOUND_SERVICES < <(printf '%s\n' "${FOUND_SERVICES[@]}" | sort -u)
fi

if [ ${#FOUND_SERVICES[@]} -eq 0 ]; then
    echo "No services found where ExecStart contains 'hb_c'."
    exit 0
fi

echo "Found services (ExecStart contains 'hb_c'):"
for i in "${!FOUND_SERVICES[@]}"; do
    echo "$((i + 1)). ${FOUND_SERVICES[$i]}"
done

for service in "${FOUND_SERVICES[@]}"; do
    if systemctl is-active --quiet "$service"; then
        RUNNING_SERVICES+=("$service")
    fi
done

if [ ${#RUNNING_SERVICES[@]} -eq 0 ]; then
    echo
    echo "No running services found among the matches."
    exit 0
fi

echo
echo "Running services:"
for i in "${!RUNNING_SERVICES[@]}"; do
    echo "$((i + 1)). ${RUNNING_SERVICES[$i]}"
done

get_service_file_path() {
    local service="$1"
    local dir

    for dir in "${SERVICE_DIRS[@]}"; do
        if [ -f "$dir/$service" ]; then
            echo "$dir/$service"
            return 0
        fi
    done

    return 1
}

extract_working_dir() {
    local service_file="$1"

    grep -E '^[[:space:]]*WorkingDirectory=' "$service_file" \
        | head -n 1 \
        | sed -E 's/^[[:space:]]*WorkingDirectory=//; s/[[:space:]]+$//; s/^"//; s/"$//'
}

resolve_download_url() {
    echo "$HB_URL"
}

echo
echo "Updating running services sequentially:"
for i in "${!RUNNING_SERVICES[@]}"; do
    service="${RUNNING_SERVICES[$i]}"

    echo
    echo "[$((i + 1))/${#RUNNING_SERVICES[@]}] Processing $service"

    service_file="$(get_service_file_path "$service")"
    if [ -z "${service_file:-}" ]; then
        echo "[$((i + 1))/${#RUNNING_SERVICES[@]}] Skip: service file not found for $service"
        continue
    fi

    working_dir="$(extract_working_dir "$service_file")"
    if [ -z "${working_dir:-}" ]; then
        echo "[$((i + 1))/${#RUNNING_SERVICES[@]}] Skip: WorkingDirectory not set in $service_file"
        continue
    fi

    if [ ! -d "$working_dir" ]; then
        echo "[$((i + 1))/${#RUNNING_SERVICES[@]}] Skip: directory does not exist: $working_dir"
        continue
    fi

    zip_url="$(resolve_download_url "$service" "$working_dir")"
    zip_path="$working_dir/new_ver.zip"

    echo "[$((i + 1))/${#RUNNING_SERVICES[@]}] WorkingDirectory: $working_dir"
    echo "[$((i + 1))/${#RUNNING_SERVICES[@]}] Download URL: $zip_url"

    echo "[$((i + 1))/${#RUNNING_SERVICES[@]}] Stopping $service"
    sudo systemctl stop "$service"

    echo "[$((i + 1))/${#RUNNING_SERVICES[@]}] Downloading archive"
    yes | wget -O "$zip_path" "$zip_url"

    echo "[$((i + 1))/${#RUNNING_SERVICES[@]}] Unpacking archive"
    yes | sudo apt install unzip
    (cd "$working_dir" && yes A | unzip -u new_ver.zip -x settings_program.json)

    echo "[$((i + 1))/${#RUNNING_SERVICES[@]}] Removing archive"
    rm -rf "$zip_path"

    if [ -f "$working_dir/hb_c" ]; then
        chmod +x "$working_dir/hb_c"
    fi

    echo "[$((i + 1))/${#RUNNING_SERVICES[@]}] Restarting $service"
    sudo systemctl restart "$service"

    echo "[$((i + 1))/${#RUNNING_SERVICES[@]}] Done: $service"
done

echo
echo "All running bot services were processed."
