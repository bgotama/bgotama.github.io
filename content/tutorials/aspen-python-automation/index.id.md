---
title: "Otomasi Aspen Plus dengan Python"
date: 2026-06-01
summary: "Menjalankan simulasi Aspen Plus tanpa membuka GUI, langsung dari Python."
tags: ["Aspen Plus", "Python", "otomasi"]
showAuthor: true
---

Salah satu keterampilan paling menghemat waktu di PSE adalah **menjalankan
Aspen Plus dari Python** — sehingga kamu bisa menjalankan puluhan atau ratusan
skenario tanpa mengklik satu per satu.

## Ide dasarnya

Aspen Plus menyediakan antarmuka COM. Python bisa "menyetir" Aspen melalui
antarmuka ini: membuka file, mengubah parameter, menjalankan simulasi, lalu
membaca hasilnya.

```python
import win32com.client

# buka koneksi ke Aspen Plus
aspen = win32com.client.Dispatch("Apwn.Document")
aspen.InitFromArchive2(r"C:\path\ke\model.bkp")

# ubah sebuah variabel input (contoh: laju umpan)
node = r"\Data\Streams\FEED\Input\TOTFLOW\MIXED"
aspen.Tree.FindNode(node).Value = 100.0

# jalankan
aspen.Run2()

# baca sebuah hasil
hasil = aspen.Tree.FindNode(r"\Data\Streams\PRODUCT\Output\TOTFLOW\MIXED").Value
print("Laju produk:", hasil)
```

## Langkah berikutnya

- Bungkus kode di atas dalam sebuah *loop* untuk menjelajah banyak nilai
- Simpan hasilnya ke CSV untuk dianalisis
- Gabungkan dengan pustaka optimasi untuk pencarian otomatis

*Ini contoh tutorial. Ganti dengan materimu sendiri.*
