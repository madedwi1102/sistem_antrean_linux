
#!/bin/bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
JOB_DIR="$BASE_DIR/data/jobs"

mkdir -p "$JOB_DIR"

# Validasi ID pekerjaan
valid_id() {
    [[ "$1" =~ ^[a-zA-Z0-9_-]+$ ]]
}

# Menyimpan data status secara atomik
save_status() {
    local id="$1"
    local status="$2"
    local pid="$3"
    local exit_code="$4"

    local file="$JOB_DIR/$id.status"
    local temp="$JOB_DIR/.$id.$$.tmp"

    {
        echo "JOB_ID=$id"
        echo "STATUS=$status"
        echo "PID=$pid"
        echo "EXIT_STATUS=$exit_code"
        echo "UPDATED_AT=$(date '+%Y-%m-%d %H:%M:%S')"
    } > "$temp" || return 1

    mv -f "$temp" "$file"
}

case "$1" in

    init)
        if ! valid_id "$2"; then
            echo "ID pekerjaan tidak valid"
            exit 1
        fi

        save_status "$2" "waiting" "-" "-"
        echo "Pekerjaan $2 masuk antrean."
        ;;

    start)
        if ! valid_id "$2" || [[ ! "$3" =~ ^[0-9]+$ ]]; then
            echo "Parameter tidak valid"
            exit 1
        fi

        save_status "$2" "running" "$3" "-"
        echo "Pekerjaan $2 sedang berjalan. PID: $3"
        ;;

    finish)
        if ! valid_id "$2" || [[ ! "$3" =~ ^[0-9]+$ ]]; then
            echo "Parameter tidak valid"
            exit 1
        fi

        file="$JOB_DIR/$2.status"

        if [[ ! -f "$file" ]]; then
            echo "Data pekerjaan tidak ditemukan"
            exit 1
        fi

        pid=$(awk -F= '$1=="PID" {print $2}' "$file")

        if [[ "$3" -eq 0 ]]; then
            status="success"
        else
            status="failed"
        fi

        save_status "$2" "$status" "$pid" "$3"
        echo "Pekerjaan $2 selesai dengan status: $status"
        ;;

    show)
        if ! valid_id "$2"; then
            echo "ID pekerjaan tidak valid"
            exit 1
        fi

        file="$JOB_DIR/$2.status"

        if [[ -f "$file" ]]; then
            echo "===== STATUS PEKERJAAN ====="
            cat "$file"
        else
            echo "Pekerjaan tidak ditemukan"
            exit 1
        fi
        ;;

    *)
        echo "Penggunaan:"
        echo "$0 init JOB_ID"
        echo "$0 start JOB_ID PID"
        echo "$0 finish JOB_ID EXIT_STATUS"
        echo "$0 show JOB_ID"
        exit 1
        ;;
esac


