# PORTFOLIO INDIVIDU — PROJECT AKHIR SISTEM OPERASI (PILIHAN 5B)

## 1. Identitas
* **Nama Lengkap:** Aghnabi Walaki
* **NIM:** [Masukkan NIM Anda]
* **Kelompok:** [Masukkan Nomor Kelompok, contoh: Kelompok 1]
* **Judul Proyek:** Sistem Antrean Pekerjaan (FIFO) dan Monitoring Proses Linux (Pilihan 5B)
* **Peran / Modul Utama:** Anggota 4 — Mekanisme Batas Waktu (*Timeout*), Pengiriman Sinyal Terminasi (`SIGTERM`/`SIGKILL`), dan Logging *Timeout*.

---

## 2. Asal Proyek
* **Tautan Repository Utama:** `https://github.com/<username-ketua>/proyek-so-5b-kelompokX`
* **Daftar Anggota Kelompok:**
  1. Rizal (Anggota 1 — Pengajuan & Validasi Whitelist)
  2. Ammy & Jennar (Anggota 2A & 2B — Antrean FIFO & Exclusive Lock `flock`)
  3. Haikal (Anggota 3 — Manajemen Status, PID, & Exit Status)
  4. **Aghnabi Walaki / Abe (Anggota 4 — Timeout & Terminasi Sinyal)**
  5. Dwi (Anggota 5 — Monitoring Resource, Laporan, & Docker Read-Only)

---

## 3. Kontribusi Pribadi
Dalam proyek kelompok ini, saya bertanggung jawab penuh pada pengembangan modul yang memastikan keandalan sistem antrean dari risiko proses *hang* atau berjalan melebihi batas waktu. Kontribusi teknis saya meliputi:
1. Pembuatan script pengujian beban waktu panjang di `jobs_allowed/simulasi_lama.sh`.
2. Integrasi utilitas manajemen batas waktu (`timeout --signal=TERM --kill-after=2s`) di dalam core engine `scripts/worker.sh`.
3. Penanganan dan pemetaan kode keluar (*exit code*) khusus *timeout* (`124` untuk `SIGTERM` dan `137` untuk `SIGKILL`) ke dalam status akhir **`TIMEOUT_KILLED`**.
4. Pencatatan riwayat log sistem dan pemindahan tiket pekerjaan bermasalah secara otomatis ke direktori `queue/failed/`.
5. Penyusunan bukti dokumentasi pengujian skenario positif dan negatif serta verifikasi kebersihan proses (*zombie process check*).

---

## 4. Bukti Kontribusi
* **Branch Git Pribadi:** `feat/anggota4-timeout-signal`
* **Tautan Commit / Pull Request:** `https://github.com/<username-ketua>/proyek-so-5b-kelompokX/pull/...` (Tautan PR menuju `main`)
* **Potongan Kode Utama yang Dikerjakan (`scripts/worker.sh`):**
  ```bash
  timeout --signal=TERM --kill-after=2s "${TIMEOUT_LIMIT}s" \
      bash "$ALLOWED_JOBS_DIR/$JOB_NAME" "$PARAM" >> "$LOG_FILE" 2>&1 &
  CHILD_PID=$!
  wait "$CHILD_PID"
  EXIT_CODE=$?
  
  if [ "$EXIT_CODE" -eq 124 ] || [ "$EXIT_CODE" -eq 137 ]; then
      FINAL_STATUS="TIMEOUT_KILLED"
      mv "$QUEUE_RUN/$BASENAME" "$QUEUE_FAIL/$BASENAME"
      echo "$(date '+%F %T') | JOB_TIMEOUT | ID: $JOB_ID | PID: $CHILD_PID | Killed (> ${TIMEOUT_LIMIT}s)" >> "$LOG_FILE"
  fi
  ```

---

