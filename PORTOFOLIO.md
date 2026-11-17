# PORTOFOLIO INDIVIDU
## SISTEM ANTREAN PEKERJAAN DAN MONITORING PROSES LINUX

## 1. Identitas

- **Nama:** Made Dwi Putra
- **NIM:** 2510512204
- **Username GitHub:** madedwi1102
- **Nomor Anggota:** 5
- **Judul Proyek:** Sistem Antrean Pekerjaan dan Monitoring Proses Linux

## 2. Asal Proyek

Proyek ini merupakan tugas kelompok mata kuliah Sistem Operasi yang dikerjakan secara kolaboratif untuk membangun sistem antrean pekerjaan dan monitoring proses pada Linux.

**Repository utama kelompok:**

https://github.com/kelompok-sistem-antrean-linux/sistem_antrean_linux

**Repository pribadi:**

https://github.com/madedwi1102/sistem_antrean_linux

**Daftar Anggota Kelompok:**

1. Muhammad Rijal Akbar — Anggota 1
2. Fathimah Asrining Nurcahya Pertiwi — Anggota 2
3. Jennar Iqlima Rakhman — Anggota 2
4. Muhammad Haikal Irawan — Anggota 3
5. Aghna Biwalaki Chodori — Anggota 4
6. Made Dwi Putra — Anggota 5

## 3. Kontribusi Pribadi

Dalam proyek ini, saya bertanggung jawab pada bagian monitoring sistem Linux, pengaturan hak akses, pembuatan laporan, dan pengujian Docker.

### A. Monitoring Sistem Linux

Membuat script `monitoring/monitoring.sh` untuk memantau penggunaan CPU, RAM, dan proses yang sedang berjalan. Hasil monitoring ditampilkan di terminal dan disimpan ke dalam file `output/monitoring.log`.

Pengujian beban CPU juga dilakukan menggunakan `stress-ng` dengan metode `loop` untuk melihat perubahan penggunaan CPU melalui monitoring.

### B. Pengaturan Hak Akses

Mengatur hak akses menggunakan group `kelompok_proyek`. Pengujian dilakukan menggunakan dua akun berbeda:

- Akun `anggota1` berhasil mengakses direktori proyek.
- Akun `tamu` tidak dapat mengakses direktori karena tidak memiliki izin yang sesuai.

Pengujian ini dilakukan untuk memastikan bahwa akses terhadap direktori proyek dibatasi berdasarkan hak akses pengguna.

### C. Pembuatan Laporan

Membuat script `monitoring/buat_laporan.sh` untuk menghasilkan laporan otomatis ke dalam file `output/laporan.txt`.

Laporan berisi tanggal pembuatan, informasi pekerjaan, dan hasil monitoring sistem.

### D. Pengujian Docker

Melakukan pengujian Docker menggunakan image `alpine:3.22` pada Docker Engine versi `29.1.3`.

Pengujian menggunakan bind mount read-only agar container dapat membaca file laporan dari host, tetapi tidak dapat mengubahnya.

Hasil pengujian menunjukkan bahwa container berhasil membaca file, sedangkan percobaan menulis ditolak oleh sistem.

## 4. Bukti Kontribusi

Berikut beberapa file yang menjadi bukti hasil pengerjaan:

- `monitoring/monitoring.sh` — Script monitoring sistem.
- `monitoring/buat_laporan.sh` — Script pembuatan laporan.
- `output/monitoring.log` — Hasil pencatatan monitoring.
- `output/laporan.txt` — Hasil laporan otomatis.
- `docs/kontribusi-dwi.md` — Dokumentasi kontribusi anggota 5.
- `docs/pengujian-docker-dwi.md` — Dokumentasi pengujian Docker.

**Repository pribadi:**  
https://github.com/madedwi1102/sistem_antrean_linux

Salah satu commit yang menjadi bukti perubahan dokumentasi:

`4bbd9bd` — rename dokumentasi anggota 5 menjadi dwi.

