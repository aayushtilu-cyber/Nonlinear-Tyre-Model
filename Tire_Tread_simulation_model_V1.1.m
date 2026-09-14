clear
clc
close all

%% =========================================================
% PARAMETERS
%% =========================================================

a   = 0.10;
b   = 0.08;
re  = 0.30;

Fz  = 3000;
Vc  = 30;

mu0 = 1.0;
cp  = 8e6;
n   = 200;

alpha_deg = -60:0.5:60;
kappa_vec = linspace(-1,1,401);

%% =========================================================
% PLOT STYLE SETTINGS  (only affects plotting, not the model)
%% =========================================================

lw_curve = 1.0;     % thin line width for the data curves
lw_zero  = 1.2;     % line width for the black x=0 / y=0 reference lines
fs       = 10;       % axis/label font size

% small helper used in every figure to draw the black center cross
% (x = 0 and y = 0 reference lines), without polluting the legend
% (defined as a local function at the bottom of this file: addZeroLines)

%% =========================================================
% FY vs ALPHA FOR DIFFERENT KAPPA
%% =========================================================

kappa_set    = -0.4:0.2:0.8;
colors_kappa = turbo(length(kappa_set));

figure('Color','w')
hold on
addZeroLines(lw_zero);

for kk = 1:length(kappa_set)

    kappa = kappa_set(kk);

    Fy_curve = zeros(size(alpha_deg));

    for i = 1:length(alpha_deg)

        alpha = deg2rad(alpha_deg(i));

        [~,Fy_curve(i),~,~,~] = ...
            tread_model( ...
            alpha,...
            0,...
            kappa,...
            Fz,...
            Vc,...
            a,b,re,...
            mu0,...
            cp,...
            n);

    end

    plot(alpha_deg,...
         Fy_curve/1000,...
         'LineWidth',lw_curve,...
         'Color',colors_kappa(kk,:))

end

grid on
box on
set(gca,'FontSize',fs,'Layer','top')
xlabel('Slip Angle \alpha (deg)')
ylabel('F_y (kN)')
title('F_y vs Slip Angle for Different Slip Ratios \kappa')
xlim([min(alpha_deg) max(alpha_deg)])
lgd = legend(string(kappa_set),'Location','eastoutside');
lgd.Title.String = '\kappa';

%% =========================================================
% FX vs KAPPA
%% =========================================================

kappa_plot = linspace(-1,1,200);

alpha = 0;      % fixed slip angle

Fx_kappa = zeros(size(kappa_plot));

for i = 1:length(kappa_plot)

    kappa = kappa_plot(i);

    [Fx_kappa(i),~,~,~,~] = ...
        tread_model( ...
        alpha,...
        0,...
        kappa,...
        Fz,...
        Vc,...
        a,b,re,...
        mu0,...
        cp,...
        n);

end

figure('Color','w')

plot(kappa_plot,...
     Fx_kappa/1000,...
     'LineWidth',2)

grid on
box on

xlabel('Slip Ratio \kappa')
ylabel('F_x (kN)')

title('F_x vs Slip Ratio \kappa')

xlim([-1 1])
%% =========================================================
% MZ vs ALPHA FOR DIFFERENT KAPPA
%% =========================================================

figure('Color','w')
hold on
addZeroLines(lw_zero);

for kk = 1:length(kappa_set)

    kappa = kappa_set(kk);

    Mz_curve = zeros(size(alpha_deg));

    for i = 1:length(alpha_deg)

        alpha = deg2rad(alpha_deg(i));

        [~,~,Mz_curve(i),~,~] = ...
            tread_model( ...
            alpha,...
            0,...
            kappa,...
            Fz,...
            Vc,...
            a,b,re,...
            mu0,...
            cp,...
            n);

    end

    plot(alpha_deg,...
         Mz_curve,...
         'LineWidth',lw_curve,...
         'Color',colors_kappa(kk,:))

end

grid on
box on
set(gca,'FontSize',fs,'Layer','top')
xlabel('Slip Angle \alpha (deg)')
ylabel('M_z (Nm)')
title('M_z vs Slip Angle for Different Slip Ratios \kappa')
xlim([min(alpha_deg) max(alpha_deg)])
lgd = legend(string(kappa_set),'Location','eastoutside');
lgd.Title.String = '\kappa';

