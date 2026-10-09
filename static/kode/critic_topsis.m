function [w, Ci, urutan, rincian] = critic_topsis(X, tipe, target)
%CRITIC_TOPSIS  Pembobotan objektif CRITIC dan perankingan TOPSIS.
%
%   [w, Ci, urutan, rincian] = critic_topsis(X, tipe)
%   [w, Ci, urutan, rincian] = critic_topsis(X, tipe, target)
%
%   Menentukan bobot kriteria secara objektif dengan metode CRITIC, lalu
%   memeringkat alternatif dengan TOPSIS. Dipakai untuk memilih satu solusi
%   dari sekumpulan solusi Pareto hasil optimasi multi-objektif.
%
%   MASUKAN
%     X      Matriks keputusan berukuran m x n.
%            Baris  = alternatif (misalnya solusi pada Pareto front).
%            Kolom  = kriteria   (misalnya TAC, emisi CO2, PRI).
%
%     tipe   Vektor 1 x n yang menyatakan arah setiap kriteria:
%              +1  benefit    - makin BESAR makin baik (mis. yield, laba)
%              -1  cost       - makin KECIL makin baik (mis. TAC, emisi)
%               0  intermediate - makin DEKAT ke nilai target makin baik
%                                 (mis. pH, kemurnian yang dipatok)
%
%     target (opsional) Vektor 1 x n berisi nilai target. Hanya dipakai
%            untuk kolom yang tipe-nya 0. Isi NaN untuk kolom lainnya.
%
%   KELUARAN
%     w        Bobot objektif tiap kriteria, 1 x n, jumlahnya = 1.
%     Ci       Kedekatan relatif tiap alternatif, m x 1. Makin besar makin
%              baik; nilai maksimum adalah alternatif terpilih.
%     urutan   Indeks alternatif dari terbaik ke terburuk.
%     rincian  Struct berisi langkah antara: matriks ternormalisasi A,
%              simpangan baku sigma, matriks korelasi R, kuantitas
%              informasi C, matriks terbobot V, solusi ideal Vp dan Vn,
%              serta jarak Sp dan Sn. Untuk memeriksa hasil langkah demi
%              langkah ketika belajar atau menelusuri kesalahan.
%
%   CONTOH
%     % 5 solusi Pareto, 3 objektif yang semuanya ingin diminimalkan
%     X = [1.00e6 4200 0.95
%          1.05e6 3900 1.10
%          1.12e6 3700 0.88
%          0.97e6 4500 1.25
%          1.20e6 3500 0.80];
%     [w, Ci, urutan] = critic_topsis(X, [-1 -1 -1]);
%     fprintf('Alternatif terpilih: %d\n', urutan(1));
%
%   ACUAN PERSAMAAN
%     Li, Z., Huang, X., Wang, L., Chen, Y., Shi, T., Shen, W. (2025).
%     Sustainable and efficient separation of ternary multi-azeotropic
%     mixture butanone/ethanol/water based on the intensified reactive
%     extractive distillation. Separation and Purification Technology,
%     355, 129694. Persamaan (7)-(20).
%     https://doi.org/10.1016/j.seppur.2024.129694
%
%   METODE ASLI
%     CRITIC : Diakoulaki, D., Mavrotas, G., Papayannakis, L. (1995).
%              Determining objective weights in multiple criteria
%              problems: the CRITIC method. Computers & Operations
%              Research, 22(7), 763-770.
%     TOPSIS : Hwang, C.L., Yoon, K. (1981). Multiple Attribute Decision
%              Making: Methods and Applications. Springer-Verlag.
%
%   CATATAN IMPLEMENTASI
%     Hanya memakai fungsi MATLAB dasar (std, corrcoef). TIDAK memerlukan
%     Statistics and Machine Learning Toolbox. Bila Anda memakai corr()
%     alih-alih corrcoef(), skrip ini akan menuntut toolbox tersebut.
%
%   Penulis  : Bangkit Gotama, Teknik Kimia, Institut Teknologi Kalimantan
%   Lisensi  : MIT

% ─── Pemeriksaan masukan ────────────────────────────────────────────────
narginchk(2, 3);

if ~isnumeric(X) || ~ismatrix(X) || isempty(X)
    error('critic_topsis:X', 'X harus matriks numerik yang tidak kosong.');
end
if any(~isfinite(X(:)))
    error('critic_topsis:X', 'X memuat NaN atau Inf. Bersihkan data dulu.');
end

[m, n] = size(X);

if m < 2
    error('critic_topsis:m', ...
        'Dibutuhkan minimal 2 alternatif; CRITIC memakai simpangan baku antar alternatif.');
end
if m == 2
    % Dengan dua alternatif, standardisasi min-max membuat setiap kolom
    % menjadi [1;0] atau [0;1]. Akibatnya SEMUA pasangan kriteria
    % berkorelasi sempurna dan suku (1 - |r|) pada pers. (13) runtuh ke nol
    % dalam batas presisi mesin. Bobot yang keluar hanyalah derau numerik.
    warning('critic_topsis:duaAlternatif', ...
        ['Hanya 2 alternatif: CRITIC tidak terdefinisi karena seluruh ' ...
         'kriteria otomatis berkorelasi sempurna. Bobot dibagi rata. ' ...
         'Pakai minimal 3 alternatif agar bobotnya bermakna.']);
end
if numel(tipe) ~= n
    error('critic_topsis:tipe', ...
        'Panjang tipe (%d) harus sama dengan jumlah kriteria (%d).', numel(tipe), n);
end
tipe = reshape(tipe, 1, n);
if ~all(ismember(tipe, [-1 0 1]))
    error('critic_topsis:tipe', 'tipe hanya boleh berisi -1, 0, atau +1.');
