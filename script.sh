ubuntu@sysadmin-host:~$ cat script.sh
#!/bin/bash
# Версия 1.1: добавлена проверка прав на запись в лог
# script.sh — мониторинг ресурсов системы
# Раз в N секунд снимает free -h, df -h, uptime и дописывает в monitor.log
# Использование: bash script.sh

set -euo pipefail

INTERVAL=5
LOG_FILE="monitor.log"

for cmd in free df uptime; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Ошибка: команда '$cmd' не найдена в системе" >&2
        exit 1
    fi
done

if [ ! -f "$LOG_FILE" ]; then
    touch "$LOG_FILE"
    echo "Создан новый лог-файл: $LOG_FILE"
fi

if [ ! -w "$LOG_FILE" ]; then
    echo "Ошибка: нет прав на запись в $LOG_FILE" >&2
    exit 1
fi

echo "Мониторинг запущен. Интервал: ${INTERVAL}с. Лог: ${LOG_FILE}"
echo "Для остановки нажми Ctrl+C"

while true; do
    {
        echo "--- $(date '+%Y-%m-%d %H:%M:%S') ---"
        free -h
        df -h
        uptime
    } >> "$LOG_FILE"

    echo "Снимок добавлен в $LOG_FILE"
    sleep "$INTERVAL"
done









