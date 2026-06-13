function mostrarManual()

        figManual = uifigure(...
            'Name','Manual de modos',...
            'Position',[200 100 800 700]);

        txt = uitextarea(figManual,...
            'Position',[10 10 780 680],...
            'Editable','off');

        txt.Value = splitlines(generarManualCompleto());

    end

