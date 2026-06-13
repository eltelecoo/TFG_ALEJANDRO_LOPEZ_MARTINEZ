%% Datos de impedancia medida
Z = excel_medida(:,2)./1000; % en kOhm
t_Z = excel_medida(:,1);

%% Generar vectores de tiempo y FR del modo ideal

% utilizar la GUI generador_modos_FR.m
% IMPORTANTE: va acompañada de la funcion obtenerDuracionModo.m

%% Aplicar derivada dZ/dt para extraer FR real

[time_mid,FR_from_Z] = dZ(t_Z, Z);

%% Igualar longitud de vectores

% la diferencia de longitud entre todos los vectores implicados
% es tan pequeña (en torno a 10 muestras), que no invalida los
% datos y no da lugar a incongruencia de dimensiones en el graficado

[t_univ, FR_ideal, FR_from_Z, Z] = ...
    igualar_long(t_ideal, FR_ideal, time_mid, FR_from_Z, Z);


%% Graficar todo

figure('Color','w');

yyaxis left

plot(t_univ,Z,...
    'b',...
    'LineWidth',1.5,...
    'DisplayName','Z medida');

ylabel('Z (k\Omega)')

yyaxis right

hold on

plot(t_univ,FR_from_Z,...
    'LineWidth',1.5,...
    'DisplayName','Flow Rate medido');

plot(t_univ,FR_ideal,...
    '--k',...
    'LineWidth',2,...
    'DisplayName','Flow Rate ideal');

plot(t_univ,FR_plus10,...
    ':b',...
    'LineWidth',1.5,...
    'DisplayName','Ideal +10%');

plot(t_univ,FR_minus10,...
    ':r',...
    'LineWidth',1.5,...
    'DisplayName','Ideal -10%');

ylabel('Flow Rate (\muL/min)')

xlabel('Time (s)')

title(sprintf('Modo R%d: Extraido de Z vs Programado',modo_ID))

legend('Location','best')

grid on
box on