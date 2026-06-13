clear; clc; close all;

%% === CONFIGURACIÓN ===
file = 'AS1_500mm_2uL_tramos.xlsx';
longitudes = [0 57.85, 123.55 189.26 254.97 320.67 388.38 454.1 519.8];   % mm
sheets = {'AS1_500mm_hasta_inicio_scan','AS1_500mm_hasta_curva1_sca S15','AS1_500mm_hasta_curva2_sca S13','AS1_500mm_hasta_curva3_sca S11','AS1_500mm_hasta_curva4_sca S9','AS1_500mm_hasta_curva5_sca S7','AS1_500mm_hasta_curva6_sca S5','AS1_500mm_hasta_curva7_sca S3', 'AS1_500mm_hasta_final_scan S1'};

%% === LEER DATOS Y MONTAR MATRICES ===
% Leer primera hoja para tomar el eje de frecuencia
T0 = readtable(file, 'Sheet', sheets{1});
freq_ref = T0{:,1};            % vector frecuencia (Nx1)
Nf = numel(freq_ref);
Nl = numel(sheets);

Z = nan(Nf, Nl);               % matriz fase: filas freq, columnas longitudes

for k = 1:Nl
    T = readtable(file, 'Sheet', sheets{k});
    freq_k  = T{:,1};
    phase_k = T{:,3};

    if isequal(freq_k, freq_ref)
        Z(:,k) = phase_k;
    else
        % Si los vectores de frecuencia difieren: interpola a freq_ref
        Z(:,k) = interp1(freq_k, phase_k, freq_ref, 'pchip', NaN);
    end
end

% Ejes para surf: X = longitudes (columna), Y = log10(freq) (fila)
[X, Y] = meshgrid(longitudes, log10(freq_ref));   % size Nf x Nl

%% === PLOTEAR CON SURF COMO MAPA DE CALOR ===
figure;
s = surf(X, Y, Z, 'EdgeColor', 'none');   % sin líneas de malla
view(45,30);                                  % vista en planta (mapa de calor)
colormap(jet);
colorbar;
xlabel('Longitud (mm)');
ylabel('log10(Frecuencia)');
zlabel('Fase (°)');
title('Fase (°) vs Longitud y Frecuencia');
set(gca, 'YDir', 'normal');               % y orientado hacia arriba
shading interp;

hold on

%% === Marca de referencia con respecto el sensor de 250 mm ===
hold on

x_mark = 247.1;   % mm

% Rangos del gráfico
ymin = min(log10(freq_ref));
ymax = max(log10(freq_ref));

x_width = 5;  % ancho del plano en mm

[Xp, Yp] = meshgrid([x_mark - x_width/2, x_mark + x_width/2], ...
    linspace(ymin,ymax,100));
zmin = min(Z(:));
zmax = max(Z(:));
Zp = zmax * ones(size(Xp));

surf(Xp, Yp, Zp, ...
    'FaceAlpha', 0.4, ...
    'EdgeColor', 'none', ...
    'FaceColor', 'w');


%% === Rango de frecuencias buenas ===
hold on

% Límites de la banda en log10(f)
y1 = 3.5;
y2 = 4.0;

% Rango de longitudes
xmin = min(longitudes);
xmax = max(longitudes);

% Altura ligeramente por encima del mapa
zmax = max(Z(:));
z_line = zmax + 2;

% Línea inferior
plot3([xmin xmax], [y1 y1], [z_line z_line], ...
    'y--', 'LineWidth', 2);

% Línea superior
plot3([xmin xmax], [y2 y2], [z_line z_line], ...
    'y--', 'LineWidth', 2);

