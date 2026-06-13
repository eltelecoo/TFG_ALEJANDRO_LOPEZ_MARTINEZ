function microfluidic_sensor_GUI_equations
% GUI implementing user's equations (all geometry in mm).
% (same header comments as before)...

fig = uifigure('Name','Microfluidic Sensor Simulator (User Equations)','Position',[100 100 1200 620]);

% --- Input fields ---
uilabel(fig,'Position',[20 560 200 20],'Text','\rho_{Track} (Ohm·mm)');
rhoTrackField = uieditfield(fig,'numeric','Position',[230 560 120 22],'Value',102);

uilabel(fig,'Position',[20 525 200 20],'Text','\sigma_{Solution} (mS/cm)');
sigmaSolField = uieditfield(fig,'text','Position',[230 525 120 22],'Value','8.31');

uilabel(fig,'Position',[20 490 200 20],'Text','L_{total} (mm)');
LtotalField = uieditfield(fig,'numeric','Position',[230 490 120 22],'Value',85);

uilabel(fig,'Position',[20 455 200 20],'Text','w_{electrode} (mm)');
wElectField = uieditfield(fig,'numeric','Position',[230 455 120 22],'Value',0.537);

uilabel(fig,'Position',[20 420 200 20],'Text','h_{channel} (mm)');
hChannelField = uieditfield(fig,'numeric','Position',[230 420 120 22],'Value',0.382);

uilabel(fig,'Position',[20 385 200 20],'Text','w_{channel} (mm)');
wChannelField = uieditfield(fig,'numeric','Position',[230 385 120 22],'Value',0.437);

uilabel(fig,'Position',[20 350 200 20],'Text','Flow Rates FR (µL/min), comma-separated');
FRField = uieditfield(fig,'text','Position',[230 350 240 22],'Value','0.5,1,1.5');

uilabel(fig,'Position',[20 315 200 20],'Text','Time step \Delta t (s)');
dtField = uieditfield(fig,'numeric','Position',[230 315 120 22],'Value',0.1);

uilabel(fig,'Position',[20 280 200 20],'Text','R_{connection} (k\Omega)');
RconnField = uieditfield(fig,'numeric','Position',[230 280 120 22],'Value',0);

