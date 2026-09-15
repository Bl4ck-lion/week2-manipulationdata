/*
   JAWABAN TUGAS SQL A-E
   Database: employees

   Catatan:
   - Jalankan file ini pada database employees.
   - PostgreSQL menggunakan CREATE TABLE ... (LIKE ...).
   - Pada bagian B4, ganti angka 123 dengan tiga digit terakhir NIM.
   - Ganti data pribadi pada bagian B4.
*/

/* =========================================================
   BAGIAN A - SELECT
   ========================================================= */

-- A1. Sepuluh pegawai pertama
SELECT emp_no, first_name, last_name, hire_date
FROM public.employees
ORDER BY emp_no
LIMIT 10;

-- A2. Pegawai perempuan yang lahir sebelum 1 Januari 1960
SELECT emp_no, first_name, last_name, birth_date, gender
FROM public.employees
WHERE gender = 'F'
  AND birth_date < DATE '1960-01-01'
ORDER BY birth_date ASC
LIMIT 15;

-- A3. Last name diawali S dan direkrut pada tahun 1990
SELECT emp_no, first_name, last_name, hire_date
FROM public.employees
WHERE last_name LIKE 'S%'
  AND hire_date >= DATE '1990-01-01'
  AND hire_date < DATE '1991-01-01'
ORDER BY last_name, first_name;

-- A4. Sepuluh gaji tertinggi yang masih berlaku
SELECT emp_no, salary, from_date, to_date
FROM public.salaries
WHERE to_date = DATE '9999-01-01'
ORDER BY salary DESC, emp_no
LIMIT 10;

-- A5. Daftar jabatan yang berbeda
SELECT DISTINCT title
FROM public.titles
ORDER BY title;

-- Jumlah jenis jabatan
SELECT COUNT(DISTINCT title) AS jumlah_jenis_jabatan
FROM public.titles;

-- A6. Dua puluh pegawai dengan masa kerja terlama
SELECT
    emp_no,
    CONCAT(first_name, ' ', last_name) AS nama_lengkap,
    hire_date
FROM public.employees
ORDER BY hire_date ASC
LIMIT 20;


/* =========================================================
   BAGIAN B - CREATE TABLE DAN INSERT
   ========================================================= */

-- B1. Membuat tabel kerja dengan struktur identik
CREATE TABLE public.emp_lab
(LIKE public.employees INCLUDING ALL);

CREATE TABLE public.gaji_lab
(LIKE public.salaries INCLUDING ALL);

-- B2. Menyalin pegawai yang direkrut tahun 1999 atau setelahnya
-- Hasil query menunjukkan jumlah baris yang tersalin.
WITH data_tersalin AS (
    INSERT INTO public.emp_lab
        (emp_no, birth_date, first_name, last_name, gender, hire_date)
    SELECT
        emp_no, birth_date, first_name, last_name, gender, hire_date
    FROM public.employees
    WHERE hire_date >= DATE '1999-01-01'
    RETURNING emp_no
)
SELECT COUNT(*) AS baris_tersalin
FROM data_tersalin;

-- B3. Menyalin gaji milik pegawai yang terdapat pada emp_lab
INSERT INTO public.gaji_lab
    (emp_no, salary, from_date, to_date)
SELECT
    s.emp_no, s.salary, s.from_date, s.to_date
FROM public.salaries AS s
WHERE s.emp_no IN (
    SELECT e.emp_no
    FROM public.emp_lab AS e
);

-- B4. Menambahkan diri sendiri.
-- Ganti 123, tanggal lahir, nama, dan gender sesuai data pribadi.
INSERT INTO public.emp_lab
    (emp_no, birth_date, first_name, last_name, gender, hire_date)
VALUES
    (900000 + 123,
     DATE '2004-05-20',
     'NamaDepan',
     'NamaBelakang',
     'M',
     CURRENT_DATE);

-- B5. Menambahkan tiga pegawai fiktif sekaligus
INSERT INTO public.emp_lab
    (emp_no, birth_date, first_name, last_name, gender, hire_date)
