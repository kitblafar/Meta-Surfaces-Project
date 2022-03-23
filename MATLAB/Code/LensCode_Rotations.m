close all;
clear all;
clc;

tic

%% The start of the phase map code
                Vortex = 0;
                Px=0.41;                %period in x in um (distance between pillar centres)
                
                Py=((Px).*sqrt(3))./2;  %period in y in um, for a honeycomb arrangement, change to just Px for square grid

                f=200;                  %focal length in um

                pix=100;                %aperture or lens diameter size in um
                
                lambda = 0.561;         %this is the wavelength in um for the equation                
                lam = lambda.*1000;
                amp=0.1;                %the required amplitude of the lens (determines rotation)
                amppercent = 10
                
                NA = pix./(2.*f);
                
                fprintf('The focal length is %dum \n',f)
                fprintf('The lens size/diameter is %dum \n',pix)
                fprintf('The wavelength is %dnm \n',lam)
                fprintf('The Numerical Aperture is is %.2f \n',NA)
 %%                              
                sizes =importdata('10_SiNx_Pillars_561nm.txt');     %this is where you input the data file from CST with your pillar and corresponding phase values
%                 sizes = sizes(:,1)
                rotations = readtable('Amp_Geo_10_SiNx_Pillars_561nm.csv');
                
                FileName = sprintf('VortexLens_a%d_d%dum_f%dum_%dnm_%.2fNA_l1', amppercent, pix,f,lam,NA);
                FileNameDiam = sprintf('DiamVortexLens_a%d_d%dum_f%dum_%dnm_%.2fNA_l1', amppercent, pix,f,lam,NA);        %the file name, can modify to be based on date, time etc
                FileNameRot = sprintf('RotVortexLens_a%d_d%dum_f%dum_%dnm_%.2fNA_l1', amppercent, pix,f,lam,NA); 
                [status, msg, msgID] = mkdir(FileName)
                
 %% Produces the number of pixels within the lens size, and checks if odd or even              
Rx = single((pix - (mod(pix,Px)))/Px);      %mod returns remainder after division, so Rx divides the aperture up into an integer number of pixels, Px

if mod(Rx,2) ~= 0           %if remainder of Rx,2 is not zero, i.e. odd number, subtract 1
    
    Rx = Rx - 1;            %fixes the issue where you have an even number of pixels, helpful for calculating only quarter of a lens to speed up
    
end

Ry = single((pix - (mod(pix,Py)))/Py);

if mod(Ry,2) ~= 0
        
    Ry = Ry - 1;                %same as above for Y direction   
    
end
%% generates 2D meshgrids for X,Y coordinates and corresponding phase based on vectors on Rx and Ry

x1 = linspace((-Rx./2).*Px,(Rx./2).*Px,Rx+1);       %makes a vector x1 with evenly spaced coordinates based on Rx
y1 = linspace((-Ry./2).*Py,(Ry./2).*Py,Ry+1);       %same but for Ry
sx = length(x1);                                    %checks size of x1
sy = length(y1);                                    %checks size of y1

Xcoord = (zeros(sx,sy));                            %makes a matrix that is sx*sy in size, which is 1 larger than Rx, as needs to contain "zeroth" pixel
Ycoord = (zeros(sx,sy));
phi  = (zeros(sx,sy));
Phi_Vortex = phi;

time1 = toc

%% Chooses values for x and y, to put into lens equation, and looks if honeycomb pattern, wraps phase as fraction of 1

for i = 1:sx   
    for j = 1:sy                                                          %make triangular lattice, for x row, based on if odd or even y value
        if mod(j,2) ~= 0                    % if j is even, do stuff
            x = x1(i);
            y = y1(j);
        else                                % if j is odd, do stuff
            x = x1(i) + Px./2;  
            y = y1(j);
        end        
        Xcoord(i,j) = x;    %these are for the output x and y coordinates in the text file
        Xcoord(i,j) = Xcoord(i,j);   %TRY AND CUT AWAY VALUES THAT GO OVER THE BORDER OF THE LENS SIZE (EVERY ODD COLUMN)
        Ycoord(i,j) = y;
    end       
end       
    phi = (-((2*pi./lambda).* ((sqrt( (f*f)+((Xcoord.^2)+(Ycoord.^2)) )-f)))); %write phase information to matrix based on triangular lattice location
    %phi is in multiples of 2pi, have to wrap phase
        
   %%   phase plate
   vort = atan2d(Xcoord,Ycoord);
   vort = vort+180;
%%    wrap phase

phib=phi;    
phi = phi./(2.*pi); %to make phase as a fraction of 2pi, same format as input file from CST. Can compare the two, as below

vortb = vort;
vort = vort./360;

i=0;
j=0;

for i=1:sx
    for j = 1:sy            
        while phib(i,j) < -360
            phib(i,j) = phib(i,j) + 360; %%this part is to wrap phase and create zones    
        end        
    end
end

i=0;
j=0;

for i=1:sx
    for j = 1:sy
            
        while phi(i,j) < -1
            phi(i,j) = phi(i,j) + 1; %%this part is to wrap phase and create zones
    
        end
        
    end
end
i=0;
j=0;
phi = phi + 1;

time2 = toc

%%  section to generate a circle to crop the lens area, convert from square matrix to circular matrix

diam = phi*0;       %make a zero matrix
vortdiam = vort*0;
combodiam = vort*0;
comborotat = vort*0;
circ = diam;        %make a copy of diam
% Create a logical image of an ellipse with specified
% semi-major and semi-minor axes, center, and image size.
% First create the image.

