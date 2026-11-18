# Portofolio Kontribusi dan Refleksi Individu

## 1. Identitas
- **Nama:** MADE DWI PUTRA
- **NIM:** 2510512204
- **Kelompok:** 5B (`proyek-so-5b`)
- **Judul Proyek:** Sistem Antrean Pekerjaan (*Job Queue*) Terisolasi Berbasis Bash dan Docker

## 2. Asal Proyek
- **Tautan Repository Utama:** https://github.com/username-ketua/proyek-so-5b
- **Nama Seluruh Anggota:**
  1. AGHNA BIWALAKI CHODORI (2510512177) — Pengujian & Eksekusi Antrean
  2. FATHIMAH ASRINING NURCAHYA PERTIWI (2510512199) — Anggota 2A (Penjadwalan Antrean FIFO)
  3. JENNAR IQLIMA RAKHMAN (2510512176) — Anggota 2B (Penguncian Eksklusif `flock`)
  4. MADE DWI PUTRA (2510512204) — Anggota 5 (Pemantauan Sistem, Keamanan Hak Akses, & Isolasi Docker)
  5. MUHAMMAD HAIKAL IRAWAN (2510512185) — Anggota 3 (Pelacakan PID & Status Eksekusi)
  6. MUHAMMAD RIJAL AKBAR (2510512173) — Validasi Input & Pengajuan Tiket

## 3. Kontribusi Pribadi
- **Script:** Mengembangkan dan menjalankan skrip pemantauan sistem (`scripts/monitor_report.sh`) untuk menghasilkan laporan ringkasan operasional antrean beserta nilai hash `SHA-256`.
- **Konfigurasi:** Mengatur kepemilikan direktori operasional ke grup `labqueue` dengan izin SetGID `2770` serta konfigurasi *bind mount* mode `readonly` pada kontainer Docker `alpine:3.20`.
- **Pengujian:** Melaksanakan pengujian positif dan negatif yang mencakup verifikasi integritas laporan dengan checksum `SHA-256`, pengujian penolakan akses pengguna non-grup (`guest_user`), serta pengujian penolakan modifikasi berkas di dalam volume Docker `readonly`.
- **Dokumentasi:** Menyusun dokumentasi teknis (`docs/dokumentasi_teknis.md`), skenario pengujian (`tests/README.md`), serta merapikan arsip bukti pengujian pada direktori `evidence/`.

## 4. Bukti Kontribusi
- **Berkas Skrip:** `scripts/monitor_report.sh`
- **Berkas Bukti Pengujian:**
  - `evidence/dwi-checksum-sebelum.txt`
  - `evidence/dwi-checksum-sesudah.txt`
  - `evidence/dwi-laporan-final.txt`
  - `evidence/dwi-akses.txt`
  - `evidence/dwi-docker.txt`
- **Tautan Commit / Pull Request:** https://github.com/username-dwi/proyek-so-5b/commits/main

## 5. Skenario Individu
- **Tujuan:** Memastikan integritas berkas laporan sistem menggunakan checksum `SHA-256`, membatasi akses tulis direktori kerja hanya untuk anggota grup `labqueue`, serta mencegah modifikasi bukti pengujian dari dalam kontainer Docker.
- **Langkah Positif:** Menjalankan `bash scripts/monitor_report.sh` untuk menghasilkan laporan sistem (`laporan.txt`) dan mencocokkan nilai hash `SHA-256` sebelum dan sesudah proses berjalan.
- **Langkah Negatif:**
  1. Mencoba membuat berkas di dalam direktori antrean menggunakan akun di luar grup `labqueue` (`guest_user`).
  2. Menjalankan kontainer `alpine:3.20` dengan parameter `--mount type=bind,source="$(pwd)/evidence",target=/data,readonly` lalu menjalankan `touch /data/uji_tulis.txt`.
- **Hasil:**
  - Laporan pemantauan terbentuk lengkap dengan nilai hash `SHA-256` yang konsisten.
  - Percobaan akses oleh `guest_user` ditolak sistem operasi dengan galat `Permission denied` (exit code `13`).
  - Percobaan penulisan berkas di dalam kontainer Docker ditolak dengan pesan `Read-only file system`.
- **Verifikasi:** Membandingkan nilai hash pada `evidence/dwi-checksum-sebelum.txt` dan `evidence/dwi-checksum-sesudah.txt`, serta memeriksa rekaman keluaran galat pada `evidence/dwi-akses.txt` dan `evidence/dwi-docker.txt`.

## 6. Analisis Konsep Sistem Operasi
- **Manajemen Izin Berkas & Grup (Access Control):** Penggunaan kepemilikan grup `labqueue` dan izin `2770` (SetGID) menerapkan prinsip *least privilege* pada sistem berkas Linux. Hanya pengguna di dalam grup `labqueue` yang memiliki hak baca, tulis, dan eksekusi, sementara bit SetGID memastikan setiap berkas baru di dalam direktori otomatis mewarisi grup `labqueue`.
- **Integritas Data (Cryptographic Hashing):** Penerapan `sha256sum` menjamin keutuhan data laporan operasional sehingga setiap perubahan atau kerusakan berkas dapat langsung terdeteksi.
- **Isolasi Lingkungan & Virtualisasi Tingkat OS (Containerization):** Pemasangan direktori `evidence/` ke dalam kontainer `alpine:3.20` dengan opsi `readonly` memisahkan ruang nama sistem berkas (*mount namespace*) kontainer dari *host*, sehingga proses di dalam kontainer tidak dapat mengubah ataupun menghapus data bukti pada sistem *host*.

## 7. Kendala dan Penyelesaian
- **Perbedaan Jalur Keluaran Laporan:** Perintah `cat evidence/laporan.txt` sempat menghasilkan galat `No such file or directory` karena skrip `scripts/monitor_report.sh` menyimpan laporan ke direktori `output/laporan.txt`. Penyelesaian dilakukan dengan memeriksa lokasi keluaran skrip dan menyimpan salinan laporan terverifikasi ke `evidence/dwi-laporan-final.txt`.
- **Pencarian Berkas Catatan Docker:** Pencarian berkas `docker.txt` di direktori utama gagal karena catatan pengujian tersimpan di dalam folder bukti dengan nama `evidence/dwi-docker.txt`. Penyelesaian dilakukan dengan menelusuri direktori menggunakan perintah `find . -name "*docker*"`.
- **Penghentian Sesi Shell Interaktif Docker:** Menekan `Ctrl+C` di dalam prompt kontainer Alpine (`/ #`) hanya memunculkan karakter interupsi `^C` tanpa keluar dari kontainer. Penyelesaian dilakukan dengan mengetikkan perintah `exit` untuk menutup sesi kontainer secara bersih.

## 8. Refleksi
- **Hal yang Sudah Dikuasai:** Penerapan izin direktori khusus Linux (`chmod 2770` dan `chown`), verifikasi integritas data menggunakan `sha256sum`, isolasi volume `readonly` pada Docker, serta alur kolaborasi repository menggunakan Git (*fork*, *commit*, dan *push*).
- **Hal yang Masih Perlu Dipelajari:** Otomatisasi pengujian skrip menggunakan *CI/CD pipeline* (seperti GitHub Actions) serta konfigurasi pembatasan kapabilitas kernel tingkat lanjut (*Linux capabilities* dan *seccomp*) pada kontainer Docker.
