function generador_modos_FR

fig = uifigure(...
    'Name','Biblioteca de Modos de FR con rampas (R)',...
    'Position',[100 100 900 500]);

%% =========================
% ENTRADAS
%% =========================

uilabel(fig,...
    'Position',[20 430 150 22],...
    'Text','Inserte id de Modo (1 a 94):');

ModoField = uieditfield(fig,'numeric',...
    'Position',[180 430 120 22],...
    'Value',1);

uilabel(fig,...
    'Position',[20 380 150 22],...
    'Text','Tiempo de muestreo Ts (s):');

TsField = uieditfield(fig,'numeric',...
    'Position',[180 380 120 22],...
    'Value',0.397);

%% =========================
% INFORMACIÓN
%% =========================

infoLabel = uitextarea(fig,...
    'Position',[20 170 300 170],...
    'Editable','off');

%% =========================
% BOTÓN
%% =========================

uibutton(fig,...
    'Text','Generar modo',...
    'Position',[20 120 180 35],...
    'ButtonPushedFcn',@(btn,event) generarModo());

uibutton(fig,...
    'Text','Manual de modos',...
    'Position',[20 70 150 30],...
    'ButtonPushedFcn',@(btn,event) mostrarManual());

%% =========================
% EJES
%% =========================

ax = uiaxes(fig,...
    'Position',[350 50 520 400]);

xlabel(ax,'Tiempo (s)')
ylabel(ax,'Flow Rate (\muL/min)')
title(ax,'Modo programado')
grid(ax,'on')

%% =========================
%% FUNCIONES PRINCIPALES
%% =========================

%% FUNCION PARA INDICAR LA DURACION TOTAL DE CADA MODO

    function t_final = obtenerDuracionModo(modo)

        switch modo

            case 1
                t_final = 360;

            case 2
                t_final = 420;

            case 3
                t_final = 480;

            case 4
                t_final = 1200;

            case 5
                t_final = 1080;

            case 6
                t_final = 960;

            case 7
                t_final = 900;

            case 8
                t_final = 860;

            case 91
                t_final = 1110;

            case 92
                t_final = 1200;

            case 93
                t_final = 1470;

            otherwise

                error('Modo R%d no definido',modo)

        end

    end

%% FUNCION PARA GENERAR EL MODO INDICADO POR ID
% Exporta los vectores de tiempo y FR, así como un graficado representativo

    function generarModo()

        modo = round(ModoField.Value);
        Ts = TsField.Value;

        if Ts <= 0

            uialert(fig,...
                'Ts debe ser positivo.',...
                'Error');

            return
        end

        %% Obtener duración del modo

        t_final = obtenerDuracionModo(modo);

        %% Generar vector temporal

        t = (0:Ts:t_final)';

        %% Generar modo

        [FR,...
            FRp,...
            FRm] = modo_ideal(modo,t);

        %% Información

        texto = sprintf([...
            'Modo: R%d\n\n' ...
            'Duración total: %.1f s\n\n' ...
            'Número de muestras: %d\n\n' ...
            'FR mínimo: %.2f µL/min\n\n' ...
            'FR máximo: %.2f µL/min'],...
            modo,...
            t_final,...
            length(t),...
            min(FR),...
            max(FR));

        infoLabel.Value = texto;

        %% Plot

        cla(ax)

        hold(ax,'on')

        plot(ax,...
            t,...
            FR,...
            'k',...
            'LineWidth',2,...
            'DisplayName','Ideal');

        plot(ax,...
            t,...
            FRp,...
            '--g',...
            'LineWidth',1.5,...
            'DisplayName','+10%');

        plot(ax,...
            t,...
            FRm,...
            '--r',...
            'LineWidth',1.5,...
            'DisplayName','-10%');

        hold(ax,'off')

        legend(ax,'show')

        ylim(ax,[0 max(FRp)*1.2])

        %% Exportar al Workspace

        assignin('base','t_ideal',t); % vector tiempo ideal

        assignin('base','FR_ideal',FR); % vector modo FR ideal

        assignin('base','FR_plus10',FRp); % vector modo FR ideal +10%

        assignin('base','FR_minus10',FRm); % vector modo FR ideal -10%

        assignin('base','modo_ID',modo); % id del modo

    end

