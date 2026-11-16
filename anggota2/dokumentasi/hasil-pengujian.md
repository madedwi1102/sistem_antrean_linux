# Hasil Pengujian Anggota 2 - 5B

## 1. Pengujian FIFO
Tiga pekerjaan dimasukkan ke antrean.
Worker berhasil menjalankan pekerjaan sesuai urutan masuk.

Hasil: LULUS

## 2. Pengujian Lock
Worker pertama berhasil memperoleh lock.
Worker kedua ditolak ketika lock sedang digunakan.

Hasil: LULUS

## 3. Pengujian Pekerjaan Gagal
Pekerjaan yang gagal dijalankan tetap tersimpan
di dalam antrean.

Hasil: LULUS

## 4. Pengujian Permission
File antrean menggunakan permission 600.
Pengujian akses pengguna lain dilakukan melalui Ubuntu.

Hasil: Bukti pengujian akses dilampirkan terpisah.

## 5. Commit Kontribusi
Commit terakhir: 4d4f718
Branch: anggota-2-antrean-lock
