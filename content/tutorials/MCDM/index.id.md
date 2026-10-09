---
title: "GANTI: Nama Skrip MATLAB Anda"
description: "GANTI: satu baris tentang apa yang dikerjakan skrip ini."
date: 2026-10-09
summary: "GANTI: satu-dua kalimat ringkasan yang tampil di daftar tutorial."
tags: ["MATLAB", "GANTI-topik"]
showAuthor: true
showTableOfContents: true
---

<!-- ═══════════════════════════════════════════════════════════════════════
     CATATAN UNTUK BANGKIT (tidak tampil di situs):

     1. Ganti nama folder `skrip-matlab` menjadi nama skrip Anda,
        misalnya `hitung-neraca-massa`. Alamatnya nanti:
        bgotama.github.io/id/tutorials/hitung-neraca-massa/

     2. Berkas .m-nya TIDAK disimpan di folder ini. Simpan di
        static/kode/ — alasannya ada di penjelasan saya di percakapan.

     3. Ganti SEMUA tulisan GANTI: di bawah, lalu hapus blok catatan ini.

     4. Di tautan unduh, ganti nama-skrip-anda.m dengan nama berkas
        yang Anda unggah ke static/kode/.
     ═══════════════════════════════════════════════════════════════════════ -->

GANTI: satu paragraf yang menjelaskan masalah apa yang diselesaikan skrip ini,
dan siapa yang akan memakainya. Tulis untuk mahasiswa yang belum pernah melihat
kode ini — mereka harus bisa memutuskan apakah skrip ini berguna bagi mereka
hanya dari paragraf ini.

## Apa yang dikerjakan skrip ini

GANTI dengan daftar yang konkret:

- Membaca GANTI dari GANTI
- Menghitung GANTI dengan metode GANTI
- Mengeluarkan GANTI dalam bentuk GANTI

Yang **tidak** dikerjakan skrip ini: GANTI. Menyebutkan batasannya di awal
menghemat waktu Anda menjawab pertanyaan yang sama berulang kali.

## Yang Anda butuhkan

| | |
|---|---|
| **Versi MATLAB** | GANTI, mis. R2021b atau lebih baru |
| **Toolbox** | GANTI, mis. Optimization Toolbox — atau tulis "tidak ada" |
| **Berkas masukan** | GANTI, mis. data.xlsx dengan kolom A–D — atau "tidak ada" |

## Unduh

<p>
<a href="/kode/nama-skrip-anda.m" download style="display:inline-block;padding:10px 20px;border:1px solid currentColor;border-radius:8px;text-decoration:none;font-weight:600;">⬇ Unduh nama-skrip-anda.m</a>
</p>

Berkas teks biasa, bisa Anda buka dengan editor apa pun sebelum dijalankan.
Silakan periksa isinya lebih dulu — itu kebiasaan yang baik untuk kode apa pun
yang Anda unduh dari internet, termasuk dari saya.

## Cara menjalankan

1. Simpan berkasnya di satu folder bersama berkas masukan Anda
2. Buka folder itu di MATLAB (`Current Folder` harus menunjuk ke sana)
3. GANTI: perintah yang dijalankan, mis. `hasil = namaFungsi('data.xlsx');`
4. GANTI: apa yang akan Anda lihat sebagai keluaran

## Cuplikan kodenya

Bagian inti skripnya, supaya Anda tahu apa yang terjadi tanpa harus mengunduh:

```matlab
function hasil = namaFungsi(berkasMasukan)
% NAMAFUNGSI  GANTI: satu baris penjelasan.
%
%   hasil = namaFungsi(berkasMasukan) GANTI: penjelasan singkat.
%
%   Masukan:
%     berkasMasukan - GANTI
%
%   Keluaran:
%     hasil - GANTI
%
%   Contoh:
%     hasil = namaFungsi('data.xlsx');
%
%   Penulis: Bangkit Gotama, Teknik Kimia ITK
%   Lisensi: GANTI (mis. MIT)

    arguments
        berkasMasukan (1,:) char
    end

    % --- GANTI: baca masukan ---
    data = readtable(berkasMasukan);

    % --- GANTI: inti perhitungan ---
    hasil = sum(data.Kolom1) / height(data);

    fprintf('Hasil: %.4f\n', hasil);
end
```

## Catatan dan batasan

GANTI: tulis jujur apa yang belum ditangani. Misalnya asumsi yang dipakai, "belum
menangani komponen non-ideal", "belum ada penanganan error untuk kolom kosong",
"diuji hanya pada MATLAB R2023a". Pengguna yang tahu batasannya akan datang
dengan pertanyaan yang jauh lebih berguna.

## Lisensi dan sitasi

GANTI: pilih satu.

- **Bebas dipakai** — "Silakan dipakai dan dimodifikasi untuk keperluan
  perkuliahan maupun penelitian. Bila membantu pekerjaan yang Anda publikasikan,
  mohon sebutkan sumbernya."
- **Atau tulis lisensi formal** — mis. MIT, dan cantumkan juga di header berkas
  `.m`-nya, bukan hanya di halaman ini. Pengguna biasanya menyimpan berkasnya
  dan melupakan halamannya.

## Menemukan masalah?

Kirim email ke **bangkit.gotama@lecturer.itk.ac.id** dengan versi MATLAB Anda,
pesan error lengkapnya, dan berkas masukan yang Anda pakai. Tanpa ketiganya
saya tidak bisa menirukan masalahnya.