% Buttons (moved to left so they don't cover plot)
btnCalc = uibutton(fig,'push','Text','Calculate & Plot','Position',[20 230 150 30],...
    'ButtonPushedFcn',@(btn,event) calculateAndPlot());
btnSlopes = uibutton(fig,'push','Text','Show dR/dt Slopes & t_c & Calibration','Position',[180 230 380 30],...
    'ButtonPushedFcn',@(btn,event) showSlopesAndCalibration());
btnExport = uibutton(fig,'push','Text','Export Resistances to Excel','Position',[20 190 220 30],...
    'ButtonPushedFcn',@(btn,event) exportToExcel());

% ====== ADDED BY CHATGPT: Button to compute FR from dR/dt ======
btnFRcalc = uibutton(fig,'push','Text','Compute FR from dR/dt',...
    'Position',[20 150 220 30],...
    'ButtonPushedFcn',@(btn,event) computeFRfromSlope());
% ===============================================================


% Axes for plotting (right side)
ax = uiaxes(fig,'Position',[450 60 720 520]);
xlabel(ax,'L_{filled} (mm)')
ylabel(ax,'Resistance (k\Omega)')
title(ax,'Resistances vs L_{filled}')
grid(ax,'on')
hold(ax,'off')

% Stored data for export
storedData = struct();

% ================= Calculate & Plot =================
    function calculateAndPlot()
        % Read inputs
        rhoTrack_mm = rhoTrackField.Value;          % Ω·mm (user)
        sigma_input = strtrim(sigmaSolField.Value);
        sigma_list = str2double(strsplit(sigma_input,','));
        sigma_list = sigma_list(~isnan(sigma_list));
        if isempty(sigma_list), sigma_list = 8.31; end
        sigma_mScm = sigma_list(1);                 % mS/cm

        L_total_mm = LtotalField.Value;
        w_elect_mm = wElectField.Value;
        h_channel_mm = hChannelField.Value;
        w_channel_mm = wChannelField.Value;

        FR_input = strtrim(FRField.Value);
        FR_list = str2double(strsplit(FR_input,','));
        FR_list = FR_list(~isnan(FR_list));
        if isempty(FR_list)
            FR_list = 1; % default if none
        end
        FR_for_plot = FR_list(1);                   % µL/min used to plot

        dt = dtField.Value;
        if ~(isnumeric(dt) && dt>0), dt = 0.1; end

        R_conn_k = RconnField.Value;                % kΩ

        % --- Convert conductivity to resistivity in Ω·mm ---
        % sigma (mS/cm) -> S/m : *0.1
        sigma_S_per_m = sigma_mScm * 0.1;           % S/m
        rhoSol_Ohmm = (1 / sigma_S_per_m) * 1000;   % Ω·mm  (Ω·m *1000 -> Ω·mm)

        % --- Flow convert: µL/min -> mm^3/s ---
        Q_mm3s = FR_for_plot / 60;                  % mm^3/s (1 µL = 1 mm^3)

        if Q_mm3s <= 0
            uialert(fig,'Flow rate must be positive.','Input error'); return
        end

        % --- Time vector (avoid t=0 to prevent division by zero in solution term) ---
        t_max = (L_total_mm * h_channel_mm * w_channel_mm) / Q_mm3s; % seconds
        if t_max <= dt
            t = dt;
        else
            t = dt:dt:t_max;   % start at dt to avoid t=0
        end

        % --- L_filled (mm) from eq (6): L_filled = (FR * t)/(h*w_ch), FR in mm^3/s ---
        L_filled_mm = (Q_mm3s .* t) ./ (h_channel_mm * w_channel_mm);
        L_filled_mm(L_filled_mm > L_total_mm) = L_total_mm;

        % --- L_track (mm)
        L_track_mm = L_total_mm - L_filled_mm;
        L_track_mm(L_track_mm < 0) = 0;

        % --- R_track (Ω) eq (2)/(4)
        R_track_Ohm = rhoTrack_mm .* L_track_mm ./ (h_channel_mm .* w_elect_mm);

        % --- R_solution (Ω) eq (5) protected with small L_filled
        L_fill_safe = max(L_filled_mm, 1e-12);
        R_solution_Ohm = rhoSol_Ohmm .* w_channel_mm ./ (h_channel_mm .* L_fill_safe);

        % --- R_total (Ω) eq (1) & (9): R_total = R_solution + 2 R_track + R_connections
        R_total_Ohm = R_solution_Ohm + 2 .* R_track_Ohm;   % Ω
        % Convert to kΩ and add R_connection (kΩ)
        R_total_k = R_total_Ohm ./ 1000 + R_conn_k;
        R_track_k = R_track_Ohm ./ 1000;
        R_solution_k = R_solution_Ohm ./ 1000;
        double_R_track_k = 2 .* R_track_k;

        % --- Store for export ---
        storedData.time = t(:);
        storedData.L_filled_mm = L_filled_mm(:);
        storedData.R_Total_k = R_total_k(:);
        storedData.R_Track_k = R_track_k(:);
        storedData.R_Solution_k = R_solution_k(:);
        storedData.double_R_track_k = double_R_track_k(:);
        storedData.R_connection_k = R_conn_k;
        storedData.FR_used = FR_for_plot;
        storedData.rhoSol_Ohmm = rhoSol_Ohmm;
        storedData.rhoTrack_Ohmm = rhoTrack_mm;

        % --- Plot ---
        cla(ax);
        hold(ax,'on')
        plot(ax, L_filled_mm, R_total_k, 'r-', 'LineWidth', 2);
        plot(ax, L_filled_mm, double_R_track_k, 'b-', 'LineWidth', 2);
        plot(ax, L_filled_mm, R_solution_k, 'g-', 'LineWidth', 2);
        yline(ax, R_conn_k, 'k--', 'LineWidth', 1.5, 'Label','R_{connection}','LabelHorizontalAlignment','left');
        hold(ax,'off')
        xlabel(ax,'L_{filled} (mm)')
        ylabel(ax,'Resistance (k\Omega)')
        legend(ax,'R_{Total}','2\timesR_{Track}','R_{Solution}','R_{connection}','Location','northeast')
        grid(ax,'on')

        maxY = max([R_total_k(:); double_R_track_k(:); R_solution_k(:); R_conn_k]);
        if isfinite(maxY) && maxY>0
            ylim(ax,[0 1.1*maxY]);
        end
    end

% ================= Slopes & t_c & calibration =================
    function showSlopesAndCalibration()

        % Read local copies of needed GUI inputs (FIX: dt and geometry must be defined here)
        rhoTrack_mm = rhoTrackField.Value;
        h_channel_mm = hChannelField.Value;
        w_channel_mm = wChannelField.Value;
        w_elect_mm = wElectField.Value;

        dt = dtField.Value;                       % <<< ADDED: read dt locally
        if ~(isnumeric(dt) && dt>0), dt = 0.1; end % guard

        sigma_input = strtrim(sigmaSolField.Value);
        sigma_list = str2double(strsplit(sigma_input,','));
        sigma_list = sigma_list(~isnan(sigma_list));
        if isempty(sigma_list), sigma_list = 8.31; end
        sigma_mScm = sigma_list(1);

        sigma_S_per_m = sigma_mScm * 0.1;
        rhoSol_Ohmm = (1 / sigma_S_per_m) * 1000;    % Ω·mm

        FR_input = strtrim(FRField.Value);
        FR_list = str2double(strsplit(FR_input,','));
        FR_list = FR_list(~isnan(FR_list));
        if isempty(FR_list)
            uialert(fig,'Please enter at least one flow rate.','Input required');
            return
        end

        nFR = length(FR_list);
        slope_vals = NaN(nFR,1);
        t_c_vals = NaN(nFR,1);

        for k = 1:nFR
            FR_ulmin = FR_list(k);
            Q_mm3s = FR_ulmin / 60;

            slope_Ohm_s = - (2 * rhoTrack_mm * Q_mm3s) / ...
                (h_channel_mm^2 * w_elect_mm * w_channel_mm);
            slope_vals(k) = slope_Ohm_s / 1000;

            numer = rhoSol_Ohmm * (h_channel_mm^2) * ...
                (w_channel_mm^3) * w_elect_mm;
            denom = 2 * rhoTrack_mm * (Q_mm3s^2);
            if denom > 0
                t_c_vals(k) = sqrt(numer / denom);
            else
                t_c_vals(k) = NaN;
            end
        end

        % (original table window)
        figTable = uifigure('Name','dR/dt Slopes + t_c','Position',[360 250 420 260]);
        uitable(figTable,'Data',[FR_list(:), slope_vals(:), t_c_vals(:)],...
            'ColumnName',{'FR (µL/min)','dR/dt (kΩ/s)','t_c (s)'},...
            'Position',[10 10 400 240]);


        % =====================================================================
        % >>> NEW: PLOT OF DERIVATIVES vs TIME (R_solution, R_track, R_total)
        % =====================================================================

        FR_for_deriv = FR_list(1);   % Use first FR for derivative graph
        Q_mm3s = FR_for_deriv / 60;

        % Compute t_c for vertical line
        numer = rhoSol_Ohmm * (h_channel_mm^2) * (w_channel_mm^3) * w_elect_mm;
        denom = 2 * rhoTrack_mm * (Q_mm3s^2);
        if denom > 0
            t_c_first = sqrt(numer / denom);
        else
            t_c_first = NaN;
        end

        % Compute t_max locally for the derivative plot (FIX: ensure t_max defined here)
        L_total_mm = LtotalField.Value;                % read L_total
        if Q_mm3s <= 0
            uialert(fig,'Flow rate must be positive.','Input error');
            return
        end
        t_max = (L_total_mm * h_channel_mm * w_channel_mm) / Q_mm3s; % seconds

        % Time vector: start at dt, end at t_max (avoid t=0)
        if t_max <= dt
            t = linspace(dt, dt, 1);
        else
            t = linspace(dt, t_max, 400);  % safe domain
        end

        % Derivative of solution term:  -(rho_sol * w_ch^2)/(FR * t^2)
        dRdt_solution = -(rhoSol_Ohmm * w_channel_mm^2) ./ (Q_mm3s .* t.^2);

        % Derivative of track term: constant slope = -2 * rho_track * FR/(h^2 * w_e * w_ch)
        dRdt_track = -(2 * rhoTrack_mm * Q_mm3s) ./ ...
            (h_channel_mm^2 * w_elect_mm * w_channel_mm);

        dRdt_track_full = dRdt_track * ones(size(t));

        % Total derivative
        dRdt_total = dRdt_solution + dRdt_track_full;

        % Convert to kΩ/s
        dRdt_solution_k = dRdt_solution / 1000;
        dRdt_track_k = dRdt_track_full / 1000;
        dRdt_total_k = dRdt_total / 1000;

        % Create figure
        figDer = uifigure('Name','Derivatives of R(t)','Position',[850 120 600 430]);
        axD = uiaxes(figDer,'Position',[70 60 500 340]);

        plot(axD, t, dRdt_total_k, 'k', 'LineWidth', 2); hold(axD,'on');
        plot(axD, t, dRdt_solution_k, 'g', 'LineWidth', 1.5);
        plot(axD, t, dRdt_track_k, 'b', 'LineWidth', 1.5);

        if ~isnan(t_c_first)
            xline(axD, t_c_first, '--r', 't_c','LineWidth',1.5);
        end
        ylim(axD, [-1 1]);  % kΩ/s range for better visibility of linear regime
        xlabel(axD,'Time (s)');
        ylabel(axD,'dR/dt (kΩ/s)');
        title(axD,sprintf('Derivatives at FR = %.3f µL/min', FR_for_deriv));
        legend(axD,{'dR_{total}/dt','dR_{solution}/dt','d(2R_{track})/dt','t_c'},...
            'Location','southwest');
        grid(axD,'on');

        % =====================================================================
        % >>> ADDED: PLOT OF DERIVATIVES vs L_filled (same derivatives)
        % =====================================================================

        % Convert time vector to L_filled using SAME relation as main model
        L_filled_deriv = (Q_mm3s .* t) ./ (h_channel_mm * w_channel_mm);

        % Clip to L_total for safety
        L_filled_deriv(L_filled_deriv > L_total_mm) = L_total_mm;

        % Create figure
        figDerL = uifigure('Name','Derivatives of R(L_{filled})','Position',[850 580 600 430]);
        axDL = uiaxes(figDerL,'Position',[70 60 500 340]);

        % =====================================================================
        % >>> NEW: PLOT OF DERIVATIVES vs L_filled (dR_tot/dL, dR_sol/dL, 2R_track/dL)
        % =====================================================================

        % Compute derivatives w.r.t L_filled (keep negative as in formulas)
        dRsol_dL = -rhoSol_Ohmm * w_channel_mm ./ (h_channel_mm * L_filled_deriv.^2);
        dRtrack_dL = -2 * rhoTrack_mm / (h_channel_mm * w_elect_mm);
        dRtot_dL = dRsol_dL + dRtrack_dL;

        % Critical length L_c (track = 90% of total)
        Lc = sqrt(0.9 * rhoSol_Ohmm * w_channel_mm * w_elect_mm / (0.2 * rhoTrack_mm));

        % Create figure
        figDerL = uifigure('Name','Derivatives of R(L_{filled})','Position',[850 580 600 430]);
        axDL = uiaxes(figDerL,'Position',[70 60 500 340]);

        plot(axDL, L_filled_deriv, dRtot_dL, 'k', 'LineWidth', 2); hold(axDL,'on');
        plot(axDL, L_filled_deriv, dRsol_dL, 'g', 'LineWidth', 1.5);
        plot(axDL, L_filled_deriv, dRtrack_dL * ones(size(L_filled_deriv)), 'b', 'LineWidth', 1.5);
        xline(axDL, Lc, '--r', 'L_c','LineWidth',1.5);

        % ylim(axDL, [-1 1]);  % limit y-axis as requested
        xlabel(axDL,'L_{filled} (mm)');
        ylabel(axDL,'dR/dL (Ω/mm)');
        title(axDL,sprintf('Derivatives vs L_{filled} at FR = %.3f µL/min', FR_for_deriv));
        legend(axDL,{'dR_{total}/dL','dR_{solution}/dL','2*dR_{track}/dL','L_c'},...
            'Location','southwest');
        grid(axDL,'on');

        % =====================================================================
        % <<< END ADDED BLOCK
        % =====================================================================



        % (original calibration plot)
        figCal = uifigure('Name','Calibration Curve','Position',[800 250 500 400]);
        axCal = uiaxes(figCal,'Position',[70 80 380 280]);
        p = polyfit(FR_list, slope_vals, 1);
        FR_fit = linspace(min(FR_list), max(FR_list), 100);
        slope_fit = polyval(p, FR_fit);

        plot(axCal, FR_list, slope_vals, 'ro', 'MarkerSize', 8, 'LineWidth', 1.5); hold(axCal,'on');
        plot(axCal, FR_fit, slope_fit, 'b-', 'LineWidth', 1.5); hold(axCal,'off');
        xlabel(axCal,'Flow Rate (µL/min)');
        ylabel(axCal,'dR/dt (kΩ/s)');
        title(axCal,'Calibration Curve: dR/dt vs Flow Rate');
        legend(axCal, {'Data','Linear fit'}, 'Location','northwest');
        grid(axCal,'on');

        uilabel(figCal,'Position',[70 30 380 40],...
            'Text',sprintf('Fit: slope = %.6g  intercept = %.6g', p(1), p(2)));
    end

% ================= Export to Excel =================
    function exportToExcel()
        if ~isfield(storedData,'R_Total_k')
            uialert(fig,'Please press Calculate & Plot first before exporting.','Error');
            return
        end

        R_conn_vec = storedData.R_connection_k * ones(size(storedData.time));

        % ==== ADDED CODE: compute derivatives (kΩ/s) ====
        dt_local = storedData.time(2) - storedData.time(1);

        dR_total_dt    = [0; diff(storedData.R_Total_k)] ./ dt_local;
        dR_solution_dt = [0; diff(storedData.R_Solution_k)] ./ dt_local;
        d2R_track_dt   = [0; diff(storedData.double_R_track_k)] ./ dt_local;
        % ===============================================
        % ===================================================================
        % >>> ADDED: compute dR/dL_filled (kΩ/mm)
        % ===================================================================

        dLdt = (storedData.FR_used/60) ./ ...
            (hChannelField.Value * wChannelField.Value);

        dR_total_dL    = dR_total_dt    ./ dLdt;
        dR_solution_dL = dR_solution_dt ./ dLdt;
        d2R_track_dL   = d2R_track_dt   ./ dLdt;

        % ===================================================================

        % ==== MODIFIED table: added derivative columns ====
        dataTable = table(storedData.time, storedData.L_filled_mm, storedData.R_Total_k, ...
            storedData.double_R_track_k, storedData.R_Solution_k, R_conn_vec, ...
            dR_total_dt, dR_solution_dt, d2R_track_dt, ...
            dR_total_dL, dR_solution_dL, d2R_track_dL, ...
            'VariableNames',{'Time_s','L_filled_mm','R_Total_kOhm','2R_Track_kOhm', ...
            'R_Solution_kOhm','R_Connection_kOhm', ...
            'dR_total_dt_kOhm_per_s','dR_solution_dt_kOhm_per_s', ...
            'd2R_track_dt_kOhm_per_s', ...
            'dR_total_dL_kOhm_per_mm','dR_solution_dL_kOhm_per_mm', ...
            'd2R_track_dL_kOhm_per_mm'});

        % ================================================

        % ==================================================


        [file,path] = uiputfile('resistance_data_mm_units.xlsx','Save Resistance Data');
        if isequal(file,0), return; end

        writetable(dataTable, fullfile(path,file));
        uialert(fig,'Data successfully exported to Excel.','Export complete');
    end
% =====================================================================
% ====== ADDED BY CHATGPT: Compute FR from measured dR/dt =============
% =====================================================================
    function computeFRfromSlope()

        prompt = {'Enter measured dR/dt (kΩ/s):','Enter time t (s):'};
        dlgtitle = 'Compute FR from dR/dt';
        dims = [1 40];
        definput = {'-0.10','5'};
        answer = inputdlg(prompt,dlgtitle,dims,definput);

        if isempty(answer)
            return
        end

        dRdt_k = str2double(answer{1});
        t_val  = str2double(answer{2});

        if isnan(dRdt_k) || isnan(t_val) || t_val <= 0
            uialert(fig,'Invalid input.','Error');
            return
        end

        % Read geometry + rho
        rhoTrack_mm   = rhoTrackField.Value;
        h_channel_mm  = hChannelField.Value;
        w_channel_mm  = wChannelField.Value;
        w_elect_mm    = wElectField.Value;

        % Resistivity of solution from σ
        sigma_input = strtrim(sigmaSolField.Value);
        sigma_list  = str2double(strsplit(sigma_input,','));
        sigma_list  = sigma_list(~isnan(sigma_list));
        if isempty(sigma_list), sigma_list = 8.31; end
        sigma_mScm  = sigma_list(1);
        sigma_S_per_m = sigma_mScm*0.1;
        rhoSol_Ohmm = (1/sigma_S_per_m)*1000;

        % Convert slope to Ω/s
        dRdt = dRdt_k * 1000;

        % ==========================
        % FULL FORMULA (quadratic)
        % dR/dt = -(rho_sol*w_ch²)/(FR*t²) - 2*rho_track*FR/(h²*w_e*w_ch)
        % => A*FR² + B*FR + C = 0
        % ==========================

        A = 2*rhoTrack_mm/(h_channel_mm^2*w_elect_mm*w_channel_mm);
        B = dRdt;
        C = rhoSol_Ohmm*(w_channel_mm^2)/(t_val^2);

        % Quadratic solution (units mm³/s)
        FR_full_roots = [(-B + sqrt(B^2 - 4*A*C)) / (2*A), ...
            (-B - sqrt(B^2 - 4*A*C)) / (2*A)];

        % Keep only positive real values
        FR_full_mm3s = FR_full_roots(imag(FR_full_roots)==0 & FR_full_roots>0);

        if isempty(FR_full_mm3s)
            FR_full_mm3s = NaN;
        else
            FR_full_mm3s = FR_full_mm3s(1);
        end

        FR_full_ulmin = FR_full_mm3s * 60;

        % ==========================
        % TRACK-ONLY LINEAR FORMULA
        % dR/dt ≈ -2*rho_track*FR/(h²*w_e*w_ch)
        % ==========================
        FR_linear_mm3s = - dRdt * (h_channel_mm^2*w_elect_mm*w_channel_mm) / ...
            (2*rhoTrack_mm);

        FR_linear_ulmin = FR_linear_mm3s * 60;

        % ==========================
        % SHOW OUTPUT WINDOW
        % ==========================
        figRes = uifigure('Name','FR estimation','Position',[850 300 420 200]);
        uitable(figRes,'Data',...
            [FR_full_ulmin, FR_linear_ulmin],...
            'ColumnName',{'FR (full model) µL/min','FR (track-only) µL/min'},...
            'Position',[20 20 380 150]);

    end
% =====================================================================
% ================= END OF ADDED BLOCK ================================
% =====================================================================

end
