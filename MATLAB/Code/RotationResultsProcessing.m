%% Processing the Results from Rotating the a Single Pillar
clear;
close all;

%% Fixed Geometry, Varying Rotation
AmplitudeData=importdata("rx100ry150Intensity.txt").data; %read intensity
Amplitude=AmplitudeData(:, 2);
Theta=AmplitudeData(:, 1);
Phase = importdata("rx100ry150Phase.txt").data; %read phase
Phase=Phase(:, 2);
Comparison=0.5*sin(2*deg2rad(Theta));

% Amplitude
figure;
tiledlayout(2,1);
nexttile;
plot(Theta, Amplitude,'LineWidth',3,'Color',[0 0.45 0.74]);
xlabel('Theta (degrees)');
ylabel('Amplitude'); 
title('Amplitude: Varying Rotation Angle with a Fixed Geometry');
subtitle('Radius x = 100nm, Radius y= 150nm');
hold on;
plot(Theta, Comparison,'LineWidth',3,'Color',[0.63 0.078 0.18]);
legend({'CST Result','$\frac{1}{2}.sin(2\theta)$ Comparison'},'Interpreter','latex');

% Phase
nexttile;
plot(Theta(2: end), Phase(2:end),'LineWidth',3,'Color',[0 0.45 0.74]);
xlabel('Theta (degrees)');
ylabel('Phase (degrees)'); 
title('Phase: Varying Rotation Angle with a Fixed Geometry');

%% Fixed Rotation, Varying Geometry
AmplitudeData=importdata("30thetaIntensity.txt").data; %read intensity
Amplitude=AmplitudeData(:, 2);
Theta=AmplitudeData(:, 1);
Phase = importdata("30thetaPhase.txt").data; %read phase
Phase=Phase(:, 2);

% Amplitude
figure;
tiledlayout(2,1);
nexttile;
plot(Theta, Amplitude,'LineWidth',3,'Color',[0 0.45 0.74]);
xlabel('rx (nm)');
ylabel('Amplitude'); 
title('Amplitude: Fixed Rotation Angle with Varying Geometry');
subtitle('Rotation: 30 degrees, Geometry Ratio: ry = rx + 50');

%Reflect in the x-axis
Phase=Phase.*(-1);
%move up by 1.238704493595100e+02
Phase=Phase+1.238704493595100e+02;
%shift all the values past the 98th sample of 561 up by 360
index=find(Theta==140);
Phase(index:end)=Phase(index:end)+360;
%normalise to 360 degrees
Phase=Phase./360;


% Phase
nexttile;
plot(Theta(2: end), Phase(2:end),'LineWidth',3,'Color',[0.63 0.078 0.18]);
xlabel('rx (nm)');
ylabel('Phase (2pi normalised)'); 
title('Phase: Fixed Rotation Angle with Varying Geometry');


%% Varying Rotation and Geometry