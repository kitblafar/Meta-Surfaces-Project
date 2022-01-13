%close all;
clear;
clc;

tic

%% The start of the phase map code
                FileName = sprintf('Lens_Small.txt');        %the file name, can modify to be based on date, time etc
                
                Px=0.41; %period in x in um (distance between pillar centres)
                
                Py=((Px).*sqrt(3))./2; %period in y in um, for a honeycomb arrangement, change to just Px for square grid

                f=820/280;    %focal length in um

                pix=420/100;  %aperture or lens diameter size in um

                lambda = 0.561;    %this is the wavelength in um for the equation

                sizes =importdata('10_SiNx_Pillars_561nm.txt');     %this is where you input the data file from CST with your pillar and corresponding phase values
%                 sizes = sizes(:,1)

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

time1 = toc

%% Chooses values for x and y, to put into lens equation, and looks if honeycomb pattern, wraps phase as fraction of 1

for i = 1:sx
    
    for j = 1:sy
                                                            %make triangular lattice, for x row, based on if odd or even y value
        if mod(j,2) ~= 0                    % if j is even, do stuff

            x = x1(i);
            y = y1(j);
       
        else                                % if j is odd, do stuff
            x = x1(i) + Px./2;  
%             x = x - (Px./4);
            y = y1(j);
        end
        
        Xcoord(i,j) = x;    %these are for the output x and y coordinates in the text file
        Xcoord(i,j) = Xcoord(i,j);   %TRY AND CUT AWAY VALUES THAT GO OVER THE BORDER OF THE LENS SIZE (EVERY ODD COLUMN)
        Ycoord(i,j) = y;
        
        phi(i,j) = (2*pi./lambda).*( (sqrt( (f*f)+((x).^2)+(y.^2)) ) -f); %write phase information to matrix based on triangular lattice location
        %phi is in multiples of 2pi, have to wrap phase
       end
       
end
    
phi = phi./(2.*pi); %to make phase as a fraction of 2pi, same format as input file from CST. Can compare the two, as below

i=0
j=0

for i=1:sx
    for j = 1:sy
            
        while phi(i,j) > 1
            phi(i,j) = phi(i,j) - 1; %%this part is to wrap phase and create zones
    
        end
        
    end
end

time2 = toc

%%  section to generate a circle to crop the lens area, convert from square matrix to circular matrix

diam = phi*0;       %make a zero matrix

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

figure
image(ellipsePixels) ;
colormap([0 0 0; 1 1 1]);
title('Binary image of an ellipse', 'FontSize', 20);

circ = ellipsePixels;

%% map pillars and round to nearest value onto equation of a lens

mask = phi;         %make a copy of phase matrix phi

for i=1:ceil(sx/2);        %only generate quarter of a lens
    for j=1:ceil(sy/2);
    if circ(i,j) == 1           %%only for circlular data in the ellipse
        
    test = sizes(:,2)-mask(i,j);        %compares pillar phase and equation phase from phi
    index_neg = find(test<0);
    test(index_neg) = test(index_neg)+1;    
    % NEED TO delete the negative values, choose smallest positive value
    test2 = find(test==min(test));   
    
    if length(index_neg) == length(sizes)
        clear test2
        test2 = 1;
    end
    
    switch test2
        
        case 1
            diam(i,j) = sizes(1,1);
        case 2
            diam(i,j) = sizes(2,1);             
        case 3
            diam(i,j) = sizes(3,1);
        case 4
            diam(i,j) = sizes(4,1);
        case 5
            diam(i,j) = sizes(5,1);
        case 6                              %%All of these cases correspond to the number of chosen pillars, e.g. 8, 10, 16
            diam(i,j) = sizes(6,1);
        case 7
            diam(i,j) = sizes(7,1);
        case 8
            diam(i,j) = sizes(8,1); 
        case 9
            diam(i,j) = sizes(9,1); 
        case 10
            diam(i,j) = sizes(10,1); 
    end     
    clear test
    clear test2
    
    end
    
    end
end         
time3 = toc

% diam(1:313,362:721) = diam(1:313,1:360);
% diam(1:313,362:721) = fliplr(diam(1:313,362:721));        %only for 1 mm lenses
% diam(314:625,1:721) = diam(1:312,1:721);
% diam(314:625,1:721) = flipud(diam(314:625,1:721));

%% This part replicates the quarter lens into the other 3 quadrants, so don't need to calculate, symmetric
diam(1:(ceil(sx/2)) , ((ceil(sy/2))+1):sy) = diam(1:(ceil(sx/2)) , 1:((floor(sy/2))));
diam(1:(ceil(sx/2)) , ((ceil(sy/2))+1):sy) = fliplr(diam(1:(ceil(sx/2)) , ((ceil(sy/2))+1):sy));    
diam(((ceil(sx/2))+1):sx , 1:sy) = diam(1:(floor(sx/2)) , 1:sy);
diam(((ceil(sx/2))+1):sx , 1:sy) = flipud(diam(((ceil(sx/2))+1):sx , 1:sy));
%% Make a file name to write data to with three headers

fileID = fopen(FileName,'W');
fprintf(fileID,'%12s %12s %8s\r\n','X Coord', 'Y Coord', 'Diam');

time4 = toc
%%  Writes data to file named above
T = 0;
 for i = 0:sx-1         % Write the location and diameter of pillars
    
    for j = 0:sy-1
       
        a = Xcoord(i+1,j+1);
        b = (Ycoord(i+1,j+1));
        c = diam(i+1,j+1)./1000;    %divide by 1000 to get into um

        AA = [a; b; c];

        if c ~= 0       %%if the diameter value is non-zero, falls within a circle, then write

            fprintf(fileID,'%12.3f %12.3f %8.3f',AA);
            fprintf(fileID,'\r\n');   

            T = T+1;
        end
    
    end
        
end       

fclose(fileID);
%% Plot the lens in terms of pillar diameter
time5 = toc
T
figure 
imagesc(diam)       
