---
title: "CRITIC-TOPSIS di MATLAB: memilih satu solusi dari Pareto front"
description: "Kode MATLAB untuk pembobotan objektif CRITIC dan perankingan TOPSIS, diturunkan dari persamaan (7)-(20) Li dkk. (2025)."
date: 2026-10-09
summary: "Optimasi multi-objektif memberi Anda ratusan solusi Pareto yang sama-sama valid. Skrip ini menghitung bobot kriteria dari data itu sendiri, lalu memeringkat solusinya — tanpa menebak bobot."
tags: ["MATLAB", "MCDM", "CRITIC", "TOPSIS", "optimasi multi-objektif"]
showAuthor: true
showTableOfContents: true
---

Ketika Anda menjalankan optimasi multi-objektif — misalnya MOPSO untuk
meminimalkan biaya tahunan total, emisi CO₂, dan indeks rute proses sekaligus —
hasilnya bukan satu jawaban, melainkan **Pareto front**: puluhan sampai ratusan
solusi yang tak saling mendominasi. Tidak ada satu pun di antaranya yang secara
objektif lebih baik dari yang lain, karena memperbaiki satu objektif selalu
memperburuk objektif lain.

Masalahnya, Anda tetap harus memilih satu untuk dirancang. Dan memilih "yang
kelihatannya paling seimbang" bukan jawaban yang bisa Anda pertahankan di
sidang.

Di sinilah **MCDM** (*multi-criteria decision making*) masuk. Skrip ini
menjalankan kombinasi dua metode:

- **CRITIC** menghitung **bobot** setiap kriteria **dari sebaran datanya
  sendiri** — bukan dari pendapat Anda. Kriteria yang nilainya bervariasi lebar
  antar alternatif dianggap lebih informatif, dan kriteria yang isinya hampir
  sama dengan kriteria lain dikurangi bobotnya karena informasinya tumpang
  tindih.
- **TOPSIS** memeringkat alternatif berdasarkan **jaraknya ke solusi ideal
  positif dan negatif**. Yang paling dekat ke ideal positif dan paling jauh dari
  ideal negatif menang.

Inti dari pasangan ini: **Anda tidak perlu menebak bobot.** Metode pembobotan
subjektif seperti AHP menuntut Anda memutuskan bahwa biaya "dua kali lebih
penting" daripada emisi — keputusan yang sulit dipertanggungjawabkan. CRITIC
menurunkan bobotnya dari data.

## Apa yang dikerjakan skrip ini

- Menormalkan matriks keputusan Anda, dengan tiga arah kriteria sekaligus:
  **benefit** (makin besar makin baik), **cost** (makin kecil makin baik), dan
  **intermediate** (makin dekat ke nilai target makin baik)
- Menghitung simpangan baku dan matriks korelasi antar kriteria
- Menurunkan **bobot objektif** tiap kriteria, yang jumlahnya tepat 1
- Menghitung **skor kedekatan relatif** setiap alternatif
- Mengembalikan **urutan** alternatif dari terbaik ke terburuk
- Mengembalikan seluruh **langkah antara** dalam satu struct, supaya Anda bisa
  memeriksa hasil langkah demi langkah ketika belajar atau menelusuri kesalahan

Yang **tidak** dikerjakan skrip ini:

- Tidak menjalankan optimasinya. Masukannya adalah Pareto front yang sudah ada —
  dari MOPSO, dari `gamultiobj`, atau dari daftar alternatif rancangan yang Anda
  susun manual
- Tidak menyaring solusi terdominasi. Pastikan baris-baris masukan Anda memang
  sudah non-dominated
- Tidak menghitung TAC, emisi, atau indeks apa pun. Angka-angka itu Anda
  masukkan sebagai data
- Tidak memutuskan apa pun untuk Anda. Peringkat 1 adalah usulan, bukan vonis —
  bobot CRITIC bisa saja menonjolkan kriteria yang secara rekayasa kurang
  penting, dan Anda yang harus menilainya

## Yang Anda butuhkan

| | |
|---|---|
| **Versi MATLAB** | R2016b atau lebih baru (memakai *implicit expansion*) |
| **Toolbox** | Tidak ada. Hanya `std` dan `corrcoef`, keduanya MATLAB dasar |
| **Berkas masukan** | Tidak ada. Matriks dimasukkan langsung sebagai argumen |
| **Ukuran minimum** | 3 alternatif. Dengan 2 alternatif, CRITIC tidak terdefinisi — lihat catatan di bawah |

