#!/bin/bash

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
LOG_FILE="$PROJECT_DIR/output/monitoring.log"
REPORT_FILE="$PROJECT_DIR/output/laporan.txt"

if [ ! -f "$LOG_FILE" ]; then
    echo "File monitoring.log tidak ditemukan."
    exit 1
fi

{
    echo "LAPORAN SISTEM ANTREAN PEKERJAAN DAN MONITORING PROSES LINUX"
    echo "============================================================"
    echo "Tanggal laporan: $(date)"
    echo ""
    echo "RINGKASAN KEGIATAN"
    echo "1. Monitoring penggunaan CPU."
    echo "2. Monitoring penggunaan RAM."
    echo "3. Monitoring proses Linux."
    echo "4. Pengaturan hak akses user dan group."
    echo "5. Pengujian Docker read-only."
    echo ""
    echo "HASIL MONITORING"
    echo "Berikut riwayat hasil monitoring sistem:"
    echo ""
    cat "$LOG_FILE"
    echo ""
    echo "============================================================"
    echo "Laporan berhasil dibuat."
} > "$REPORT_FILE"

echo "Laporan berhasil dibuat: $REPORT_FILE"