## 5. Skenario Pengujian Individu

### A. Pengujian Monitoring

**Tujuan:** Memastikan script dapat membaca dan mencatat informasi penggunaan sumber daya sistem.

**Langkah pengujian:**
1. Menjalankan script `monitoring/monitoring.sh`.
2. Mengamati informasi CPU, RAM, dan proses yang ditampilkan.
3. Memeriksa file `output/monitoring.log`.

**Hasil:** Informasi monitoring berhasil ditampilkan dan dicatat ke dalam file log.

### B. Pengujian Hak Akses

**Tujuan:** Memastikan hanya pengguna yang memiliki izin yang dapat mengakses direktori proyek.

**Langkah pengujian:**
1. Mencoba mengakses direktori menggunakan akun `anggota1`.
2. Mencoba mengakses direktori menggunakan akun `tamu`.
3. Membandingkan hasil akses kedua akun.

**Hasil:** Akun `anggota1` berhasil mengakses direktori, sedangkan akun `tamu` ditolak.

### C. Pengujian Pembuatan Laporan

**Tujuan:** Memastikan script dapat menghasilkan laporan sistem secara otomatis.

**Langkah pengujian:**
1. Menjalankan script `monitoring/buat_laporan.sh`.
2. Memeriksa file `output/laporan.txt`.
3. Memastikan informasi laporan berhasil ditulis.

**Hasil:** File laporan berhasil dibuat dan berisi informasi yang dihasilkan oleh script.

### D. Pengujian Docker Read-Only

**Tujuan:** Memastikan container dapat membaca file dari host tanpa dapat mengubahnya.

**Langkah pengujian:**
1. Menjalankan container Alpine dengan bind mount read-only.
2. Membaca file laporan melalui container.
3. Mencoba menulis atau mengubah file melalui container.
4. Membandingkan checksum file sebelum dan sesudah pengujian.

**Hasil:** Container berhasil membaca file, tetapi percobaan penulisan ditolak dengan pesan `Read-only file system`. Nilai checksum sebelum dan sesudah pengujian tetap sama.

Checksum yang diperoleh:

`459ac86ad5cb668adc0f0a902e64054b5ac2e9ae0b2726a356f84fe92f728d86`

## 6. Analisis Konsep Sistem Operasi

Beberapa konsep Sistem Operasi yang diterapkan dalam pengerjaan bagian ini adalah:

- **Process Management:** Memantau proses yang sedang berjalan di Linux.
- **CPU Management:** Mengamati penggunaan CPU dan melakukan pengujian beban.
- **Memory Management:** Memantau penggunaan RAM.
- **Protection and Security:** Mengatur hak akses menggunakan user, group, dan permission.
- **Virtualisasi dan Isolasi:** Menggunakan Docker container dengan pembatasan akses file melalui bind mount read-only.

## 7. Kendala dan Solusi

Selama pengerjaan, terdapat beberapa kendala yang ditemukan.

- **Hak akses pengguna:** Akun `tamu` tidak dapat mengakses direktori karena belum memiliki izin. Hal ini sesuai dengan tujuan pengujian pembatasan akses.
- **Pengujian Docker:** Container tidak dapat menulis file karena direktori dipasang menggunakan opsi read-only. Pengujian ini membuktikan pembatasan penulisan berjalan dengan baik.
- **Pengujian beban CPU:** Pengujian awal menggunakan `stress-ng` mengalami kendala, kemudian berhasil dijalankan menggunakan metode `loop`.

## 8. Refleksi

Melalui pengerjaan proyek ini, saya memahami cara memantau penggunaan CPU, RAM, dan proses Linux, mengatur hak akses pengguna, serta membuat laporan menggunakan shell script. Saya juga memahami penerapan Docker dengan bind mount read-only untuk melindungi file.

Hal yang masih perlu saya pelajari adalah integrasi setiap komponen ke dalam sistem utama, serta pengujian sistem secara menyeluruh agar dapat memahami hubungan antarbagian dengan lebih baik.