imageSizeX = sy;
imageSizeY = sx;
[columnsInImage rowsInImage] = meshgrid(1:imageSizeX, 1:imageSizeY);        %make a 2D grid
% Next create the ellipse in the image.
centerX = sy/2;
centerY = sx/2;
radiusX = sy/2;
radiusY = sx/2;
ellipsePixels = (rowsInImage - centerY).^2 ./ radiusY^2 ...    %%finds difference between coordinate and centre, then squares to make positive, then divides by radius squared to normalise
    + (columnsInImage - centerX).^2 ./ radiusX^2 <= 1;  % ellipsePixels is a 2D "logical" array.

% Now, display it.

% figure(1)
% image(ellipsePixels) ;
% colormap([0 0 0; 1 1 1]);
% title('Binary image of a ellipse', 'FontSize', 20);

circ = ellipsePixels;

%% map pillars and round to nearest value onto equation of a lens

mask = phi;         %make a copy of phase matrix phi
vortmask = vort;

if Vortex ~= 1
    vortmask = 0;
end

combomask = mask + vortmask;

figure(2)
imagesc(mask)
if Vortex ==1
    figure(3)
    imagesc(vortmask)
end
figure(4)
imagesc(combomask)

for i=1:sx
    for j = 1:sy            
        while combomask(i,j) > 1
            combomask(i,j) = combomask(i,j) - 1; %%this part is to wrap phase and create zones    
        end        
    end
end

if Vortex == 1

figure(5)
imagesc(combomask)

else 

end


%% Assign 
% vortmask = vort;                              %make a copy of phase matrix phi

for i=1:ceil(sx)                                %only generate quarter of a lens
    for j=1:ceil(sy)
    if circ(i,j) == 1                           %only for circlular data in the ellipse
      
    test = sizes(:,2)-combomask(i,j);           %compares pillar phase and equation phase from phi
    index_neg = find(test<0);
    test(index_neg) = test(index_neg)+1;  
    % NEED TO delete the negative values, choose smallest positive value
    test2 = find(test==min(test));   
    
    if length(index_neg) == length(sizes)
        clear test2
        test2 = 1;
    end
    
    %find the nearest rotation value for the chosen amplitude
    %round amp to the nearest possible value
    roundTargets = 0.1:(0.17/9):0.27;
    ampRounded = interp1(roundTargets,roundTargets,amp,'nearest','extrap');
    %find the index this corresponds to so the row used is known
    rowIndex = find(roundTargets==0.1);
    rotation4AmpTable = rotations(rowIndex+1,:);
    rotation4Amp = table2array(rotation4AmpTable);
    
    
    switch test2
        % asign diameter and rotations
        case 1
            combodiam(i,j) = sizes(1,1);
            comborotat(i,j) = rotation4Amp(1,1);
        case 2
            combodiam(i,j) = sizes(2,1);
            comborotat(i,j) = rotation4Amp(1,2);
        case 3
            combodiam(i,j) = sizes(3,1);
            comborotat(i,j) = rotation4Amp(1,3);
        case 4
              combodiam(i,j) = sizes(4,1);
              comborotat(i,j) = rotation4Amp(1,4);
        case 5
              combodiam(i,j) = sizes(5,1);
              comborotat(i,j) = rotation4Amp(1,5);
        case 6   %%All of these cases correspond to the number of chosen pillars, e.g. 8, 10, 16
              combodiam(i,j) = sizes(6,1);
              comborotat(i,j) = rotation4Amp(1,6);
        case 7
              combodiam(i,j) = sizes(7,1);
              comborotat(i,j) = rotation4Amp(1,7);
        case 8
              combodiam(i,j) = sizes(8,1); 
              comborotat(i,j) = rotation4Amp(1,8);
        case 9
              combodiam(i,j) = sizes(9,1);
              comborotat(i,j) = rotation4Amp(1,9);
        case 10
              combodiam(i,j) = sizes(10,1); 
              comborotat(i,j) = rotation4Amp(1,10);
    end     
    clear test
    clear test2
    
    end
    
    end
end 
time4 = toc;

% %% This part replicates the quarter lens into the other 3 quadrants, so don't need to calculate, symmetric
% diam(1:(ceil(sx/2)) , ((ceil(sy/2))+1):sy) = diam(1:(ceil(sx/2)) , 1:((floor(sy/2))));
% diam(1:(ceil(sx/2)) , ((ceil(sy/2))+1):sy) = fliplr(diam(1:(ceil(sx/2)) , ((ceil(sy/2))+1):sy));    
% diam(((ceil(sx/2))+1):sx , 1:sy) = diam(1:(floor(sx/2)) , 1:sy);
% diam(((ceil(sx/2))+1):sx , 1:sy) = flipud(diam(((ceil(sx/2))+1):sx , 1:sy));
%%

%% Make a file name to write data to with three headers
save_name = sprintf('%s/%s.mat',FileName, FileNameDiam);
save (save_name, 'combodiam');
save_name = sprintf('%s/%s.mat',FileName, FileNameRot);
save (save_name, 'comborotat');
time5 = toc
%% Plot the lens in terms of pillar diameter
fig = figure;
imagesc(combodiam)   
save_fig = sprintf('%s/%s.fig',FileName, FileNameDiam);
savefig(fig,save_fig);
fig2 = figure;
imagesc(comborotat)
save_fig = sprintf('%s/%s.fig',FileName, FileNameRot);
savefig(fig2,save_fig);