%% FUNCION RECOPILATORIA DE LOS MODOS DE FR PROPUESTOS

    function [flow_ideal, flow_ideal_plus10, flow_ideal_minus10] = modo_ideal(numero_modo,t)
        modo = numero_modo;
        switch modo
            case 1
                %% ===== FLOW RATE IDEAL DEFINIDO POR TRAMOS (Modo R1) =====
                t_puntos = [0, 120, 150, 210, 240, 360];
                flow_puntos = [1.0, 1.0, 2.0, 2.0, 1.0, 1.0];
                flow_ideal_base = interp1(t_puntos, flow_puntos, t, 'linear', 'extrap');
                flow_ideal = zeros(size(t));
                indices_dentro_rango = (t >= 0) & (t <= 480);
                flow_ideal(indices_dentro_rango) = flow_ideal_base(indices_dentro_rango);
                flow_ideal(flow_ideal < 0) = 0;
                flow_ideal(flow_ideal < 0) = 0;
                flow_ideal_plus10  = flow_ideal * 1.10;   % +10%
                flow_ideal_minus10 = flow_ideal * 0.90;   % -10%
                flow_ideal_plus10(flow_ideal_plus10 < 0) = 0;
                flow_ideal_minus10(flow_ideal_minus10 < 0) = 0;
            case 2
                %% ===== FLOW RATE IDEAL DEFINIDO POR TRAMOS MODO R2 =====
                t_puntos = [0, 120, 180, 240, 300, 420];
                flow_puntos = [1.0, 1.0, 2.0, 2.0, 1.0, 1.0];
                flow_ideal_base = interp1(t_puntos, flow_puntos, t, 'linear', 'extrap');
                flow_ideal = zeros(size(t));
                indices_dentro_rango = (t >= 0) & (t <= 480);
                flow_ideal(indices_dentro_rango) = flow_ideal_base(indices_dentro_rango);
                flow_ideal(flow_ideal < 0) = 0;
                flow_ideal_plus10  = flow_ideal * 1.10;   % +10%
                flow_ideal_minus10 = flow_ideal * 0.90;   % -10%
                flow_ideal_plus10(flow_ideal_plus10 < 0) = 0;
                flow_ideal_minus10(flow_ideal_minus10 < 0) = 0;
            case 3
                %% ===== FLOW RATE IDEAL DEFINIDO POR TRAMOS MODO R3 =====
                t_puntos = [0, 120, 210, 270, 360, 480];
                flow_puntos = [1.0, 1.0, 2.0, 2.0, 1.0, 1.0];
                flow_ideal_base = interp1(t_puntos, flow_puntos, t, 'linear', 'extrap');
                flow_ideal = zeros(size(t));
                indices_dentro_rango = (t >= 0) & (t <= 480);
                flow_ideal(indices_dentro_rango) = flow_ideal_base(indices_dentro_rango);
                flow_ideal(flow_ideal < 0) = 0;
                flow_ideal_plus10  = flow_ideal * 1.10;   % +10%
                flow_ideal_minus10 = flow_ideal * 0.90;   % -10%
                flow_ideal_plus10(flow_ideal_plus10 < 0) = 0;
                flow_ideal_minus10(flow_ideal_minus10 < 0) = 0;
            case 4
                %% ===== FLOW RATE IDEAL DEFINIDO POR TRAMOS Modo R4 =====
                t_puntos = [0, 240, 330, 450, 540, 660, 750, 870, 960, 1200];
                flow_puntos = [0.25, 0.25, 0.5, 0.5, 1.0, 1.0, 0.5, 0.5, 0.25, 0.25];
                flow_ideal_base = interp1(t_puntos, flow_puntos, t, 'linear', 'extrap');
                flow_ideal = zeros(size(t));
                indices_dentro_rango = (t >= 0) & (t <= 1200);
                flow_ideal(indices_dentro_rango) = flow_ideal_base(indices_dentro_rango);
                flow_ideal(flow_ideal < 0) = 0;
                flow_ideal_plus10  = flow_ideal * 1.10;   % +10%
                flow_ideal_minus10 = flow_ideal * 0.90;   % -10%
                flow_ideal_plus10(flow_ideal_plus10 < 0) = 0;
                flow_ideal_minus10(flow_ideal_minus10 < 0) = 0;
            case 5
                %% ===== FLOW RATE IDEAL DEFINIDO POR TRAMOS (Modo R5) =====
                t_puntos = [0, 240, 300, 420, 480, 600, 660, 780, 840, 1080];
                flow_puntos = [0.25, 0.25, 0.5, 0.5, 1.0, 1.0, 0.5, 0.5, 0.25, 0.25];
                flow_ideal_base = interp1(t_puntos, flow_puntos, t, 'linear', 'extrap');
                flow_ideal = zeros(size(t));
                indices_dentro_rango = (t >= 0) & (t <= 1080);
                flow_ideal(indices_dentro_rango) = flow_ideal_base(indices_dentro_rango);
                flow_ideal(flow_ideal < 0) = 0;
                flow_ideal_plus10  = flow_ideal * 1.10;   % +10%
                flow_ideal_minus10 = flow_ideal * 0.90;   % -10%
                flow_ideal_plus10(flow_ideal_plus10 < 0) = 0;
                flow_ideal_minus10(flow_ideal_minus10 < 0) = 0;
            case 6
                %% ===== FLOW RATE IDEAL DEFINIDO POR TRAMOS Modo R6 =====
                t_puntos = [0, 240, 270, 390, 420, 540, 570, 690, 720, 960];
                flow_puntos = [0.25, 0.25, 0.5, 0.5, 1.0, 1.0, 0.5, 0.5, 0.25, 0.25];
                flow_ideal_base = interp1(t_puntos, flow_puntos, t, 'linear', 'extrap');
                flow_ideal = zeros(size(t));
                indices_dentro_rango = (t >= 0) & (t <= 960);
                flow_ideal(indices_dentro_rango) = flow_ideal_base(indices_dentro_rango);
                flow_ideal(flow_ideal < 0) = 0;
                flow_ideal_plus10  = flow_ideal * 1.10;   % +10%
                flow_ideal_minus10 = flow_ideal * 0.90;   % -10%
                flow_ideal_plus10(flow_ideal_plus10 < 0) = 0;
                flow_ideal_minus10(flow_ideal_minus10 < 0) = 0;
            case 7
                %% ===== FLOW RATE IDEAL DEFINIDO POR TRAMOS Modo R7 =====
                t_puntos = [ 0, 240, 255, 375, 390, 510, 525, 645, 660, 900 ];
                flow_puntos = [ 0.25, 0.25, 0.5, 0.5, 1.0, 1.0, 0.5, 0.5, 0.25, 0.25 ];
                flow_ideal_base = interp1(t_puntos, flow_puntos, t, 'linear', 'extrap');
                flow_ideal = zeros(size(t));
                indices_dentro_rango = (t >= 0) & (t <= 900);
                flow_ideal(indices_dentro_rango) = flow_ideal_base(indices_dentro_rango);
                flow_ideal(flow_ideal < 0) = 0;
                flow_ideal_plus10  = flow_ideal * 1.10;   % +10%
                flow_ideal_minus10 = flow_ideal * 0.90;   % -10%
                flow_ideal_plus10(flow_ideal_plus10 < 0) = 0;
                flow_ideal_minus10(flow_ideal_minus10 < 0) = 0;
            case 8
                %% ===== FLOW RATE IDEAL DEFINIDO POR TRAMOS Modo R8 =====
                t_puntos = [ 0, 240, 245, 365, 370, 490, 495, 615, 620, 860 ];
                flow_puntos = [ 0.25, 0.25, 0.5, 0.5, 1.0, 1.0, 0.5, 0.5, 0.25, 0.25 ];
                flow_ideal_base = interp1(t_puntos, flow_puntos, t, 'linear', 'extrap');
                flow_ideal = zeros(size(t));
                indices_dentro_rango = (t >= 0) & (t <= 860);
                flow_ideal(indices_dentro_rango) = flow_ideal_base(indices_dentro_rango);
                flow_ideal(flow_ideal < 0) = 0;
                flow_ideal_plus10  = flow_ideal * 1.10;   % +10%
                flow_ideal_minus10 = flow_ideal * 0.90;   % -10%
                flow_ideal_plus10(flow_ideal_plus10 < 0) = 0;
                flow_ideal_minus10(flow_ideal_minus10 < 0) = 0;
            case 91
                %% ===== FLOW RATE IDEAL DEFINIDO POR TRAMOS Modo R91 =====
                t_puntos = [ 0, 240, 255, 375, 390, 510, 525, 585, 600, 720, 735, 855, 870, 1110 ];
                flow_puntos = [ 0.25, 0.25, 0.5, 0.5, 1.0, 1.0, 2.0, 2.0, 1.0, 1.0, 0.5, 0.5, 0.25, 0.25 ];
                flow_ideal_base = interp1(t_puntos, flow_puntos, t, 'linear', 'extrap');
                flow_ideal = zeros(size(t));
                indices_dentro_rango = (t >= 0) & (t <= 1110);
                flow_ideal(indices_dentro_rango) = flow_ideal_base(indices_dentro_rango);
                flow_ideal(flow_ideal < 0) = 0;
                flow_ideal_plus10  = flow_ideal * 1.10;   % +10%
                flow_ideal_minus10 = flow_ideal * 0.90;   % -10%
                flow_ideal_plus10(flow_ideal_plus10 < 0) = 0;
                flow_ideal_minus10(flow_ideal_minus10 < 0) = 0;
            case 92
                %% ===== FLOW RATE IDEAL Modo R92 =====
                t_puntos = [ 0, 240, 270, 390, 420, 540, 570, 630, 660, 780, 810, 930, 960, 1200 ];
                flow_puntos = [ 0.25, 0.25, 0.5,  0.5, 1.0,  1.0, 2.0,  2.0, 1.0,  1.0, 0.5,  0.5, 0.25, 0.25 ];
                flow_ideal_base = interp1(t_puntos, flow_puntos, t, 'linear', 'extrap');
                flow_ideal = zeros(size(t));
                idx = (t >= 0) & (t <= 1200);
                flow_ideal(idx) = flow_ideal_base(idx);
                flow_ideal(flow_ideal < 0) = 0;
                flow_ideal_plus10  = flow_ideal * 1.10;   % +10%
                flow_ideal_minus10 = flow_ideal * 0.90;   % -10%
                flow_ideal_plus10(flow_ideal_plus10 < 0) = 0;
                flow_ideal_minus10(flow_ideal_minus10 < 0) = 0;
            case 93
                %% ===== FLOW RATE IDEAL Modo R93 =====
                t_puntos = [ 0, 240, 300, 420, 480, 600, 660, 720, 780, 900, 960, 1080, 1140, 1470 ];
                flow_puntos = [ 0.25, 0.25, 0.5,  0.5, 1.0,  1.0, 2.0,  2.0, 1.0,  1.0, 0.5,  0.5, 0.25, 0.25 ];
                flow_ideal_base = interp1(t_puntos, flow_puntos, t, 'linear', 'extrap');
                flow_ideal = zeros(size(t));
                idx = (t >= 0) & (t <= 1470);
                flow_ideal(idx) = flow_ideal_base(idx);
                flow_ideal(flow_ideal < 0) = 0;
                flow_ideal_plus10  = flow_ideal * 1.10;   % +10%
                flow_ideal_minus10 = flow_ideal * 0.90;   % -10%
                flow_ideal_plus10(flow_ideal_plus10 < 0) = 0;
                flow_ideal_minus10(flow_ideal_minus10 < 0) = 0;
            otherwise
                error('Modo R%d no definido', modo)
        end
    end

