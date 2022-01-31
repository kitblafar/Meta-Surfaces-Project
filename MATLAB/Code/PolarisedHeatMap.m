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