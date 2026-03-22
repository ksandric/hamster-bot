#!/bin/bash

# chmod +x restart_all
# ./restart_all

set -u

FOUND_SERVICES=()
RUNNING_SERVICES=()

# 1) Find all .service files where ExecStart contains "hb_c"
SERVICE_DIRS=(
    "/etc/systemd/system"
    "/usr/lib/systemd/system"
    "/lib/systemd/system"
)

for dir in "${SERVICE_DIRS[@]}"; do
    [ -d "$dir" ] || continue

    while IFS= read -r service_file; do
        if grep -qE '^[[:space:]]*ExecStart=.*hb_c' "$service_file"; then
            FOUND_SERVICES+=("$(basename "$service_file")")
        fi
    done < <(find "$dir" -maxdepth 1 -type f -name "*.service" 2>/dev/null)
done

# Remove duplicates and sort for stable output
if [ ${#FOUND_SERVICES[@]} -gt 0 ]; then
    mapfile -t FOUND_SERVICES < <(printf '%s\n' "${FOUND_SERVICES[@]}" | sort -u)
fi

# 2) Print all found services
if [ ${#FOUND_SERVICES[@]} -eq 0 ]; then
    echo "No services found where ExecStart contains 'hb_c'."
    exit 0
fi

echo "Found services (ExecStart contains 'hb_c'):"
for i in "${!FOUND_SERVICES[@]}"; do
    echo "$((i + 1)). ${FOUND_SERVICES[$i]}"
done

# 3) Check which found services are enabled and active
for service in "${FOUND_SERVICES[@]}"; do
    if systemctl is-enabled --quiet "$service" && systemctl is-active --quiet "$service"; then
        RUNNING_SERVICES+=("$service")
    fi
done

# 4) Print the running list
if [ ${#RUNNING_SERVICES[@]} -eq 0 ]; then
    echo
    echo "No enabled and running services found among the matches."
    exit 0
fi

echo
echo "Enabled and running services:"
for i in "${!RUNNING_SERVICES[@]}"; do
    echo "$((i + 1)). ${RUNNING_SERVICES[$i]}"
done

# 5) Sequentially restart with 15-second interval
echo
echo "Restarting running services sequentially (15s interval):"
for i in "${!RUNNING_SERVICES[@]}"; do
    service="${RUNNING_SERVICES[$i]}"
    echo "[$((i + 1))/${#RUNNING_SERVICES[@]}] Restarting $service"
    sudo systemctl restart "$service"
    echo "[$((i + 1))/${#RUNNING_SERVICES[@]}] Done: $service"

    if [ "$i" -lt $((${#RUNNING_SERVICES[@]} - 1)) ]; then
        echo "Waiting 15 seconds before next restart..."
        sleep 15
    fi
done

echo
echo "All target services have been restarted."
