classdef DiamMapAppCode < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                     matlab.ui.Figure
        GridLayout                   matlab.ui.container.GridLayout
        LeftPanel                    matlab.ui.container.Panel
        DistanceBetweenPillarCentresumEditFieldLabel  matlab.ui.control.Label
        DistanceBetweenPillarCentresumEditField  matlab.ui.control.NumericEditField
        FocalLengthumEditFieldLabel  matlab.ui.control.Label
        FocalLengthumEditField       matlab.ui.control.NumericEditField
        WavelengthumEditFieldLabel   matlab.ui.control.Label
        WavelengthumEditField        matlab.ui.control.NumericEditField
        LensDiameterApertureumEditField_2Label  matlab.ui.control.Label
        LensDiameterApertureumEditField_2  matlab.ui.control.NumericEditField
        DIAMETERMAPGENERATORLabel    matlab.ui.control.Label
        Image                        matlab.ui.control.Image
        USERINPUTSLabel_2            matlab.ui.control.Label
        EnterButton                  matlab.ui.control.Button
        RightPanel                   matlab.ui.container.Panel
        UIAxes                       matlab.ui.control.UIAxes
    end

    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
        onePanelWidth = 576;
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Changes arrangement of the app based on UIFigure width
        function updateAppLayout(app, event)
            currentFigureWidth = app.UIFigure.Position(3);
            if(currentFigureWidth <= app.onePanelWidth)
                % Change to a 2x1 grid
                app.GridLayout.RowHeight = {480, 480};
                app.GridLayout.ColumnWidth = {'1x'};
                app.RightPanel.Layout.Row = 2;
                app.RightPanel.Layout.Column = 1;
            else
                % Change to a 1x2 grid
                app.GridLayout.RowHeight = {'1x'};
                app.GridLayout.ColumnWidth = {220, '1x'};
                app.RightPanel.Layout.Row = 1;
                app.RightPanel.Layout.Column = 2;
            end
        end
        
        % Updates the Phase Map When the Enter Button Clicked
        function EnterButtonPushed(app)
            
            f =  app.FocalLengthumEditField.Value;
            if f == 0 
                f=200;    %focal length in um
            end
            
            Px =  app.DistanceBetweenPillarCentresumEditField.Value;
            if Px == 0
                Px=0.41; %period in x in um (distance between pillar centres)
            end
            
            pix =  app.LensDiameterApertureumEditField_2.Value;
            if pix == 0
                pix=100;  %aperture or lens diameter size in um
            end
            
            lambda =  app.WavelengthumEditField.Value;
            if lambda == 0
                lambda = 0.561;    %this is the wavelength in um for the equation   
            end  
            
            diameterMap = createDiameterMap(Px, f, pix, lambda);
            
            imagesc(diameterMap, 'Parent', app.UIAxes);
            
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {220, '1x'};
            app.GridLayout.RowHeight = {'1x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.Scrollable = 'on';

            % Create LeftPanel
            app.LeftPanel = uipanel(app.GridLayout);
            app.LeftPanel.Layout.Row = 1;
            app.LeftPanel.Layout.Column = 1;

            % Create DistanceBetweenPillarCentresumEditFieldLabel
            app.DistanceBetweenPillarCentresumEditFieldLabel = uilabel(app.LeftPanel);
            app.DistanceBetweenPillarCentresumEditFieldLabel.WordWrap = 'on';
            app.DistanceBetweenPillarCentresumEditFieldLabel.Position = [13 306 118 57];
            app.DistanceBetweenPillarCentresumEditFieldLabel.Text = 'Distance Between Pillar Centres (um)';

            % Create DistanceBetweenPillarCentresumEditField
            app.DistanceBetweenPillarCentresumEditField = uieditfield(app.LeftPanel, 'numeric');
            app.DistanceBetweenPillarCentresumEditField.Position = [130 323 76 22];

            % Create FocalLengthumEditFieldLabel
            app.FocalLengthumEditFieldLabel = uilabel(app.LeftPanel);
            app.FocalLengthumEditFieldLabel.HorizontalAlignment = 'center';
            app.FocalLengthumEditFieldLabel.WordWrap = 'on';
            app.FocalLengthumEditFieldLabel.Position = [13 240 118 42];
            app.FocalLengthumEditFieldLabel.Text = 'Focal Length (um)';

            % Create FocalLengthumEditField
            app.FocalLengthumEditField = uieditfield(app.LeftPanel, 'numeric');
            app.FocalLengthumEditField.Position = [130 250 76 22];

            % Create WavelengthumEditFieldLabel
            app.WavelengthumEditFieldLabel = uilabel(app.LeftPanel);
            app.WavelengthumEditFieldLabel.HorizontalAlignment = 'center';
            app.WavelengthumEditFieldLabel.WordWrap = 'on';
            app.WavelengthumEditFieldLabel.Position = [13 68 110 56];
            app.WavelengthumEditFieldLabel.Text = 'Wavelength (um)';

            % Create WavelengthumEditField
            app.WavelengthumEditField = uieditfield(app.LeftPanel, 'numeric');
            app.WavelengthumEditField.Position = [122 85 84 22];

            % Create LensDiameterApertureumEditField_2Label
            app.LensDiameterApertureumEditField_2Label = uilabel(app.LeftPanel);
            app.LensDiameterApertureumEditField_2Label.HorizontalAlignment = 'center';
            app.LensDiameterApertureumEditField_2Label.WordWrap = 'on';
            app.LensDiameterApertureumEditField_2Label.Position = [13 158 118 56];
            app.LensDiameterApertureumEditField_2Label.Text = 'Lens Diameter (Aperture) (um)';

            % Create LensDiameterApertureumEditField_2
            app.LensDiameterApertureumEditField_2 = uieditfield(app.LeftPanel, 'numeric');
            app.LensDiameterApertureumEditField_2.Position = [130 175 76 22];

            % Create DIAMETERMAPGENERATORLabel
            app.DIAMETERMAPGENERATORLabel = uilabel(app.LeftPanel);
            app.DIAMETERMAPGENERATORLabel.HorizontalAlignment = 'center';
            app.DIAMETERMAPGENERATORLabel.WordWrap = 'on';
            app.DIAMETERMAPGENERATORLabel.FontSize = 16;
            app.DIAMETERMAPGENERATORLabel.FontWeight = 'bold';
            app.DIAMETERMAPGENERATORLabel.Position = [72 415 134 53];
            app.DIAMETERMAPGENERATORLabel.Text = 'DIAMETER MAP GENERATOR';

            % Create Image
            app.Image = uiimage(app.LeftPanel);
            app.Image.Position = [13 415 58 53];
            app.Image.ImageSource = 'Icon.png';

            % Create USERINPUTSLabel_2
            app.USERINPUTSLabel_2 = uilabel(app.LeftPanel);
            app.USERINPUTSLabel_2.HorizontalAlignment = 'center';
            app.USERINPUTSLabel_2.FontSize = 16;
            app.USERINPUTSLabel_2.FontWeight = 'bold';
            app.USERINPUTSLabel_2.Position = [21 362 177 22];
            app.USERINPUTSLabel_2.Text = 'USER INPUTS';

            % Create EnterButton
            app.EnterButton = uibutton(app.LeftPanel, 'push', 'ButtonPushedFcn', @(btn,event)EnterButtonPushed(app));
            app.EnterButton.Position = [60 35 100 22];
            app.EnterButton.Text = 'Enter';

            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 2;
            
            % Create UIAxes
            app.UIAxes = uiaxes(app.RightPanel);
            title(app.UIAxes, 'Diameter Map')
            app.UIAxes.Position = [1 6 413 473];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = DiamMapAppCode

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end

%% Phase Map Code
function diameterMap = createDiameterMap(Px, f, pix, lambda)
%% The start of the phase map code
    Vortex = 0;
    Py=((Px).*sqrt(3))./2; %period in y in um, for a honeycomb arrangement, change to just Px for square grid
    NA = pix./(2.*f);
    lam = lambda.*1000;

    fprintf('The focal length is %dum \n',f)
    fprintf('The lens size/diameter is %dum \n',pix)
    fprintf('The wavelength is %dnm \n',lam)
    fprintf('The Numerical Aperture is is %.2f \n',NA)
 %%                              
                sizes =importdata('10_SiNx_Pillars_561nm.txt');     %this is where you input the data file from CST with your pillar and corresponding phase values
%                 sizes = sizes(:,1)

                FileName = sprintf('VortexLens_d%dum_f%dum_%dnm_%.2fNA_l1', pix,f,lam,NA);        %the file name, can modify to be based on date, time etc
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

for i=1:sx
    for j = 1:sy            
        while phib(i,j) < -360
            phib(i,j) = phib(i,j) + 360; %%this part is to wrap phase and create zones    
        end        
    end
end

for i=1:sx
    for j = 1:sy
            
        while phi(i,j) < -1
            phi(i,j) = phi(i,j) + 1; %%this part is to wrap phase and create zones
    
        end
        
    end
end
phi = phi + 1;

%%  section to generate a circle to crop the lens area, convert from square matrix to circular matrix

diam = phi*0;       %make a zero matrix
vortdiam = vort*0;
combodiam = vort*0;
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

% figure(2)
% imagesc(mask)
if Vortex ==1
%     figure(3)
%     imagesc(vortmask)
end
% figure(4)
% imagesc(combomask)

for i=1:sx
    for j = 1:sy            
        while combomask(i,j) > 1
            combomask(i,j) = combomask(i,j) - 1; %%this part is to wrap phase and create zones    
        end        
    end
end

if Vortex == 1

% figure(5)
% imagesc(combomask)

else 

end


%%
% vortmask = vort;         %make a copy of phase matrix phi

for i=1:ceil(sx)        %only generate quarter of a lens
    for j=1:ceil(sy)
    if circ(i,j) == 1           %%only for circlular data in the ellipse
      
    test = sizes(:,2)-combomask(i,j);        %compares pillar phase and equation phase from phi
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
            combodiam(i,j) = sizes(1,1);
        case 2
            combodiam(i,j) = sizes(2,1);             
        case 3
            combodiam(i,j) = sizes(3,1);
        case 4
              combodiam(i,j) = sizes(4,1);
        case 5
              combodiam(i,j) = sizes(5,1);
        case 6                              %%All of these cases correspond to the number of chosen pillars, e.g. 8, 10, 16
              combodiam(i,j) = sizes(6,1);
        case 7
              combodiam(i,j) = sizes(7,1);
        case 8
              combodiam(i,j) = sizes(8,1); 
        case 9
              combodiam(i,j) = sizes(9,1); 
        case 10
              combodiam(i,j) = sizes(10,1); 
    end     
    clear test
    clear test2
    
    end
    
    end
end 
% %% This part replicates the quarter lens into the other 3 quadrants, so don't need to calculate, symmetric
% diam(1:(ceil(sx/2)) , ((ceil(sy/2))+1):sy) = diam(1:(ceil(sx/2)) , 1:((floor(sy/2))));
% diam(1:(ceil(sx/2)) , ((ceil(sy/2))+1):sy) = fliplr(diam(1:(ceil(sx/2)) , ((ceil(sy/2))+1):sy));    
% diam(((ceil(sx/2))+1):sx , 1:sy) = diam(1:(floor(sx/2)) , 1:sy);
% diam(((ceil(sx/2))+1):sx , 1:sy) = flipud(diam(((ceil(sx/2))+1):sx , 1:sy));
%%

%% Make a file name to write data to with three headers
save_name = sprintf('%s/%s.mat',FileName, FileName)
save (save_name, 'combodiam')
%% Plot the lens in terms of pillar diameter
if Vortex == 0
    diameterMap = combodiam;       
%     save_fig = sprintf('%s/%s.fig',FileName, FileName)
%     savefig(imagesc(combodiam),save_fig)
end
end