# Situs Gotama Research Group

Website pribadi/lab berbasis **Hugo + tema Blowfish**, di-hosting gratis di
**GitHub Pages**. Repo ini sudah siap tayang.

---

## 1. Menayangkan situs (sekali saja)

1. Buat akun di **github.com** (jika belum).
2. Buat repository **publik** dengan nama **persis**: `bgotama.github.io`.
3. Unggah **semua isi folder ini** ke repo tersebut
   (tombol *Add file → Upload files* → seret semua berkas → *Commit*).
4. Di repo: **Settings → Pages → Build and deployment → Source: GitHub Actions**.
5. Tunggu 1–2 menit. Buka **https://bgotama.github.io** — situs sudah hidup.

Setiap kali kamu menyimpan perubahan (*Commit*), situs otomatis dibangun ulang.

---

## 2. Yang WAJIB kamu ganti dulu

- **Email:** cari `you@itk.ac.id` di seluruh berkas, ganti dengan emailmu.
  (ada di `config/_default/languages.*.toml`, `content/join/index.md`,
  `content/contact/index.md`)
- **Foto profil:** ganti `assets/img/author.png` dengan fotomu
  (nama berkas tetap `author.png`, atau ubah `image = ...` di kedua
  `languages.*.toml`).
- **Teks About:** sunting `content/about/index.md`.

---

## 3. Cara memperbarui isi

| Ingin mengubah | Sunting berkas |
|---|---|
| Publikasi | `content/publications/_index.md` (atau pakai skrip di bawah) |
| Berita/News | tambah berkas di `content/news/` |
| Fokus riset | berkas di `content/research/` |
| Proyek | berkas di `content/projects/` |
| Tutorial (ID) | tambah folder di `content/tutorials/` berisi `index.id.md` |
| Anggota / Join us | `content/join/index.md` |

Alur universal: buka berkas di github.com → klik ✎ → ubah → *Commit* → tunggu 1 menit.

### Publikasi dari BibTeX (opsional)
1. Perbarui `publications.bib` (salin entri BibTeX dari Google Scholar/Zotero).
2. Jalankan: `python3 scripts/bib2md.py publications.bib`
3. Salin keluarannya ke bagian **### Selected** di
   `content/publications/_index.md`.

---

## 4. Bahasa

Situs utama berbahasa Inggris; folder tutorial berbahasa Indonesia
(berkas berakhiran `.id.md`). Pengunjung berganti bahasa lewat tombol EN/ID.
Halaman tanpa terjemahan cukup dibiarkan — itu memang disengaja.

---

## 5. Menambah tautan Google Form ke "Join us" (nanti)
Di `content/join/index.md`, ganti blok catatan dengan tombol:
`[Apply here](URL-google-form-mu)`.
