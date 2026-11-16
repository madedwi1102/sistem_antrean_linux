# Kontribusi Anggota 2 - Antrean dan Lock

## Deskripsi
Bagian ini mengimplementasikan sistem antrean pekerjaan
menggunakan Bash pada Linux.

## Daftar File
- worker.sh: mengambil dan memproses pekerjaan dari antrean.
- tambah_antrean.sh: menambahkan pekerjaan ke antrean.
- pekerjaan_dummy.sh: simulasi pelaksanaan pekerjaan.
- antrean.txt: penyimpanan daftar pekerjaan.
- worker.lock: file lock untuk sinkronisasi akses antrean.
- logs/: bukti hasil pengujian.

## Mekanisme FIFO
Worker mengambil pekerjaan dari baris pertama antrean.
Pekerjaan dihapus dari antrean setelah berhasil dijalankan.
Dengan demikian, pekerjaan diproses berdasarkan urutan masuk
(First In, First Out).

## Mekanisme Lock
Worker dan tambah_antrean.sh menggunakan file worker.lock
yang sama untuk menyinkronkan akses ke antrean.

Worker menggunakan flock non-blocking. Jika worker lain
sedang memegang lock, worker berikutnya akan ditolak.

Penambahan pekerjaan menggunakan flock exclusive blocking,
sehingga proses penambahan menunggu sampai lock dilepas.

## Keamanan File
Program menggunakan umask 077 dan chmod 600 untuk membatasi
akses file antrean kepada pemiliknya.

## Penanganan Kegagalan
Jika pekerjaan gagal dijalankan, worker menghentikan proses
dan pekerjaan tersebut tetap disimpan dalam antrean.

## Pengujian
Pengujian dilakukan untuk memeriksa:
1. Urutan pemrosesan pekerjaan menggunakan FIFO.
2. Keberhasilan worker pertama memperoleh lock.
3. Penolakan worker kedua ketika lock sedang digunakan.
4. Penambahan pekerjaan menunggu sampai lock dilepas.
5. Pekerjaan yang gagal tetap tersimpan dalam antrean.
6. Permission file antrean menggunakan chmod 600.

Bukti keluaran pengujian disimpan di folder logs/.

## Catatan Integrasi
Modul ini merupakan kontribusi Anggota 2.
Integrasi dengan modul anggota lain dilakukan pada tahap
penggabungan sistem kelompok.
