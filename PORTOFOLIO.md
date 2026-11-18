# Portofolio Kontribusi dan Refleksi Individu

## 1. Identitas
- **Nama:** Made Dwi Putra
- **NIM:** 2510512204
- **Kelompok:** 5B (`proyek-so-5b`)
- **Judul Proyek:** Sistem Antrean Tugas (*Job Queue*) Terisolasi Berbasis Bash dan Docker

## 2. Asal Proyek
- **Tautan Repository Utama:** https://github.com/kelompok-sistem-antrean-linux/sistem_antrean_linux
- **Anggota Kelompok:**
  1. Aghna Biwalaki Chodori (2510512177) — Pengujian & Eksekusi Antrean
  2. Fathimah Asrining Nurcahya Pertiwi (2510512199) — Penjadwalan Antrean FIFO (Anggota 2A)
  3. Jennar Iqlima Rakhman (2510512176) — Penguncian Eksklusif `flock` (Anggota 2B)
  4. Made Dwi Putra (2510512204) — Pemantauan Sistem, Keamanan Direktori, & Isolasi Docker (Anggota 5)
  5. Muhammad Haikal Irawan (2510512185) — Pelacakan PID & Status Eksekusi (Anggota 3)
  6. Muhammad Rijal Akbar (2510512173) — Validasi Input & Pengajuan Tiket

## 3. Kontribusi Pribadi
- **Skrip Pemantauan:** Membuat dan menjalankan `scripts/monitor_report.sh` untuk merekap laporan hasil kerja antrean sekaligus mengecek keaslian file laporan memakai `sha256sum`.
- **Konfigurasi Keamanan:** Mengatur izin akses folder operasional memakai grup `labqueue` dan *permission* `2770` supaya tidak sembarang pengguna bisa mengubah isi folder antrean.
- **Pengujian & Isolasi Docker:** Menyiapkan kontainer `alpine:3.20` dengan mode *mount* `readonly` pada folder `evidence/`, serta menguji penolakan akses dari pengguna luar (`guest_user`) maupun percobaan ubah file dari dalam kontainer.
- **Dokumentasi:** Melengkapi dokumen proyek seperti `tests/README.md`, `docs/dokumentasi_teknis.md`, dan merapikan arsip bukti di folder `evidence/`.

## 4. Bukti Kontribusi
- **Berkas Skrip:** `scripts/monitor_report.sh`
- **Berkas Bukti Pengujian:**
  - `evidence/dwi-checksum-sebelum.txt`
  - `evidence/dwi-checksum-sesudah.txt`
  - `evidence/dwi-laporan-final.txt`
  - `evidence/dwi-akses.txt`
  - `evidence/dwi-docker.txt`
  - **Tautan Commit / Pull Request:** https://github.com/kelompok-sistem-antrean-linux/sistem_antrean_linux/commit/e057f96f7a116ee54483d19b94f5b4243241291f

## 5. Skenario Individu
- **Tujuan:** Memastikan file laporan tidak berubah atau rusak saat diproses, membatasi akses folder kerja hanya untuk tim (`labqueue`), serta menjaga agar kontainer Docker tidak bisa mengubah data bukti di sistem utama (*host*).
- **Langkah Positif:** Menjalankan `bash scripts/monitor_report.sh` setelah antrean selesai diproses, lalu mencocokkan nilai hash SHA-256 sebelum dan sesudah proses berjalan.
- **Langkah Negatif:**
  1. Masuk sebagai pengguna luar (`guest_user`) yang bukan anggota grup `labqueue`, lalu mencoba membuat file baru di folder antrean.
  2. Menjalankan kontainer Alpine dengan *bind mount* `readonly` ke folder `evidence/`, lalu mencoba membuat file baru (`touch /data/uji_tulis.txt`) dari dalam kontainer.
- **Hasil:** Laporan berhasil dibuat dengan nilai hash yang cocok. Sementara pada pengujian negatif, akses dari `guest_user` langsung ditolak (`Permission denied`), dan percobaan tulis di Docker juga gagal (`Read-only file system`).
- **Verifikasi:** Mengecek kesamaan nilai hash di `dwi-checksum-sebelum.txt` dan `dwi-checksum-sesudah.txt`, serta menyimpan log penolakan di `dwi-akses.txt` dan `dwi-docker.txt`.

## 6. Analisis Konsep SO
- **Hak Akses & Kepemilikan Grup:** Penggunaan grup `labqueue` dan izin `2770` (SetGID) menerapkan pembatasan hak akses di Linux. Hanya anggota grup yang boleh membaca dan menulis di folder tersebut, sedangkan bit SetGID membuat file baru di dalamnya otomatis mengikuti grup `labqueue`.
- **Integritas Data:** Pengecekan checksum dengan `sha256sum` memastikan isi laporan tetap utuh dan tidak dimanipulasi.
- **Isolasi Kontainer:** Fitur *bind mount* mode `readonly` pada Docker membatasi ruang gerak sistem file di dalam kontainer, sehingga proses di dalam kontainer hanya bisa membaca data tanpa bisa merusak file asli di komputer *host*.

## 7. Kendala dan Penyelesaian
- **Lokasi file laporan berbeda:** Awalnya file `evidence/laporan.txt` tidak ditemukan saat dicek dengan `cat` karena skrip menyimpannya ke `output/laporan.txt`. Solusinya adalah mengecek isi folder `output/` lalu menyalin hasil akhirnya ke `evidence/dwi-laporan-final.txt`.
- **File catatan Docker tidak ketemu di folder utama:** Perintah `cat docker.txt` sempat gagal karena file tersebut ternyata disimpan di dalam folder `evidence/` dengan nama `dwi-docker.txt`. Masalah ini selesai setelah mencari file memakai perintah `find`.
- **Susah keluar dari terminal Docker:** Menekan `Ctrl+C` di dalam kontainer Alpine (`/ #`) hanya memunculkan tanda `^C` dan tidak menutup kontainer. Solusinya cukup mengetikkan perintah `exit` lalu menekan Enter.

## 8. Refleksi
- **Yang sudah dikuasai:** Mengatur hak akses direktori dan grup di Linux (`chmod 2770`, `chown`), mengecek integritas file dengan `sha256sum`, menjalankan isolasi volume `readonly` di Docker, serta mengelola repository Git menggunakan *fork*, *commit*, dan *push*.
- **Yang masih perlu dipelajari:** Cara mengotomatiskan pengujian skrip lewat GitHub Actions serta pengaturan keamanan kontainer Docker yang lebih mendalam seperti pembatasan hak akses *root* di dalam kontainer.
