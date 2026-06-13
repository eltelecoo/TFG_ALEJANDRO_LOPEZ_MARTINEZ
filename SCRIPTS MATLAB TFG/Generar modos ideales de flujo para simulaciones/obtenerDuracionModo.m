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

    case 94
        t_final = 1230;

    otherwise

        error('Modo R%d no definido',modo)

end

end