%% =========================================================
% FX-FY FOR DIFFERENT ALPHA  (combined slip friction ellipse)
%% =========================================================

alpha_set    = -12:2:12;
colors_alpha = turbo(length(alpha_set));

figure('Color','w')
hold on
addZeroLines(lw_zero);

for aa = 1:length(alpha_set)

    alpha = deg2rad(alpha_set(aa));

    Fx_curve = zeros(size(kappa_vec));
    Fy_curve = zeros(size(kappa_vec));

    for i = 1:length(kappa_vec)

        [Fx_curve(i),Fy_curve(i),~,~,~] = ...
            tread_model( ...
            alpha,...
            0,...
            kappa_vec(i),...
            Fz,...
            Vc,...
            a,b,re,...
            mu0,...
            cp,...
            n);

    end

    plot(Fx_curve/1000,...
         Fy_curve/1000,...
         'LineWidth',lw_curve,...
         'Color',colors_alpha(aa,:))

end

theta = linspace(0,2*pi,1000);

plot(mu0*Fz*cos(theta)/1000,...
     mu0*Fz*sin(theta)/1000,...
     'k--',...
     'LineWidth',1.2)

grid on
box on
axis square
set(gca,'FontSize',fs,'Layer','top')
xlabel('F_x (kN)')
ylabel('F_y (kN)')
title('Combined Slip Friction Ellipse for Different Slip Angles \alpha')
legend([string(alpha_set)+"°","Friction Circle"],...
       'Location','eastoutside')

%% =========================================================
% FY vs ALPHA FOR DIFFERENT CAMBER
%% =========================================================

gamma_set    = 0;
colors_gamma = turbo(length(gamma_set));

figure('Color','w')
hold on
addZeroLines(lw_zero);

for gg = 1:length(gamma_set)

    gamma = deg2rad(gamma_set(gg));

    Fy_curve = zeros(size(alpha_deg));

    for i = 1:length(alpha_deg)

        alpha = deg2rad(alpha_deg(i));

        [~,Fy_curve(i),~,~,~] = ...
            tread_model( ...
            alpha,...
            gamma,...
            0,...
            Fz,...
            Vc,...
            a,b,re,...
            mu0,...
            cp,...
            n);

    end

    plot(alpha_deg,...
         Fy_curve/1000,...
         'LineWidth',lw_curve,...
         'Color',colors_gamma(gg,:))

end

grid on
box on
set(gca,'FontSize',fs,'Layer','top')
xlabel('Slip Angle \alpha (deg)')
ylabel('F_y (kN)')
title('Camber Effect on Lateral Force')
xlim([min(alpha_deg) max(alpha_deg)])
lgd = legend(string(gamma_set)+"°",'Location','eastoutside');
lgd.Title.String = '\gamma';

%% =========================================================
% MZ vs ALPHA FOR DIFFERENT CAMBER
%% =========================================================

figure('Color','w')
hold on
addZeroLines(lw_zero);

for gg = 1:length(gamma_set)

    gamma = deg2rad(gamma_set(gg));

    Mz_curve = zeros(size(alpha_deg));

    for i = 1:length(alpha_deg)

        alpha = deg2rad(alpha_deg(i));

        [~,~,Mz_curve(i),~,~] = ...
            tread_model( ...
            alpha,...
            gamma,...
            0,...
            Fz,...
            Vc,...
            a,b,re,...
            mu0,...
            cp,...
            n);

    end

    plot(alpha_deg,...
         Mz_curve,...
         'LineWidth',lw_curve,...
         'Color',colors_gamma(gg,:))

end

grid on
box on
set(gca,'FontSize',fs,'Layer','top')
xlabel('Slip Angle \alpha (deg)')
ylabel('M_z (Nm)')
title('Camber Effect on Aligning Torque')
xlim([min(alpha_deg) max(alpha_deg)])
lgd = legend(string(gamma_set)+"°",'Location','eastoutside');
lgd.Title.String = '\gamma';

%% =========================================================
% FX-FY FOR DIFFERENT CAMBER
%% =========================================================

figure('Color','w')
hold on
addZeroLines(lw_zero);

