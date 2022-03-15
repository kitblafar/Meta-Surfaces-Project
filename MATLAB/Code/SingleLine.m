%% SINGLE LINE FOR CST
close all;
clear;
clc;

load('Lens_Small/Lens_Small.mat')

D=combodiam(5,:);
X=-5*410:410:5*410;

%Px=0.41; %period in x in um (distance between pillar centres)
D(end)=85*2;
figure;
scatter(X,D./2,'filled');
title('Radius of 11 Pillars to Simulate in CST for focal length of 2929nm');
ylabel('Radius (nm)')
xlabel('Position of Centre (nm)')