%% FUNCIONES PARA GENERAR MANUAL DESCRIPTIVO DE LOS MODOS

    function [t_puntos, flow_puntos] = obtenerDefinicionModo(modo)

        switch modo

            case 1
                t_puntos = [0,120,150,210,240,360];
                flow_puntos = [1.0,1.0,2.0,2.0,1.0,1.0];
            case 2
                t_puntos = [0,120,180,240,300,420];
                flow_puntos = [1.0,1.0,2.0,2.0,1.0,1.0];
            case 3
                t_puntos = [0,120,210,270,360,480];
                flow_puntos = [1.0,1.0,2.0,2.0,1.0,1.0];
            case 4
                t_puntos = [0, 240, 330, 450, 540, 660, 750, 870, 960, 1200];
                flow_puntos = [0.25, 0.25, 0.5, 0.5, 1.0, 1.0, 0.5, 0.5, 0.25, 0.25];
            case 5
                t_puntos = [0, 240, 300, 420, 480, 600, 660, 780, 840, 1080];
                flow_puntos = [0.25, 0.25, 0.5, 0.5, 1.0, 1.0, 0.5, 0.5, 0.25, 0.25];
            case 6
                t_puntos = [0, 240, 270, 390, 420, 540, 570, 690, 720, 960];
                flow_puntos = [0.25, 0.25, 0.5, 0.5, 1.0, 1.0, 0.5, 0.5, 0.25, 0.25];
            case 7
                t_puntos = [ 0, 240, 255, 375, 390, 510, 525, 645, 660, 900 ];
                flow_puntos = [ 0.25, 0.25, 0.5, 0.5, 1.0, 1.0, 0.5, 0.5, 0.25, 0.25 ];
            case 8
                t_puntos = [ 0, 240, 245, 365, 370, 490, 495, 615, 620, 860 ];
                flow_puntos = [ 0.25, 0.25, 0.5, 0.5, 1.0, 1.0, 0.5, 0.5, 0.25, 0.25 ];
            case 91
                t_puntos = [ 0, 240, 255, 375, 390, 510, 525, 585, 600, 720, 735, 855, 870, 1110 ];
                flow_puntos = [ 0.25, 0.25, 0.5, 0.5, 1.0, 1.0, 2.0, 2.0, 1.0, 1.0, 0.5, 0.5, 0.25, 0.25 ];
            case 92
                t_puntos = [ 0, 240, 270, 390, 420, 540, 570, 630, 660, 780, 810, 930, 960, 1200 ];
                flow_puntos = [ 0.25, 0.25, 0.5,  0.5, 1.0,  1.0, 2.0,  2.0, 1.0,  1.0, 0.5,  0.5, 0.25, 0.25 ];
            case 93
                t_puntos = [ 0, 240, 300, 420, 480, 600, 660, 720, 780, 900, 960, 1080, 1140, 1470 ];
                flow_puntos = [ 0.25, 0.25, 0.5,  0.5, 1.0,  1.0, 2.0,  2.0, 1.0,  1.0, 0.5,  0.5, 0.25, 0.25 ];



            otherwise

                error('Modo no definido')

        end

    end

    function texto = generarManualCompleto()

        texto = sprintf([ ...
            '====================================================\n' ...
            'MANUAL DE MODOS DE FLOW RATE\n' ...
            '====================================================\n\n' ...
            'Los modos R1-R93 representan diferentes perfiles\n' ...
            'temporales de caudal utilizados para evaluar la\n' ...
            'respuesta dinámica del sensor microfluídico.\n\n' ...
            'Cada modo está compuesto por una combinación de:\n\n' ...
            '• Tramos estacionarios (caudal constante)\n' ...
            '• Rampas lineales ascendentes\n' ...
            '• Rampas lineales descendentes\n\n' ...
            'Las duraciones y amplitudes de cada transición\n' ...
            'se detallan a continuación.\n\n' ...
            '====================================================\n\n']);

        modos = [1 2 3 4 5 6 7 8 91 92 93];

        for m = modos

            [t_puntos, flow_puntos] = obtenerDefinicionModo(m);

            texto = [texto sprintf('Modo R%d\n',m)];
            texto = [texto sprintf('----------------------------------------------------\n')];

            contador = 1;

            for k = 1:length(flow_puntos)-1

                duracion = t_puntos(k+1)-t_puntos(k);

                if abs(flow_puntos(k+1)-flow_puntos(k)) < 1e-9

                    texto = [texto sprintf( ...
                        'Tramo %d: %.2f µL/min durante %.0f s\n', ...
                        contador,...
                        flow_puntos(k),...
                        duracion)];

                else

                    texto = [texto sprintf( ...
                        'Rampa %d: %.2f → %.2f µL/min en %.0f s\n', ...
                        contador,...
                        flow_puntos(k),...
                        flow_puntos(k+1),...
                        duracion)];

                end

                contador = contador + 1;

            end

            texto = [texto sprintf('\nDuración total: %.0f s\n\n',t_puntos(end))];

            texto = [texto sprintf( ...
                '====================================================\n\n')];

        end

    end

    function mostrarManual()

        figManual = uifigure(...
            'Name','Manual de modos',...
            'Position',[200 100 800 700]);

        txt = uitextarea(figManual,...
            'Position',[10 10 780 680],...
            'Editable','off');

        txt.Value = splitlines(generarManualCompleto());

    end

end