VALUES
    (900001, DATE '1998-01-10', 'Fiksi', 'Satu', 'M', DATE '2020-01-01'),
    (900002, DATE '1997-02-20', 'Fiksi', 'Dua',  'M', DATE '2021-01-01'),
    (900003, DATE '1996-03-30', 'Fiksi', 'Tiga', 'M', DATE '2022-01-01');

-- B6. Menambahkan gaji untuk pegawai sendiri
INSERT INTO public.gaji_lab
    (emp_no, salary, from_date, to_date)
VALUES
    (900000 + 123, 70000, CURRENT_DATE, DATE '9999-01-01');


/* =========================================================
   BAGIAN C - UPDATE DAN TRANSAKSI
   ========================================================= */

-- C1. Mengubah last_name sendiri menjadi huruf kapital
UPDATE public.emp_lab
SET last_name = UPPER(last_name)
WHERE emp_no = 900000 + 123;

-- C2. Menaikkan gaji aktif di bawah 50.000 sebesar 10 persen
-- Hasil query menunjukkan jumlah baris yang terpengaruh.
WITH data_diubah AS (
    UPDATE public.gaji_lab
    SET salary = ROUND(salary * 1.10)::INTEGER
    WHERE to_date = DATE '9999-01-01'
      AND salary < 50000
    RETURNING emp_no
)
SELECT COUNT(*) AS jumlah_baris_terpengaruh
FROM data_diubah;

-- C3. Mengubah gender pegawai fiktif menjadi F
UPDATE public.emp_lab
SET gender = 'F'
WHERE emp_no IN (900001, 900002, 900003);

-- C4. Kenaikan gaji berjenjang untuk gaji yang masih berlaku
UPDATE public.gaji_lab
SET salary = (
    CASE
        WHEN salary < 60000
            THEN ROUND(salary * 1.08)
        WHEN salary BETWEEN 60000 AND 79999
            THEN ROUND(salary * 1.05)
        ELSE ROUND(salary * 1.02)
    END
)::INTEGER
WHERE to_date = DATE '9999-01-01';

-- C5. Menguji transaksi dan rollback
START TRANSACTION;

UPDATE public.emp_lab
SET first_name = 'TEST';

SELECT COUNT(*) AS jumlah_test_sebelum_rollback
FROM public.emp_lab
WHERE first_name = 'TEST';

ROLLBACK;

SELECT COUNT(*) AS jumlah_test_setelah_rollback
FROM public.emp_lab
WHERE first_name = 'TEST';

-- Setelah ROLLBACK, perubahan first_name = 'TEST' dibatalkan.


/* =========================================================
   BAGIAN D - DELETE
   ========================================================= */

-- D1. Jumlah baris sebelum penghapusan
SELECT COUNT(*) AS jumlah_sebelum_penghapusan
FROM public.emp_lab;

-- D2. Menghapus pegawai fiktif
DELETE FROM public.emp_lab
WHERE emp_no IN (900001, 900002, 900003);

-- D3. Menghapus gaji yang sudah tidak berlaku
-- Hasil query menunjukkan jumlah baris yang terhapus.
WITH data_dihapus AS (
    DELETE FROM public.gaji_lab
    WHERE to_date <> DATE '9999-01-01'
    RETURNING emp_no
)
SELECT COUNT(*) AS jumlah_gaji_terhapus
FROM data_dihapus;

-- D4. Menghapus pegawai tanpa satu pun baris gaji
DELETE FROM public.emp_lab AS e
WHERE NOT EXISTS (
    SELECT 1
    FROM public.gaji_lab AS g
    WHERE g.emp_no = e.emp_no
);

-- D5. Jumlah baris setelah penghapusan
SELECT COUNT(*) AS jumlah_setelah_penghapusan
FROM public.emp_lab;


/* =========================================================
   BAGIAN E - AGGREGATE DAN JOIN
   ========================================================= */

-- E1a. Jumlah total pegawai
SELECT COUNT(*) AS total_pegawai
FROM public.employees;

