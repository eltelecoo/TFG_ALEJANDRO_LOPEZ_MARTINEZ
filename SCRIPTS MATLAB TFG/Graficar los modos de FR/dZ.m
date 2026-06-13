function [time_mid,FR_from_Z] = dZ(t_Z, Z)

% aplicamos un pequeño filtrado previo a la derivada
smooth_Z = movmean(Z,10);
dZ_dt = diff(smooth_Z) ./ diff(t_Z);
dZ_dt_inv = -dZ_dt;
% aplicamos otro filtrado suave debido al ruido que introduce la derivada
smooth_dZ_dt_inv = movmean(dZ_dt_inv, 10);
% aplicamos el modelo de la curva de calibrado
FR_from_Z = smooth_dZ_dt_inv / 0.0932;
% eliminamos valores negativos
FR_from_Z(FR_from_Z < 0) = 0;
% ajustar tiempo a la derivada
time_mid = (t_Z(1:end-1) + t_Z(2:end)) / 2;

end