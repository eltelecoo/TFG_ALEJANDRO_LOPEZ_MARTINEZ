function [m, Z0, Zf, t0, tf] = calc_m(sheet,archivo)

% Leer hoja
medicion = readtable(archivo, 'Sheet', sheet);

% Extraer columnas fijas (según tu formato)
t = medicion{:,2};      % Tiempo (s)
Z = medicion{:,4};      % Impedancia (Ohm)

% Eliminar posibles filas con NaN
idx_valid = ~isnan(t) & ~isnan(Z);
t = t(idx_valid);
Z = Z(idx_valid);

%% Tomar valores inicial y final

% Detectar si hay caída inicial fuerte
if max(Z(1:10)) > 5*min(Z)

    % caso 1: Medicion completa (hay caida)
    margen = 5;
    umbral_diff = 5e4;   % 50 kOhm
    umbral_log = 5.7;
    idx0 = [];

    for i = 1:length(Z)-margen

        cond1 = log10(Z(i)) < umbral_log;
        cond2 = abs(Z(i) - Z(i+margen)) < umbral_diff;

        if cond1 && cond2
            idx0 = i;
            break
        end
    end

    if isempty(idx0)
        error('No se encontró Z0 válido.');
    end

else

    % caso 2: Medicion con tramo intermedio
    idx0 = 1;

end

t0 = t(idx0); % Z0 y t0 tienen el mismo indice
tf = t(end);

Z0 = Z(idx0);
Zf = Z(end);

% Calcular pendiente en Ohm/s
m_ohm = (Z0 - Zf) / (tf - t0);

% Convertir a kOhm/s
m = m_ohm / 1000;

end