Kalau Anda menulis sendiri versi serupa, perhatikan: memakai `corr()` alih-alih
`corrcoef()` membuat skrip Anda menuntut *Statistics and Machine Learning
Toolbox*. Di komputer laboratorium kampus, toolbox itu sering tidak terpasang.

## Unduh

<p>
<a href="/kode/critic_topsis.m" download style="display:inline-block;padding:10px 20px;border:1px solid currentColor;border-radius:8px;text-decoration:none;font-weight:600;">⬇ Unduh critic_topsis.m</a>
</p>

Berkas teks biasa, bisa Anda buka dengan editor apa pun sebelum dijalankan.
Silakan periksa isinya lebih dulu — itu kebiasaan yang baik untuk kode apa pun
yang Anda unduh dari internet, termasuk dari saya.

## Cara menjalankan

1. Simpan `critic_topsis.m` di folder kerja MATLAB Anda
2. Susun matriks keputusan: **satu baris per alternatif, satu kolom per
   kriteria**
3. Susun vektor arah kriteria: `+1` benefit, `-1` cost, `0` intermediate
4. Jalankan

Contoh dengan lima solusi Pareto dan tiga objektif yang semuanya ingin
diminimalkan:

```matlab
% Kolom: TAC (USD/tahun), emisi CO2 (ton/tahun), PRI (-)
X = [1.00e6 4200 0.95
     1.05e6 3900 1.10
     1.12e6 3700 0.88
     0.97e6 4500 1.25
     1.20e6 3500 0.80];

tipe = [-1 -1 -1];          % ketiganya cost: makin kecil makin baik

[w, Ci, urutan, rincian] = critic_topsis(X, tipe);

fprintf('Bobot CRITIC     : %.4f  %.4f  %.4f\n', w);
fprintf('Alternatif terpilih: %d (Ci = %.4f)\n', urutan(1), Ci(urutan(1)));
```

Keluaran yang Anda dapat:

```
Bobot CRITIC     : 0.2863  0.2665  0.4472
Alternatif terpilih: 3 (Ci = 0.6754)
```

Perhatikan bobotnya: PRI mendapat 0,4472 — hampir dua kali bobot emisi — bukan
karena PRI lebih penting, tetapi karena sebarannya paling informatif dan paling
tidak tumpang tindih dengan kriteria lain pada data ini. Inilah sifat CRITIC
yang harus Anda pahami sebelum memakainya: **bobotnya adalah sifat data Anda,
bukan sifat masalah rekayasanya.**

Untuk kriteria dengan arah campuran, misalnya kemurnian yang ingin dimaksimalkan
(`+1`), biaya yang ingin diminimalkan (`-1`), dan pH yang ingin sedekat mungkin
dengan 7 (`0`):

```matlab
[w, Ci, urutan] = critic_topsis(X, [1 -1 0], [NaN NaN 7.0]);
```

## Dari persamaan mana

{{< katex >}}

Setiap langkah di dalam kode ditandai dengan nomor persamaan asalnya, supaya
Anda bisa menelusurinya ke artikel sumber:

| Langkah | Persamaan | Isi |
|---|---|---|
| CRITIC 1 | (7)–(10) | Standardisasi matriks keputusan: benefit, cost, intermediate |
| CRITIC 2 | (11) | Simpangan baku setiap kriteria |
| CRITIC 3 | (12) | Koefisien korelasi antar kriteria |
| CRITIC 4 | (13) | Kuantitas informasi \(C_j = \sigma_j \sum_k \left(1-\lvert r_{jk}\rvert\right)\) |
| CRITIC 5 | (14) | Bobot objektif \(\omega_j = C_j / \sum C_j\) |
| TOPSIS 1 | (15) | Matriks keputusan terbobot |
| TOPSIS 2 | (16)–(17) | Solusi ideal positif dan negatif |
| TOPSIS 3 | (18)–(19) | Jarak Euclid ke kedua solusi ideal |
| TOPSIS 4 | (20) | Kedekatan relatif \(C_i^+ = S_i^- / (S_i^+ + S_i^-)\) |

Satu detail yang sering jadi sumber kesalahan: setelah langkah standardisasi
(persamaan 8–10), **semua kolom sudah berorientasi "makin besar makin baik"**,
berapa pun arah aslinya. Karena itulah `max` dan `min` pada persamaan (16)–(17)
berlaku seragam untuk seluruh kolom. Kalau Anda melewatkan standardisasi dan
langsung mengambil `max` sebagai ideal positif, kriteria bertipe cost akan
terbalik arahnya dan peringkatnya menjadi salah — tanpa pesan error apa pun.

