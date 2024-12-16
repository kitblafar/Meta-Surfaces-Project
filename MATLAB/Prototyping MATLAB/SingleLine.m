%% SINGLE LINE FOR CST
close all;
clc;

D=combodiam(5,:);
X=-5*410:410:5*410;

%Px=0.41; %period in x in um (distance between pillar centres)
D(end)=100;
figure;
scatter(X,D./2,'filled');
title('50% Amplitude, 3um Focal Length: Radius of 11 Pillars');
ylabel('Radius (nm)')
xlabel('Position of Centre (nm)')

R=comborotat(5,:);
R(end)=38;
figure;
scatter(X,R,'filled');
title('50% Amplitude, 3um Focal Length: Rotation of 11 Pillars');
ylabel('Rotation (degrees)')
xlabel('Position of Centre (nm)')