end

if nargin < 3 || isempty(target)
    target = nan(1, n);
else
    target = reshape(target, 1, n);
end
if any(tipe == 0 & ~isfinite(target))
    error('critic_topsis:target', ...
        'Kriteria bertipe 0 memerlukan nilai target yang berhingga.');
end

% ════════════════════════════════════════════════════════════════════════
%  BAGIAN 1 — CRITIC : menentukan bobot secara objektif
% ════════════════════════════════════════════════════════════════════════

% ─── Langkah 1: standardisasi matriks keputusan, pers. (7)-(10) ─────────
% Setelah langkah ini SEMUA kolom berorientasi "makin besar makin baik",
% berapa pun arah aslinya. Inilah yang membuat max/min pada TOPSIS di
% bawah berlaku seragam untuk semua kolom.
A = zeros(m, n);
for j = 1:n
    kol  = X(:, j);
    amin = min(kol);
    amax = max(kol);

    switch tipe(j)
        case 1   % benefit, pers. (8)
            if amax == amin
                A(:, j) = 1;                 % kolom konstan: tak informatif
            else
                A(:, j) = (kol - amin) ./ (amax - amin);
            end

        case -1  % cost, pers. (9)
            if amax == amin
                A(:, j) = 1;
            else
                A(:, j) = (amax - kol) ./ (amax - amin);
            end

        case 0   % intermediate, pers. (10)
            d    = abs(kol - target(j));
            dmax = max(d);
            if dmax == 0
                A(:, j) = 1;                 % semua alternatif tepat di target
            else
                A(:, j) = 1 - d ./ dmax;
            end
    end
end

% ─── Langkah 2: simpangan baku tiap kriteria, pers. (11) ───────────────
% std MATLAB membagi dengan (m-1), persis seperti pers. (11).
sigma = std(A, 0, 1);

% ─── Langkah 3-5: korelasi, kuantitas informasi, dan bobot ─────────────
% pers. (12), (13), (14)
if n == 1
    % Satu kriteria: korelasi antar kriteria tidak ada artinya, dan
    % bobotnya pasti 1. Jangan jalankan CRITIC di sini — pers. (13) akan
    % memberi C = 0 dan memicu peringatan yang menyesatkan.
    R = 1;
    C = sigma;
    w = 1;
else
    % PENTING. Kolom dengan simpangan baku nol membuat corrcoef
    % mengembalikan NaN, dan NaN itu menjalar sehingga SELURUH bobot
    % menjadi NaN — termasuk bobot kriteria yang datanya sehat. Perilaku
    % ini sudah diuji. Korelasi yang melibatkan kolom konstan di sini
    % diperlakukan sebagai 0: tidak ada informasi bersama.
    R = corrcoef(A);
    R(~isfinite(R)) = 0;
    R(1:n+1:end)    = 1;                      % pastikan diagonal tetap 1

    C = sigma .* sum(1 - abs(R), 1);          % pers. (13)

    % Ambang, BUKAN perbandingan dengan nol persis. Pada kasus seperti
    % m = 2, suku (1 - |r|) runtuh menjadi sekitar 1e-16 — bukan nol —
    % sehingga uji "sum(C) == 0" lolos dan menghasilkan bobot dari derau
    % numerik tanpa peringatan apa pun. Karena A sudah dinormalisasi ke
    % [0,1], nilai C yang bermakna selalu jauh di atas ambang ini.
    AMBANG_C = 1e-12;
    if sum(C) < AMBANG_C
        warning('critic_topsis:tanpaInformasi', ...
            ['Kriteria tidak memberi informasi pembeda (semuanya konstan, ' ...
             'atau berkorelasi sempurna satu sama lain). Bobot dibagi rata ' ...
             'dan hasil perankingan tidak bermakna.']);
        w = ones(1, n) / n;
    else
        w = C ./ sum(C);                      % pers. (14)
    end
end

% ════════════════════════════════════════════════════════════════════════
%  BAGIAN 2 — TOPSIS : memeringkat alternatif
% ════════════════════════════════════════════════════════════════════════

% ─── Langkah 1: matriks keputusan terbobot, pers. (15) ─────────────────
V = A .* w;                                   % perkalian elemen, w disiarkan

% ─── Langkah 2: solusi ideal positif dan negatif, pers. (16)-(17) ──────
% Berlaku max/min seragam karena langkah standardisasi sudah menyeragamkan
% arah seluruh kolom.
Vp = max(V, [], 1);
Vn = min(V, [], 1);

% ─── Langkah 3: jarak Euclid ke kedua solusi ideal, pers. (18)-(19) ────
Sp = sqrt(sum((V - Vp).^2, 2));
Sn = sqrt(sum((V - Vn).^2, 2));

% ─── Langkah 4: kedekatan relatif, pers. (20) ──────────────────────────
penyebut = Sp + Sn;
Ci = zeros(m, 1);
bukanNol = penyebut > 0;
Ci(bukanNol) = Sn(bukanNol) ./ penyebut(bukanNol);
% Penyebut nol hanya mungkin bila seluruh alternatif identik; Ci = 0.

% ─── Langkah 5: urutkan dari terbaik ke terburuk ───────────────────────
[~, urutan] = sort(Ci, 'descend');

% ─── Langkah antara, untuk pemeriksaan ─────────────────────────────────
rincian = struct('A', A, 'sigma', sigma, 'R', R, 'C', C, ...
                 'V', V, 'Vp', Vp, 'Vn', Vn, 'Sp', Sp, 'Sn', Sn);

end