## Catatan dan batasan

Tiga hal berikut sudah saya uji secara numerik, bukan dugaan.

**Kolom konstan membuat seluruh bobot menjadi NaN kalau tidak ditangani.** Bila
satu kriteria bernilai sama untuk semua alternatif, simpangan bakunya nol dan
`corrcoef` mengembalikan `NaN`. NaN itu menjalar lewat persamaan (13), sehingga
bobot **semua** kriteria menjadi NaN — termasuk kriteria yang datanya sehat.
Kode ini memperlakukan korelasi yang melibatkan kolom konstan sebagai nol,
sehingga kriteria itu mendapat bobot 0 dan sisanya tetap valid. Kalau Anda
menulis versi sendiri, ini kesalahan pertama yang perlu Anda cek.

**Dengan dua alternatif, CRITIC tidak terdefinisi.** Standardisasi min-max
membuat setiap kolom menjadi `[1;0]` atau `[0;1]`, sehingga semua pasangan
kriteria otomatis berkorelasi sempurna dan suku \((1-\lvert r\rvert)\) runtuh. Yang berbahaya:
ia runtuh ke sekitar \(10^{-16}\), **bukan nol persis**, sehingga pemeriksaan
`sum(C) == 0` lolos dan Anda mendapat bobot dari derau numerik tanpa peringatan.
Kode ini memakai ambang, bukan perbandingan dengan nol, dan memberi peringatan
eksplisit. Pakailah minimal tiga alternatif.

**Dua kriteria yang berkorelasi sempurna akan berbagi bobot.** Kalau Anda
memasukkan TAC dalam USD dan TAC dalam rupiah sebagai dua kolom, keduanya
mendapat bobot kecil yang sama dan kriteria ketiga yang independen mendapat
porsi besar. Itu perilaku CRITIC yang benar — tetapi artinya **jangan memasukkan
kriteria yang sebenarnya mengukur hal yang sama.**

Batasan lain: hasilnya bergantung pada **kumpulan alternatif yang Anda
masukkan**. Menambah atau membuang satu solusi Pareto mengubah rentang min-max,
mengubah simpangan baku, dan karenanya mengubah bobot serta peringkatnya. Ini
bukan cacat kode, melainkan sifat metode normalisasi min-max. Laporkan selalu
berapa alternatif yang Anda ikutkan.

## Lisensi dan sitasi

Kode ini berlisensi **MIT** — silakan dipakai, dimodifikasi, dan disebarkan,
untuk perkuliahan maupun penelitian. Lisensinya juga tercantum di header berkas
`.m`-nya.

Yang perlu Anda sitasi bukan kode ini, melainkan metodenya. Bila dipakai untuk
pekerjaan yang Anda publikasikan, sitasi tiga sumber ini:

- **Artikel acuan persamaannya** — Li, Z., Huang, X., Wang, L., Chen, Y., Shi,
  T., Shen, W. (2025). Sustainable and efficient separation of ternary
  multi-azeotropic mixture butanone/ethanol/water based on the intensified
  reactive extractive distillation: process design, multi-objective
  optimization, and multi-criteria decision-making. *Separation and Purification
  Technology*, 355, 129694.
  [DOI](https://doi.org/10.1016/j.seppur.2024.129694)
- **Metode CRITIC** — Diakoulaki, D., Mavrotas, G., Papayannakis, L. (1995).
  Determining objective weights in multiple criteria problems: the CRITIC
  method. *Computers & Operations Research*, 22(7), 763–770.
- **Metode TOPSIS** — Hwang, C.L., Yoon, K. (1981). *Multiple Attribute Decision
  Making: Methods and Applications*. Springer-Verlag.

Menyitasi hanya artikel 2025-nya tidak cukup: artikel itu **menerapkan** CRITIC
dan TOPSIS, tidak menciptakannya. Menyitasi sumber primer metodenya adalah
kebiasaan yang harus Anda bangun sejak Tugas Akhir.

## Menemukan masalah?

Kirim email ke **bangkit.gotama@lecturer.itk.ac.id** dengan versi MATLAB Anda,
pesan error lengkapnya, dan matriks masukan yang Anda pakai. Tanpa ketiganya
saya tidak bisa menirukan masalahnya.
