%% MODELLING CHANGING PHASE WITH PILLAR DIAMETER
% Based on the figure provided in "Pillars.fig"

clc;
close all;
clear;

%% Plot Phase
%read each phase data
data=importdata("561PhaseRadius.txt"); %import file of changing intensity with diameter
phase1=data.data(:,2);
radiusOrg1=data.data(:,1);
data=importdata("633PhaseRadius.txt"); %import file of changing intensity with diameter
phase2=data.data(:,2);
radiusOrg2=data.data(:,1);
radius=20:200;

%Reflect in the x-axis
phase1=phase1.*(-1);
phase2=phase2.*(-1);

%shift 630nm wavelgth phase up by 178.96722365119
phase2=phase2+178.96722365119;

%shift 560nm down by 49.558876956751
phase1=phase1-49.558876956751;

%shift all the values past the 98th sample of 561 up by 360
index=find(radiusOrg1==101);
phase1(index:end)=phase1(index:end)+360;

%shift all the values up to the 40th sample of 633 down by 360
index=find(radiusOrg2==40);
phase2(1:index)=phase2(1:index)-360;

%normalise to 360 degrees
phase1=phase1./360;
phase2=phase2./360;

%interpolate to the same radius values
phase1=interp1(radiusOrg1.', phase1.', radius);
phase2=interp1(radiusOrg2.', phase2.', radius);

%plot phase
figure;
tiledlayout(2,1);
nexttile;
plot(radius, phase1,'LineWidth',3,'Color',[0.63 0.078 0.18]);
hold on;
plot(radius, phase2,'LineWidth',3,'Color',[0 0.45 0.74]);
ylabel({'Phase (2pi normalised)'});
xlabel({'Radius (nm)'});
title({'Varying Phase with Pillar Radius (Height= 695nm)'});

%% Find indeces for 530nm which gives 10 pillars with even phase jumps from 0 -> 2pi
step=(1)/9;

%initialise values and index array
index1=zeros(10,1);
index2=zeros(10,1);

%set the index and values
for i=1:10
    p=step*(i-1);
    [~,index1(i)]=min(abs(phase1-p));
    %round to the nearest 5 or 10 as this can be done by the optical setup
    index1(i)=round( index1(i) / 5 ) * 5+1;
end

% for the zero phase value choose a higher value as the initial section of
% the graph is approximatley linear (done by eye)
index1(1)=find(radius==50);
%to improve intensity response move 110 radius (5th value) to 115
index1(5)=find(radius==115);

for i=1:10
    radiusVal=radius(index1(i));
    index2(i)=find(radius==radiusVal);
end

%mark on plot to see nearest 5nm value
hold on;
scatter(radius(index1),phase1(index1),'filled');
legend('561nm','633nm','Chosen Values');

%% Plot Intensity
%read each intensity data
data=importdata("561IntensityRadius.txt"); %import file of changing intensity with diameter
intensity1=data.data(:,2);
intensity1=intensity1.*intensity1; %intensity is A^2
radiusOrg1=data.data(:,1);
data=importdata("633IntensityRadius.txt"); %import file of changing intensity with diameter
intensity2=data.data(:,2);
intensity2=intensity2.*intensity2; %intensity is A^2
radiusOrg2=data.data(:,1);

%interpolate to the same radius values
intensity1=interp1(radiusOrg1.', intensity1.', radius);
intensity2=interp1(radiusOrg2.', intensity2.', radius);

%plot intensity
nexttile;
plot(radius, intensity1,'LineWidth',3,'Color',[0.63 0.078 0.18]);
hold on;
plot(radius, intensity2,'LineWidth',3,'Color',[0 0.45 0.74]);
ylabel({'Intensity'});
xlabel({'Radius (nm)'});
title({'Varying Intensity with Pillar Radius'});

%mark on plot to see nearest 5nm value
hold on;
scatter(radius(index1),intensity1(index1),'filled');
legend('561nm','633nm','Chosen Values');

%% Create Output File
fileName = sprintf('10_SiNx_Pillars_561nm.txt');
fileID = fopen(fileName,'W');
for i=1:10
    fprintf(fileID,'%d    %d\n',radius(index1(i))*2, phase1(index1(i)));
end
fclose(fileID);