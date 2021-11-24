%% MODELLING CHANGING PHASE WITH PILLAR DIAMETER
% Based on the figure provided in "Pillars.fig"

clc;
close all;

data=importdata("RadiusSweep.txt"); %import file of changing pahse with diameter
data=data.data;


wavelength1=zeros(size(data,1)/2,1);
wavelength2=zeros(size(data,1)/2,1);
radius=zeros(size(data,1)/2,1);


%%
for j=1:2:size(data,1)

radius((j+1)/2)=data(j,1);
wavelength1((j+1)/2)=data(j,2);
wavelength2((j+1)/2)=data(j+1,2);

end

figure;
plot(radius, wavelength1);
hold on;
plot(radius, wavelength2);
ylabel({'Phase (degrees)'});
xlabel({'Radius (nm)'});
title({'Varying Phase with Pillar Radius'});
legend('560nm','630nm');