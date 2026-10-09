function CriticTopsis_BestOption()

clc;
close all;

%% ================= INPUT DATA =================
% Alternatif = 4 opsi
optionNames = ["Option 1","Option 2","Option 3","Option 4"]; % disesuaikan dengan jumlah opsi

% Kriteria
criteriaNames = ["Tol","Air","Listrik","Bahan baku","Luas"]; % disesuaikan dengan jumlah kriteria 
isBenefit = [false true true false true];

X = [ ...
    34   3600  660  11    1761 ;   % Option 1
    50.4 369   60   77.8  480 ;    % Option 2
    100  1000  722  5     500 ;    % Option 3
    75   500   100  100   2000 ];  % Option 4

outExcel = "CRITIC_TOPSIS_BestOption.xlsx";

%% ================= VALIDATION =================
if size(X,1) < 2
    error("Jumlah opsi terlalu sedikit.");
end

if size(X,2) ~= numel(criteriaNames)
    error("Jumlah kolom X harus sama dengan jumlah criteriaective.");
end

%% ================= CRITIC =================
% Step 1: standardization 
A = normalizeMinMaxCritic(X, isBenefit);

% Step 2: standard deviation
sigma = std(A, 0, 1);

% Step 3: correlation coefficient
R = corr(A, "Rows", "pairwise");
R(~isfinite(R)) = 0;

% Step 4: information quantity
m = size(A,2);
C = zeros(1,m);
for j = 1:m
    C(j) = sigma(j) * sum(1 - abs(R(j,:)));
end

if ~(all(isfinite(C)) && any(C > 0))
    error("CRITIC gagal: semua Cj nol atau invalid.");
end

% Step 5: criteria objective weights
w = C ./ sum(C);
w = max(w, 0);
w = w ./ sum(w);

fprintf("\n=== CRITIC Weights ===\n");
for j = 1:m
    fprintf("  %s : %.6f\n", criteriaNames(j), w(j));
end

%% ================= TOPSIS =================
% Menggunakan matriks standar A, lalu V = A .* w
V = A .* w;

% Karena semua criteria objective telah diubah menjadi benefit-like oleh standardization:
% ideal positif = maksimum
% ideal negatif = minimum
Vplus  = max(V, [], 1);
Vminus = min(V, [], 1);

Splus  = sqrt(sum((V - Vplus ).^2, 2));
Sminus = sqrt(sum((V - Vminus).^2, 2));
CC = Sminus ./ (Splus + Sminus);

[CC_sorted, idxRank] = sort(CC, "descend"); %#ok<ASGLU>
bestIdx = idxRank(1);

fprintf("\n=== TOPSIS Ranking ===\n");
for k = 1:numel(idxRank)
    i = idxRank(k);
    fprintf("  Rank %d : %s | CC = %.6f\n", k, optionNames(i), CC(i));
end

fprintf("\n=== BEST OPTION ===\n");
fprintf("  %s\n", optionNames(bestIdx));
fprintf("  Relative Closeness = %.6f\n", CC(bestIdx));

%% ================= SAVE RESULTS =================
rankPos = zeros(numel(CC), 1);
rankPos(idxRank) = 1:numel(idxRank);

ResultTab = table( ...
    optionNames(:), ...
    X(:,1), X(:,2), X(:,3), X(:,4), X(:,5), ...
    CC, ...
    rankPos, ...
    'VariableNames', {'Option','Tol','Air','Listrik','BahanBaku','Luas','CC_Topsis','Rank_Topsis'});

WeightTab = table( ...
    criteriaNames(:), w(:), C(:), sigma(:), ...
    'VariableNames', {'Criterion','Weight_CRITIC','Cj','StdNorm'});

BestOptionTab = ResultTab(bestIdx,:);

if isfile(outExcel)
    delete(outExcel);
end

writetable(ResultTab,     outExcel, "Sheet", "Option_Ranking");
writetable(WeightTab,     outExcel, "Sheet", "CRITIC_Weights");
writetable(BestOptionTab, outExcel, "Sheet", "Best_Option");

fprintf("\nSaved Excel: %s\n", outExcel);

end

%% ================= HELPER =================
function A = normalizeMinMaxCritic(X, isBenefit)
xmin = min(X,[],1);
xmax = max(X,[],1);
den  = xmax - xmin;
den(den == 0) = 1;

A = zeros(size(X));
for j = 1:size(X,2)
    if isBenefit(j)
        A(:,j) = (X(:,j) - xmin(j)) ./ den(j);
    else
        A(:,j) = (xmax(j) - X(:,j)) ./ den(j);
    end
end

A(~isfinite(A)) = 0;
A = min(1, max(0, A));
end
