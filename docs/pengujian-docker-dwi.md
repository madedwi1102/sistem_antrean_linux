# Dokumentasi Pengujian Docker

## 1. Tujuan
Menguji kemampuan container Docker dalam membaca laporan dari host serta memastikan container tidak dapat mengubah file melalui bind mount read-only.

## 2. Docker Image
- Image: alpine:3.22
- Docker Engine: 29.1.3

## 3. Pengujian Positif
Container berhasil membaca file `output/laporan.txt` menggunakan bind mount read-only.

Hasil: Berhasil. Isi laporan tampil di terminal.

## 4. Pengujian Negatif
Container mencoba menambahkan teks ke `output/laporan.txt`.

Hasil:
`sh: can't create /data/laporan.txt: Read-only file system`

Exit status: 1

Pengujian berhasil karena sistem menolak penulisan.

## 5. Verifikasi Checksum

Checksum sebelum pengujian:

`459ac86ad5cb668adc0f0a902e64054b5ac2e9ae0b2726a356f84fe92f728d86`

Checksum setelah pengujian:

`459ac86ad5cb668adc0f0a902e64054b5ac2e9ae0b2726a356f84fe92f728d86`

Hasil: Kedua checksum sama, sehingga file laporan pada host tidak berubah.

## 6. Kesimpulan
Pengujian Docker read-only berhasil. Container dapat membaca laporan, tetapi tidak dapat mengubah file pada direktori host yang dipasang dengan opsi read-only.