for gg = 1:length(gamma_set)

    gamma = deg2rad(gamma_set(gg));

    Fx_curve = zeros(size(kappa_vec));
    Fy_curve = zeros(size(kappa_vec));

    for i = 1:length(kappa_vec)

        [Fx_curve(i),Fy_curve(i),~,~,~] = ...
            tread_model( ...
            deg2rad(5),...
            gamma,...
            kappa_vec(i),...
            Fz,...
            Vc,...
            a,b,re,...
            mu0,...
            cp,...
            n);

    end

    plot(Fx_curve/1000,...
         Fy_curve/1000,...
         'LineWidth',lw_curve,...
         'Color',colors_gamma(gg,:))

end

plot(mu0*Fz*cos(theta)/1000,...
     mu0*Fz*sin(theta)/1000,...
     'k--',...
     'LineWidth',1.2)

grid on
box on
axis square
set(gca,'FontSize',fs,'Layer','top')
xlabel('F_x (kN)')
ylabel('F_y (kN)')
title('Camber Effect on Friction Ellipse (\alpha = 5°)')
legend([string(gamma_set)+"°","Friction Circle"],...
       'Location','eastoutside')

%% =========================================================
% LOCAL PLOTTING HELPER (not part of the tire model)
%% =========================================================

function addZeroLines(lw)
    xline(0,'k-','LineWidth',lw,'HandleVisibility','off');
    yline(0,'k-','LineWidth',lw,'HandleVisibility','off');
end

%% =========================================================
% TREAD MODEL FUNCTION -- UNCHANGED FROM ORIGINAL
%% =========================================================

function [Fx,Fy,Mz,Mx,slide_count] = tread_model( ...
                alpha,...
                gamma,...
                kappa,...
                Fz,...
                Vc,...
                a,b,re,...
                mu0,...
                cp,...
                n)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONTACT PATCH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xb = linspace(a,-a,n);

dx = abs(xb(2)-xb(1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ROLLING KINEMATICS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Vr = Vc/(1-kappa);

Omega = Vr/re;

dt = dx/Vr;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SLIP VELOCITIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Vsx = -Vc*kappa;

Vsy = -Vc*tan(alpha);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MULTI ROW TREAD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nRows = 11;

yrow = linspace(-b,b,nRows);

dyrow = (2*b)/(nRows-1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTPUT INITIALIZATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Fx = 0;
Fy = 0;
Mz = 0;
Mx = 0;

slide_count = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PRESSURE NORMALIZATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ShapeSum = 0;

for r = 1:nRows

    yb0 = yrow(r);

    for i = 1:n

        px = max(0,1-(xb(i)/a)^2);

        py = sqrt(max(0,1-(yb0/b)^2));

        ShapeSum = ShapeSum + px*py*dx*dyrow;

    end
end

qz0 = Fz/ShapeSum;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAIN LOOP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for r = 1:nRows

    yb0 = yrow(r);

    ex = 0;
    ey = 0;

    for i = 1:n

        px = max(0,1-(xb(i)/a)^2);

        py = sqrt(max(0,1-(yb0/b)^2));

        qz = qz0*px*py;

        if qz <= 0
            continue
        end

        dybdx = (xb(i)/re)*sin(gamma);

        Vbx = Vsx + yb0*Omega*sin(gamma);

        Vby = Vsy - Vr*dybdx;

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % CONSTANT FRICTION
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        qlimit = mu0*qz;

        Dsx = Vbx*dt;

        Dsy = Vby*dt;

        ex_trial = ex - Dsx;

        ey_trial = ey - Dsy;

        qx_trial = cp*ex_trial;

        qy_trial = cp*ey_trial;

        qtrial = hypot(qx_trial,qy_trial);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % ADHESION
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        if qtrial <= qlimit

            ex = ex_trial;
            ey = ey_trial;

            qx = cp*ex;
            qy = cp*ey;

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % SLIDING
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        else

            slide_count = slide_count + 1;

            e_i = qlimit/cp;

            norm_trial = hypot(ex_trial,ey_trial);

            if norm_trial > 1e-12

                ex = e_i*ex_trial/norm_trial;

                ey = e_i*ey_trial/norm_trial;

            else

                ex = 0;
                ey = 0;

            end

            qx = cp*ex;
            qy = cp*ey;

        end

        dA = dx*dyrow;

        dFx = qx*dA;
        dFy = qy*dA;

        Fx = Fx + dFx;
        Fy = Fy + dFy;

        Mz = Mz + xb(i)*dFy - yb0*dFx;

        Mx = Mx + yb0*dFy;

    end
end

end
