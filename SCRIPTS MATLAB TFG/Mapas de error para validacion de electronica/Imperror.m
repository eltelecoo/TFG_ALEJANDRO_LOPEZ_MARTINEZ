clear; clc; close all;
archivo = 'archivo_excel.xlsx';
% valores de impedancia medidos
Z_vals = [1e3 2e3 3e3 4e3 5e3 1e4 1.5e4 2e4 3e4 4e4 5e4 ...
         7.5e4 1e5 1.5e5 2e5 2.5e5 3e5 3.5e5 4e5 4.5e5 5e5 ...
         1e6 1.5e6 2e6 3e6 4e6 5e6 7.5e6 1e7];
% sheet de cada valor de impedancia
sheets = { ...
   '1 K S1','2 K S2','3 K S3','4 K S4','5 K S5', ...
   '10 K S6','15 K S7','20 K S8','30 K S9','40 K S10', ...
   '50 K S11','75 K S12','100 K S13','150 K S14','200 K S15', ...
   '250 K S16','300 K S17','350 K S18','400 K S19','450 K S20','500 K S21', ...
   '1 M S22','1.5 M S23','2 M S24','3 M S25','4 M S26','5 M S27','7.5 M S28','10 M S29'};
% Frecuencia base
T0 = readtable(archivo, 'Sheet', sheets{1});
freq = T0{:,1};
Nf = length(freq);
Nz = length(Z_vals);
Z_accurate = nan(Nf, Nz);
%% === CARGAR DATOS ===
for k = 1:Nz
   T = readtable(archivo, 'Sheet', sheets{k});
  
   freq_k = T{:,1};
   accuracy_k = T{:,3};
   if isequal(freq_k, freq)
       Z_accurate(:,k) = accuracy_k;
   else
       Z_accurate(:,k) = interp1(freq_k, accuracy_k, freq, 'pchip');
   end
end
%% === GRID ===
[X, Y] = meshgrid(log10(freq), log10(Z_vals));
%% === error ===
error = 1 - Z_accurate;
% Malla densa
freq_fine = linspace(log10(min(freq)), log10(max(freq)), 300);
Z_fine    = linspace(log10(min(Z_vals)), log10(max(Z_vals)), 300);
[Xq, Yq] = meshgrid(freq_fine, Z_fine);
% Interpolación
error_interp = interp2(X, Y, error', Xq, Yq, 'cubic');
figure;
surf(Xq, Yq, error_interp, 'EdgeColor', 'none');
view(3 ...
   );  
colormap(jet);
colorbar;
xlabel('log10(Frecuencia)');
ylabel('log10(Impedancia)');
title('Error/% normalizado');
set(gca, 'YDir', 'normal');
hold on;
