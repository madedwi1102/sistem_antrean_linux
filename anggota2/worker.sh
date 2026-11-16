#!/bin/bash

DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR" || exit 1

ANTRIAN="antrean.txt"
LOCK="worker.lock"
LOG="logs/worker.log"

# Membatasi permission file yang dibuat menjadi 600
umask 077

# Memastikan file antrean tersedia
if [ ! -f "$ANTRIAN" ]; then
    echo "ERROR: File antrean tidak ditemukan."
    exit 1
fi

# Memastikan permission antrean hanya dapat diakses pemilik
if ! chmod 600 "$ANTRIAN"; then
    echo "ERROR: Gagal mengatur permission antrean."
    exit 1
fi

# Mengambil lock secara non-blocking
exec 9>"$LOCK"

if ! flock -n 9; then
    echo "DITOLAK: Worker lain sedang memproses antrean."
    exit 1
fi

echo "Worker berhasil mendapatkan lock."
echo "Worker mulai memproses antrean."

while [ -s "$ANTRIAN" ]; do

    # Membaca pekerjaan pertama tanpa menghapusnya
    PEKERJAAN="$(head -n 1 "$ANTRIAN")"

    if [ -z "$PEKERJAAN" ]; then
        break
    fi

    echo "Mengambil: $PEKERJAAN"
    echo "$(date '+%F %T') - Memproses: $PEKERJAAN" >> "$LOG"

    # Menjalankan pekerjaan terlebih dahulu
    if ! ./pekerjaan_dummy.sh "$PEKERJAAN"; then
        echo "ERROR: $PEKERJAAN gagal dijalankan."
        echo "$(date '+%F %T') - GAGAL: $PEKERJAAN" >> "$LOG"
        echo "Pekerjaan tetap disimpan dalam antrean."
        exit 1
    fi

    # Pekerjaan baru dihapus setelah berhasil dijalankan
    TEMP="${ANTRIAN}.tmp.$$"

    if ! tail -n +2 "$ANTRIAN" > "$TEMP"; then
        echo "ERROR: Gagal membuat antrean sementara."
        rm -f "$TEMP"
        exit 1
    fi

    if ! chmod 600 "$TEMP"; then
        echo "ERROR: Gagal mengatur permission file sementara."
        rm -f "$TEMP"
        exit 1
    fi

    if ! mv "$TEMP" "$ANTRIAN"; then
        echo "ERROR: Gagal memperbarui antrean."
        rm -f "$TEMP"
        exit 1
    fi

    echo "$(date '+%F %T') - Selesai: $PEKERJAAN" >> "$LOG"

done

echo "Antrean kosong."
echo "Worker selesai."
