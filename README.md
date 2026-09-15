# Week 2 - Manipulasi Data PostgreSQL

Repository ini berisi penyelesaian tugas praktikum SQL PostgreSQL menggunakan database **Employees**.

## Deskripsi

Tugas ini membahas penggunaan perintah SQL untuk mengambil, menambahkan, mengubah, menghapus, dan menganalisis data pegawai serta gaji.

Database yang digunakan terdiri dari beberapa tabel utama, yaitu:

- `employees`
- `salaries`
- `titles`
- `departments`
- `dept_emp`

## Tujuan

Tujuan dari tugas ini adalah:

1. Memahami penggunaan perintah `SELECT`.
2. Membuat tabel kerja dengan struktur yang sama seperti tabel asli.
3. Menggunakan perintah `INSERT`.
4. Mengubah data menggunakan `UPDATE`.
5. Menghapus data menggunakan `DELETE`.
6. Memahami transaksi menggunakan `START TRANSACTION` dan `ROLLBACK`.
7. Menggunakan fungsi agregasi seperti `COUNT`, `AVG`, `SUM`, `MAX`, dan `MIN`.
8. Menggunakan `JOIN`, subquery, `GROUP BY`, dan `HAVING`.
9. Menganalisis data pegawai, jabatan, departemen, dan gaji.

## Materi Tugas

### Bagian A - SELECT

Bagian ini berisi query untuk:

- Menampilkan sepuluh pegawai pertama.
- Menampilkan pegawai perempuan berdasarkan tanggal lahir.
- Menampilkan pegawai dengan awalan nama belakang tertentu.
- Menampilkan sepuluh gaji tertinggi yang masih berlaku.
- Menampilkan daftar jabatan yang berbeda.
- Menampilkan pegawai dengan masa kerja terlama.

### Bagian B - INSERT

Bagian ini berisi proses:

- Membuat tabel `emp_lab` dan `gaji_lab`.
- Menyalin data pegawai menggunakan `INSERT ... SELECT`.
- Menyalin data gaji menggunakan subquery.
- Menambahkan data pribadi sebagai pegawai baru.
- Menambahkan tiga pegawai fiktif menggunakan multi-row insert.
- Menambahkan data gaji untuk pegawai baru.

### Bagian C - UPDATE dan TRANSACTION

Bagian ini membahas:

- Mengubah nama belakang menjadi huruf kapital.
- Menaikkan gaji sebesar sepuluh persen.
- Mengubah gender pegawai fiktif.
- Menerapkan kenaikan gaji bertingkat menggunakan `CASE`.
- Menguji transaksi dan membatalkan perubahan menggunakan `ROLLBACK`.

### Bagian D - DELETE

Bagian ini berisi query untuk:

- Menghitung jumlah data sebelum penghapusan.
- Menghapus pegawai fiktif.
- Menghapus data gaji yang sudah tidak berlaku.
- Menghapus pegawai yang tidak memiliki data gaji.
- Menghitung kembali jumlah data setelah penghapusan.

### Bagian E - AGGREGATE dan JOIN

Bagian ini digunakan untuk:

- Menghitung jumlah seluruh pegawai.
- Menghitung jumlah pegawai berdasarkan gender.
- Menghitung statistik gaji yang masih berlaku.
- Menampilkan jumlah pegawai aktif setiap departemen.
- Menampilkan rata-rata, gaji tertinggi, dan gaji terendah setiap departemen.
- Menampilkan departemen dengan rata-rata gaji di atas Rp60.000.
- Menampilkan jumlah pemegang jabatan dan rata-rata gajinya.

## Struktur File

```text
week2-manipulationdata/
├── README.md
└── jawaban_tugas_A-E_postgresql.sql
