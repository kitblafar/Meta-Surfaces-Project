%% SINGLE LINE FOR CST
close all;
clear;
clc;

% Finding a single line for simulating in CST
full=importdata('Lens_Small.txt').data;
X=full(:,1);
Y=full(:,2);
D=full(:,3);

%Px=0.41; %period in x in um (distance between pillar centres)
index=find(Y==0);

figure;
scatter(X(index).*1000,D(index).*1000./2,'filled');
title('Radius of 11 Pillars to Simulate in CST for focal length of 2929nm');
ylabel('Radius (nm)')
xlabel('Position of Centre (nm)')