-- E1b. Jumlah pegawai berdasarkan gender
SELECT gender, COUNT(*) AS jumlah_pegawai
FROM public.employees
GROUP BY gender
ORDER BY gender;

-- E2. Statistik gaji yang masih berlaku
SELECT
    ROUND(AVG(salary), 2) AS gaji_rata_rata,
    MAX(salary) AS gaji_tertinggi,
    MIN(salary) AS gaji_terendah,
    SUM(salary) AS total_gaji
FROM public.salaries
WHERE to_date = DATE '9999-01-01';

-- E3. Jumlah pegawai aktif per departemen
SELECT
    d.dept_no,
    d.dept_name,
    COUNT(DISTINCT de.emp_no) AS jumlah_pegawai_aktif
FROM public.departments AS d
JOIN public.dept_emp AS de
    ON de.dept_no = d.dept_no
WHERE de.to_date = DATE '9999-01-01'
GROUP BY d.dept_no, d.dept_name
ORDER BY jumlah_pegawai_aktif DESC;

-- E4. Statistik pegawai dan gaji aktif per departemen
SELECT
    d.dept_name,
    COUNT(DISTINCT de.emp_no) AS jumlah_pegawai,
    ROUND(AVG(s.salary), 2) AS gaji_rata_rata,
    MAX(s.salary) AS gaji_tertinggi,
    MIN(s.salary) AS gaji_terendah
FROM public.departments AS d
JOIN public.dept_emp AS de
    ON de.dept_no = d.dept_no
JOIN public.salaries AS s
    ON s.emp_no = de.emp_no
WHERE de.to_date = DATE '9999-01-01'
  AND s.to_date = DATE '9999-01-01'
GROUP BY d.dept_no, d.dept_name
ORDER BY gaji_rata_rata DESC;

-- Untuk mencatat waktu eksekusi E4, lihat nilai Execution Time.
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    d.dept_name,
    COUNT(DISTINCT de.emp_no) AS jumlah_pegawai,
    ROUND(AVG(s.salary), 2) AS gaji_rata_rata,
    MAX(s.salary) AS gaji_tertinggi,
    MIN(s.salary) AS gaji_terendah
FROM public.departments AS d
JOIN public.dept_emp AS de
    ON de.dept_no = d.dept_no
JOIN public.salaries AS s
    ON s.emp_no = de.emp_no
WHERE de.to_date = DATE '9999-01-01'
  AND s.to_date = DATE '9999-01-01'
GROUP BY d.dept_no, d.dept_name
ORDER BY gaji_rata_rata DESC;

-- E5. Departemen dengan gaji rata-rata di atas 60.000
SELECT
    d.dept_name,
    COUNT(DISTINCT de.emp_no) AS jumlah_pegawai,
    ROUND(AVG(s.salary), 2) AS gaji_rata_rata,
    MAX(s.salary) AS gaji_tertinggi,
    MIN(s.salary) AS gaji_terendah
FROM public.departments AS d
JOIN public.dept_emp AS de
    ON de.dept_no = d.dept_no
JOIN public.salaries AS s
    ON s.emp_no = de.emp_no
WHERE de.to_date = DATE '9999-01-01'
  AND s.to_date = DATE '9999-01-01'
GROUP BY d.dept_no, d.dept_name
HAVING AVG(s.salary) > 60000
ORDER BY gaji_rata_rata DESC;

-- E6. Jumlah pemegang jabatan dan rata-rata gaji aktifnya
WITH pemegang_jabatan AS (
    SELECT DISTINCT emp_no, title
    FROM public.titles
)
SELECT
    p.title,
    COUNT(*) AS jumlah_pemegang,
    ROUND(AVG(s.salary), 2) AS gaji_rata_rata
FROM pemegang_jabatan AS p
JOIN public.salaries AS s
    ON s.emp_no = p.emp_no
WHERE s.to_date = DATE '9999-01-01'
GROUP BY p.title
HAVING COUNT(*) > 10000
ORDER BY jumlah_pemegang DESC;