## 5. Skenario Individu (Timeout & Signal)
* **Tujuan Skenario:** Menguji ketahanan sistem antrean FIFO agar proses yang macet tidak memonopoli CPU dan memblokir antrean pekerjaan berikutnya.
* **Langkah Uji Positif (Selesai Normal):**
  * *Perintah:* `./scripts/submit_job.sh simulasi_lama.sh 2` lalu `./scripts/worker.sh 5`
  * *Hasil:* Pekerjaan berdurasi 2 detik selesai dengan sukses sebelum batas waktu 5 detik tercapai. Status tercatat `SUCCESS` dengan `Exit: 0`.
* **Langkah Uji Negatif (Melewati Batas Timeout):**
  * *Perintah:* `./scripts/submit_job.sh simulasi_lama.sh 10` lalu `./scripts/worker.sh 3`
  * *Hasil:* Pekerjaan berdurasi 10 detik dihentikan paksa oleh sistem tepat pada detik ke-3. Status tercatat **`TIMEOUT_KILLED`** dengan **`Exit: 124`**.
* **Verifikasi:**
  * Pengecekan tabel status via `./scripts/cek_status.sh`.
  * Pengecekan log sistem via `grep -E "JOB_RUNNING|JOB_TIMEOUT" logs/queue_system.log`.
  * Verifikasi kebersihan proses sistem menggunakan `ps aux | grep -E "PID|simulasi_lama|worker|Z"` untuk memastikan tidak ada proses *zombie/defunct* yang tertinggal.

---

## 6. Analisis Konsep Sistem Operasi
Modul yang saya kembangkan berkaitan erat dengan beberapa konsep inti Sistem Operasi:
1. **Inter-Process Communication (IPC) & Linux Signals:** Sistem penghentian proses memanfaatkan pengiriman sinyal perangkat lunak (software interrupts) dari kernel ke proses anak.
2. **Sinyal Terminasi (`SIGTERM` vs `SIGKILL`):** 
   * **`SIGTERM` (Signal 15):** Sinyal terminasi halus (*graceful termination*) yang dikirimkan terlebih dahulu agar proses anak memiliki kesempatan melakukan pembersihan sumber daya (*cleanup*).
   * **`SIGKILL` (Signal 9):** Sinyal terminasi paksa tingkat kernel yang langsung mematikan proses jika dalam batas waktu tertentu (*kill-after*) proses tidak merespons.
3. **Pencegahan Resource Starvation:** Dengan adanya batas waktu eksekusi (*timeout*), antrean FIFO di level aplikasi terhindar dari kondisi *deadlock* atau kelaparan sumber daya (*starvation*) akibat satu proses yang mengalami *infinite loop*.

---

## 7. Kendala dan Penyelesaian
* **Kendala 1:** Perbedaan utilitas bawaan antara sistem operasi host (seperti macOS/BSD) dengan Linux (GNU coreutils) di mana perintah `timeout` dan pemanggilan argumen sinyal memiliki sintaks yang berbeda.
  * *Penyelesaian:* Mewajibkan penggunaan lingkungan VM Ubuntu 24.04 (baik via WSL 2 di Windows maupun Multipass di Mac) agar seluruh perintah utilitas inti Linux berjalan konsisten dan seragam.
* **Kendala 2:** Proses anak terkadang meninggalkan status *defunct* (zombie) di tabel proses kernel saat dihentikan mendadak.
  * *Penyelesaian:* Mengonfigurasi parameter `--kill-after=2s` pada utilitas `timeout` serta memastikan perintah `wait "$CHILD_PID"` menangkap kode keluar dengan akurat sehingga proses anak dibersihkan sepenuhnya oleh kernel.

---

## 8. Refleksi Pembelajaran
* **Hal yang Sudah Dikuasai:** Saya kini menguasai pemanfaatan utilitas manajemen proses Linux, penanganan kode keluar (*exit status* POSIX standar seperti 124 dan 137), serta mekanisme pengiriman sinyal proses (`SIGTERM`/`SIGKILL`) melalui script Bash.
* **Hal yang Masih Perlu Dipelajari:** Saya ingin mendalami lebih lanjut pemrograman tingkat sistem (*system programming*) menggunakan bahasa C untuk mengimplementasikan *custom signal handler* secara mandiri tanpa bergantung pada utilitas luar seperti perintah `timeout`.