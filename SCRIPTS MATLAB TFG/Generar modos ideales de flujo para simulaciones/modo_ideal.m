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
