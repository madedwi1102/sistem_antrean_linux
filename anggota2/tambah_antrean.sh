#!/bin/bash

DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR" || exit 1

ANTRIAN="antrean.txt"
LOCK="worker.lock"

umask 077

if [ -z "$1" ]; then
    echo "ERROR: Nama pekerjaan harus diisi."
    exit 1
fi

PEKERJAAN="$1"

exec 9>"$LOCK"

if ! flock -x 9; then
    echo "ERROR: Gagal mendapatkan lock."
    exit 1
fi

if [ ! -f "$ANTRIAN" ]; then
    touch "$ANTRIAN" || exit 1
fi

chmod 600 "$ANTRIAN" || exit 1

if ! printf '%s\n' "$PEKERJAAN" >> "$ANTRIAN"; then
    echo "ERROR: Gagal menambahkan pekerjaan."
    exit 1
fi

chmod 600 "$ANTRIAN" || exit 1

echo "Berhasil menambahkan: $PEKERJAAN"
