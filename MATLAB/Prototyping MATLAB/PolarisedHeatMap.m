%% Polarised HeatMap
% display the phase and instensity values from an ellipse with varying geometry
close all;
clc;
clear;

% Phase
phasefull=readtable('PolarisedPillarPhase.csv');

% Plot a heatmap of the phase according to the geometry map
heatmap(phasefull, 'rx', 'ry', 'ColorVariable', 'Tables_0DResults_AveragePhase', 'Colormap', parula)
title('Heatmap of Polarised Phase')
xlabel('x radius (nm)')
ylabel('y radius (nm)')


% Intensity
intensityfull=readtable('PolarisedPillarIntensity.csv');

% Plot a heatmap of the intensity according to the geometry map
figure;
heatmap(intensityfull, 'rx', 'ry', 'ColorVariable', 'Tables_0DResults_AveragePhase_1', 'Colormap', parula)
title('Heatmap of Polarised Intensity')
xlabel('x radius (nm)')
ylabel('y radius (nm)')

%% compare centre line with results from "Phase_Diameter"

radius = zeros(19,1);
phaseSing = zeros(19,1);
count = 1;
for i=1:361
    if phasefull.rx(i) == phasefull.ry(i)
        radius(count) = phasefull.rx(i);
        phaseSing(count) = phasefull.Tables_0DResults_AveragePhase(i);
        count=count+1;
    end
end

%Reflect in the x-axis
phaseSing=phaseSing.*(-1);

%shift all the values past the 98th sample of 561 up by 360
index=find(radius==100);
phaseSing(index+1:end)=phaseSing(index+1:end)+360;

%normalise to 360 degrees
phaseSing=phaseSing./360;

figure;
plot(radius, phaseSing, 'LineWidth',3,'Color',[0.63 0.078 0.18])
ylabel({'Phase (2pi normalised)'});
xlabel({'Radius (nm)'});
title({'Varying Phase with Pillar Radius: Polarised Simulation'});
subtitle('lambda = 561nm, Height = 695nm')