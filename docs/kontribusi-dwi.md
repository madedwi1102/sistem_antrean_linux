# Dokumentasi Monitoring dan Pengujian Sistem

## 1. Monitoring Sistem Linux

Monitoring dilakukan untuk melihat penggunaan sumber daya sistem, meliputi:

- CPU untuk melihat penggunaan prosesor.
- RAM untuk melihat penggunaan memori.
- Proses untuk melihat program yang sedang berjalan.

Script monitoring terdapat pada file `monitoring/monitoring.sh`. Hasil monitoring ditampilkan di terminal dan disimpan secara otomatis ke `output/monitoring.log`.

## 2. Pengaturan Hak Akses

Pengaturan hak akses menggunakan group `kelompok_proyek`.

Pengujian dilakukan menggunakan dua akun:
- `anggota1` berhasil mengakses direktori proyek.
- `tamu` tidak dapat mengakses direktori karena tidak memiliki izin.

Hasil pengujian menunjukkan bahwa permission Linux dapat digunakan untuk membatasi akses pengguna sesuai dengan hak yang diberikan.

## 3. Pembuatan Laporan

Pembuatan laporan dilakukan menggunakan script `monitoring/buat_laporan.sh`.

File laporan disimpan di `output/laporan.txt` dan berisi tanggal pembuatan, daftar kontribusi, serta riwayat hasil monitoring dari `output/monitoring.log`.

Script berhasil dijalankan dan menghasilkan file laporan secara otomatis.

## 4. Pengujian Docker

Docker Engine versi 29.1.3 digunakan bersama image Alpine Linux versi `3.22`.

Pengujian dilakukan dengan menghubungkan file laporan ke dalam container menggunakan opsi `read-only`.

Hasil pengujian menunjukkan bahwa file laporan dapat dibaca, tetapi tidak dapat diubah dari dalam container. Saat dilakukan percobaan penulisan, muncul pesan `Read-only file system`.

Pengecekan checksum juga menunjukkan bahwa isi file tetap sama sebelum dan sesudah pengujian.

## 5. Kesimpulan

Monitoring sistem, pengaturan hak akses, pembuatan laporan otomatis, dan pengujian Docker read-only berhasil dijalankan. Fitur-fitur tersebut membantu memantau kondisi sistem, membatasi akses pengguna, menyimpan hasil monitoring, serta menjaga file agar tidak dapat diubah dari dalam container.
