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
%% ry=rx+50
AmplitudeData=importdata("30thetaIntensity.txt").data; %read intensity
Amplitude=AmplitudeData(:, 2);
rx=AmplitudeData(:, 1);
Phase = importdata("30thetaPhase.txt").data; %read phase
rx1= Phase(:, 1);
Phase=Phase(:, 2);

% Amplitude
figure;
tiledlayout(2,1);
nexttile;
plot(rx, Amplitude,'LineWidth',3,'Color',[0 0.45 0.74]);
xlabel('rx (nm)');
ylabel('Amplitude'); 
title('Amplitude: Fixed Rotation Angle with Varying Geometry');
subtitle('Rotation: 30 degrees, Geometry Ratio: ry = rx + 50');

%Reflect in the x-axis
Phase=Phase.*(-1);
%shift all the values up to the 140rx sample
index=find(rx==135);
Phase(1:index)=Phase(1:index)-360;
%shift all up by 360
Phase=Phase+360;
%normalise to 360 degrees
Phase=Phase./360;
Phase=Phase+0.356310359555972;

% Phase
nexttile;
plot(rx, Phase,'LineWidth',3,'Color',[0.63 0.078 0.18]);
xlabel('rx (nm)');
ylabel('Phase (2pi normalised)'); 
title('Phase: Fixed Rotation Angle with Varying Geometry');

%% ry=1.5*rx
AmplitudeData=importdata("Theta30Ryrx1.5Intensity.txt").data; %read intensity
Amplitude=AmplitudeData(:, 2);
Theta=AmplitudeData(:, 1);
Phase = importdata("Theta30Ryrx1.5Phase.txt").data; %read phase
Phase=Phase(:, 2);

% Amplitude
figure;
tiledlayout(2,1);
nexttile;
plot(Theta, Amplitude,'LineWidth',3,'Color',[0 0.45 0.74]);
xlabel('rx (nm)');
ylabel('Amplitude'); 
title('Amplitude: Fixed Rotation Angle with Varying Geometry');
subtitle('Rotation: 30 degrees, Geometry Ratio: ry = rx*1.5');

%Reflect in the x-axis
Phase=Phase.*(-1);
%move up by 1.238704493595100e+02
Phase=Phase+1.238704493595100e+02;
%shift all the values past the 98th sample of 561 up by 360
index=find(Theta==140);
%normalise to 360 degrees
Phase=Phase./360;

% Phase
nexttile;
plot(Theta, Phase,'LineWidth',3,'Color',[0.63 0.078 0.18]);
xlabel('rx (nm)');
ylabel('Phase (2pi normalised)'); 
title('Phase: Fixed Rotation Angle with Varying Geometry');

%% ry=120
AmplitudeData=importdata("Theta30Ry120Intensity.txt").data; %read intensity
Amplitude=AmplitudeData(:, 2);
rx=AmplitudeData(:, 1);
Phase = importdata("Theta30Ry120Phase.txt").data; %read phase
Phase=Phase(:, 2);

% Amplitude
figure;
tiledlayout(2,1);
nexttile;
plot(rx, Amplitude,'LineWidth',3,'Color',[0 0.45 0.74]);
xlabel('rx (nm)');
ylabel('Amplitude'); 
title('Amplitude: Fixed Rotation Angle with Varying Geometry');
subtitle('Rotation: 30 degrees, Geometry Ratio: ry = 120nm');

%Reflect in the x-axis
Phase=Phase.*(-1);
%normalise to 360 degrees
Phase=Phase./360;
Phase=Phase+0.323111430757000;


% Phase
nexttile;
plot(rx, Phase,'LineWidth',3,'Color',[0.63 0.078 0.18]);
xlabel('rx (nm)');
ylabel('Phase (2pi normalised)'); 
title('Phase: Fixed Rotation Angle with Varying Geometry');


%% Varying Rotation and Geometry