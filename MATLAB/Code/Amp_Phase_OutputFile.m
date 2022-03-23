%% Phase and Amplitude Results Aquisition 
% Get the ry=rx+50 graph and choose 10 phase values. Tweak theta to get 10
% amplitudes at each phase value

close all;
clear;

%% Chosing 10 equally distributed phase values and get the geometary
% Read the data
amplitudeData=importdata("30thetaIntensity.txt").data; %read intensity
amplitude=amplitudeData(:, 2);
rx=amplitudeData(:, 1);
phase = importdata("30thetaPhase.txt").data; %read phase
phase=phase(:, 2);

%Reflect in the x-axis
phase=phase.*(-1);
%shift all the values up to the 140rx sample
index=find(rx==135);
phase(1:index)=phase(1:index)-360;
%shift all up by 360
phase=phase+360;
%normalise to 360 degrees
phase=phase./360;
phase=phase+0.356310359555972;

phaseUpper = phase(find(rx==140));
phaseLower = phase(find(rx==50));
phaseRange = phaseUpper - phaseLower;

%initialise values and index array
indexPhase=zeros(10,1);
step=phaseRange/9;

%set the index and values
for i=1:10
    p=step*(i-1)+phaseLower; % (start at 50)
    [~,indexPhase(i)]=min(abs(phase-p));
end

% find the chosen geometries and alter the first one
rxFinal = rx(indexPhase);
phaseFinal = phase(indexPhase);

% save a new phase-geometery file
fileName = sprintf('Phase_Geo_10_SiNx_Pillars_561nm.txt');
fileID = fopen(fileName,'W');
for i=1:10
    fprintf(fileID,'%d    %d\n',rxFinal(i)*2, phaseFinal(i));
end
fclose(fileID);

%% Plot the Phase Values ry=rx+50
% Amplitude
figure;
tiledlayout(2,1);
nexttile;
plot(rx, amplitude,'LineWidth',3,'Color',[0 0.45 0.74]);
xlabel('rx (nm)');
ylabel('amplitude'); 
title('Amplitude: Fixed Rotation Angle with Varying Geometry');
subtitle('Rotation: 30 degrees, Geometry Ratio: ry = rx + 50');
%mark on plot to see nearest 5nm value
hold on;
scatter(rxFinal,amplitude(indexPhase),'filled');
legend('Amplitude Data','Chosen Values');

%save the amplitude values as these need to be tweaked by theta
amplitudeInitial = amplitude(indexPhase);

% Phase
nexttile;
plot(rx, phase,'LineWidth',3,'Color',[0.63 0.078 0.18]);
xlabel('rx (nm)');
ylabel('Phase (2pi normalised)'); 
title('Phase: Fixed Rotation Angle with Varying Geometry');

%mark on plot to see nearest 5nm value
hold on;
scatter(rx(indexPhase),phase(indexPhase),'filled');
legend('Phase Data','Chosen Values');

%% Fixed Geometry, Varying Rotation
amplitudeData=importdata("rx100ry150Intensity.txt").data; %read intensity
fixedAmplitude=amplitudeData(:, 2);
Theta=amplitudeData(:, 1);
fixedPhase = importdata("rx100ry150Phase.txt").data; %read phase
fixedPhase=fixedPhase(:, 2);
Comparison=0.5*sin(2*deg2rad(Theta));

%Reflect in the x-axis
fixedPhase=fixedPhase.*(-1);
%normalise to 360 degrees
fixedPhase=fixedPhase./360;
fixedPhase=fixedPhase+0.356310359555972;

% Amplitude
figure;
tiledlayout(2,1);
nexttile;
plot(Theta, fixedAmplitude,'LineWidth',3,'Color',[0 0.45 0.74]);
xlabel('Theta (degrees)');
ylabel('Amplitude'); 
title('Amplitude: Varying Rotation Angle with a Fixed Geometry');
subtitle('Radius x = 100nm, Radius y= 150nm');
hold on;
plot(Theta, Comparison,'LineWidth',3,'Color',[0.63 0.078 0.18]);
legend({'CST Result','$\frac{1}{2}.sin(2\theta)$ Comparison'},'Interpreter','latex');

% Phase
nexttile;
plot(Theta(2: end), fixedPhase(2:end),'LineWidth',3,'Color',[0 0.45 0.74]);
xlabel('Theta (degrees)');
ylabel('Phase (2pi normalised)'); 
title('Phase: Varying Rotation Angle with a Fixed Geometry');

% find best fixed angle to probe (should be halfway up amplitude)
[~,halfIndex] = min(abs(fixedAmplitude-0.469398611593840/2));
bestAngle = Theta(halfIndex);
%% Map found amplitude values onto changing theta curve

% find amp value at theta = 30 (for the rx = 100nm)
amp30= fixedAmplitude(find(Theta == 30)); 

% each graph is sclaed by fixedAmp/ amplitude intial
% plot each scaled graph to see the maximum amplitude range
figure;
plot(Theta, fixedAmplitude,'LineWidth',3,'Color',[0 0.45 0.74], 'DisplayName','rx=100nm (original)');
scaledData = zeros(length(fixedAmplitude),length(amplitudeInitial));

for i=1:length(amplitudeInitial)
    scale = amplitudeInitial(i)/amp30;
    scaledData(:,i)=fixedAmplitude.*scale;
    hold on;
    str='rx='+string(rx(indexPhase(i)));
    plot(Theta, scaledData(:,i), 'DisplayName',str);
end
legend();
xlabel('Theta (degrees)');
ylabel('Scaled Amplitude'); 
title('Amplitude (for each Rx value) Scaled to the Amplitude for Rx=100nm');

% CONCLUSION: maximum posssible amplitude is 0.42 (minimum set to 0.1 as
% there is no point in no transmission)

%% Find rotations for 10 amplitudes between 0.1 and 0.27 for each Rx
thetaData = zeros(length(amplitudeInitial), length(amplitudeInitial));

for i=1:length(amplitudeInitial) % for each of the ampltidue values
    % find 10 amplitude values
    %initialise values and index array
    indexIntermediate=zeros(10,1);
    step=(0.27-0.1)/9;
    
    %set the index and values
    for j=1:10
        p=step*(j-1)+0.1;
        [~,indexIntermediate(j)]=min(abs(scaledData(:,i)-p));
    end
    thetaData(i, :)= Theta(indexIntermediate); 
    %mark on plot to see nearest 5nm value
    hold on;
    scatter(Theta(indexIntermediate),scaledData(indexIntermediate,i),'filled', 'HandleVisibility','off');
end

%make so that each row is a set of amplitude
thetaData=thetaData.';

%associated amplitude values (aimed for)
amplitudeFinal = 0.1:step:0.27;
% save the theta data
ampGeoTable=array2table(thetaData, "VariableNames",[string(phaseFinal(1)),string(phaseFinal(2)),string(phaseFinal(3)), string(phaseFinal(4)), string(phaseFinal(5)),string(phaseFinal(6)),string(phaseFinal(7)),string(phaseFinal(8)),string(phaseFinal(9)),string(phaseFinal(10))], 'RowNames',[string(amplitudeFinal(1)),string(amplitudeFinal(2)),string(amplitudeFinal(3)), string(amplitudeFinal(4)), string(amplitudeFinal(5)),string(amplitudeFinal(6)),string(amplitudeFinal(7)),string(amplitudeFinal(8)),string(amplitudeFinal(9)),string(amplitudeFinal(10))]);

% save a new phase-geometery file
fileName = sprintf('Amp_Geo_10_SiNx_Pillars_561nm.csv');
writetable(ampGeoTable,fileName) ;

