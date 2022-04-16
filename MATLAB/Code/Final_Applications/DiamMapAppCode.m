 classdef DiamMapAppCode < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                                        matlab.ui.Figure
        GridLayout                                      matlab.ui.container.GridLayout
        LeftPanel                                       matlab.ui.container.Panel
        DistanceBetweenPillarCentresumEditFieldLabel    matlab.ui.control.Label
        DistanceBetweenPillarCentresumEditField         matlab.ui.control.NumericEditField
        FocalLengthumEditFieldLabel                     matlab.ui.control.Label
        FocalLengthumEditField                          matlab.ui.control.NumericEditField
        WavelengthumEditFieldLabel                      matlab.ui.control.Label
        WavelengthumEditField                           matlab.ui.control.NumericEditField
        AmplitudeEditFieldLabel                         matlab.ui.control.Label
        AmplitudeEditField                              matlab.ui.control.NumericEditField
        LensDiameterApertureumEditField_2Label          matlab.ui.control.Label
        LensDiameterApertureumEditField_2               matlab.ui.control.NumericEditField
        DIAMETERMAPGENERATORLabel                       matlab.ui.control.Label
        Image                                           matlab.ui.control.Image
        USERINPUTSLabel_2                               matlab.ui.control.Label
        EnterButton                                     matlab.ui.control.Button
        RotationButton                                  matlab.ui.control.Button
        GDSButton                                       matlab.ui.control.Button
        RightPanel                                      matlab.ui.container.Panel
        UIAxes                                          matlab.ui.control.UIAxes
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
            set(app.GDSButton,'Backgroundcolor','red');
            amp =  app.AmplitudeEditField.Value;
            if amp == 0 
                amp=50;    %amplitude in percentage of full range
            end
            
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
                lambda = 561;    %this is the wavelength in nm for the equation   
            end  
            
            [diameterMap, rotationMap] = createDiameterMap(amp, Px, f, pix, lambda);
            assignin('base','userInputs',[Px, f, pix, lambda]);
            assignin('base','diameterMap',diameterMap);
            assignin('base','rotationMap',rotationMap);
            imagesc(diameterMap, 'Parent', app.UIAxes);
            
        end
          % Shows the Rotation Map
        function RotationButtonPushed(app)
            % update title
            title(app.UIAxes, 'Rotation Map (degrees)')
            % update image
            rotationMap = evalin('base', 'rotationMap');
            imagesc(rotationMap, 'Parent', app.UIAxes);
        end
        
        % Shows the Diameter Map
        function DiameterButtonPushed(app)
            % update title
            title(app.UIAxes, 'Diameter Map (nm)')
            % update image
            diameterMap = evalin('base', 'diameterMap');
            imagesc(diameterMap, 'Parent', app.UIAxes);
        end
        
        % Generate the GDS file
        function GDSButtonPushed(app)
            % TODO
            rotationMap = evalin('base', 'rotationMap');
            diameterMap = evalin('base', 'diameterMap');
            userInputs = evalin('base', 'userInputs');
            GDSMapComplete = generateGDSIIFile(userInputs(1), userInputs(2), userInputs(3), userInputs(4), diameterMap, rotationMap)
            set(app.GDSButton,'Backgroundcolor','green');
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
            
             % Create AmplitudeEditFieldLabel
            app.AmplitudeEditFieldLabel = uilabel(app.LeftPanel);
            app.AmplitudeEditFieldLabel.WordWrap = 'on';
            app.AmplitudeEditFieldLabel.HorizontalAlignment = 'center';
            app.AmplitudeEditFieldLabel.Position = [13 289 118 57];
            app.AmplitudeEditFieldLabel.Text = 'Amplitude (%)';

            % Create AmplitudeEditField
            app.AmplitudeEditField = uieditfield(app.LeftPanel, 'numeric');
            app.AmplitudeEditField.Position = [130 306 76 22];

            % Create DistanceBetweenPillarCentresumEditFieldLabel
            app.DistanceBetweenPillarCentresumEditFieldLabel = uilabel(app.LeftPanel);
            app.DistanceBetweenPillarCentresumEditFieldLabel.WordWrap = 'on';
            app.DistanceBetweenPillarCentresumEditFieldLabel.Position = [13 231 118 57];
            app.DistanceBetweenPillarCentresumEditFieldLabel.Text = 'Distance Between Pillar Centres (um)';

            % Create DistanceBetweenPillarCentresumEditField
            app.DistanceBetweenPillarCentresumEditField = uieditfield(app.LeftPanel, 'numeric');
            app.DistanceBetweenPillarCentresumEditField.Position = [130 248 76 22];

            % Create FocalLengthumEditFieldLabel
            app.FocalLengthumEditFieldLabel = uilabel(app.LeftPanel);
            app.FocalLengthumEditFieldLabel.HorizontalAlignment = 'center';
            app.FocalLengthumEditFieldLabel.WordWrap = 'on';
            app.FocalLengthumEditFieldLabel.Position = [13 190 118 42];
            app.FocalLengthumEditFieldLabel.Text = 'Focal Length (um)';

            % Create FocalLengthumEditField
            app.FocalLengthumEditField = uieditfield(app.LeftPanel, 'numeric');
            app.FocalLengthumEditField.Position = [130 200 76 22];

            % Create WavelengthumEditFieldLabel
            app.WavelengthumEditFieldLabel = uilabel(app.LeftPanel);
            app.WavelengthumEditFieldLabel.HorizontalAlignment = 'center';
            app.WavelengthumEditFieldLabel.WordWrap = 'on';
            app.WavelengthumEditFieldLabel.Position = [13 68 110 56];
            app.WavelengthumEditFieldLabel.Text = 'Wavelength (nm)';

            % Create WavelengthumEditField
            app.WavelengthumEditField = uieditfield(app.LeftPanel, 'numeric');
            app.WavelengthumEditField.Position = [122 85 84 22];

            % Create LensDiameterApertureumEditField_2Label
            app.LensDiameterApertureumEditField_2Label = uilabel(app.LeftPanel);
            app.LensDiameterApertureumEditField_2Label.HorizontalAlignment = 'center';
            app.LensDiameterApertureumEditField_2Label.WordWrap = 'on';
            app.LensDiameterApertureumEditField_2Label.Position = [13 133 118 56];
            app.LensDiameterApertureumEditField_2Label.Text = 'Lens Diameter (Aperture) (um)';

            % Create LensDiameterApertureumEditField_2
            app.LensDiameterApertureumEditField_2 = uieditfield(app.LeftPanel, 'numeric');
            app.LensDiameterApertureumEditField_2.Position = [130 150 76 22];

            % Create DIAMETERMAPGENERATORLabel
            app.DIAMETERMAPGENERATORLabel = uilabel(app.LeftPanel);
            app.DIAMETERMAPGENERATORLabel.HorizontalAlignment = 'center';
            app.DIAMETERMAPGENERATORLabel.WordWrap = 'on';
            app.DIAMETERMAPGENERATORLabel.FontSize = 16;
            app.DIAMETERMAPGENERATORLabel.FontWeight = 'bold';
            app.DIAMETERMAPGENERATORLabel.Position = [72 415 134 53];
            app.DIAMETERMAPGENERATORLabel.Text = 'METASURFACE GENERATOR';

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
            app.EnterButton.Position = [5 35 100 22];
            app.EnterButton.Text = 'Enter';
            
             % Create GDSMapGenerate
            app.GDSButton = uibutton(app.LeftPanel, 'push', 'ButtonPushedFcn', @(btn,event)GDSButtonPushed(app));
            app.GDSButton.Position = [120 35 100 22];
            app.GDSButton.Text = 'GDS Map';
            
            % Create Show Rotation Map Button
            app.RotationButton = uibutton(app.LeftPanel, 'push', 'ButtonPushedFcn', @(btn,event)RotationButtonPushed(app));
            app.RotationButton.Position = [120 5 100 22];
            app.RotationButton.Text = 'Rotation Map';
            
            % Create Show Diameter Map Button
            app.RotationButton = uibutton(app.LeftPanel, 'push', 'ButtonPushedFcn', @(btn,event)DiameterButtonPushed(app));
            app.RotationButton.Position = [5 5 100 22];
            app.RotationButton.Text = 'Diameter Map';

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
function [diameterMap, rotationMap] = createDiameterMap(amppercent, Px, f, pix, lam)
    %% The start of the phase map code
    
    Vortex = 0;
    Py=((Px).*sqrt(3))./2; %period in y in um, for a honeycomb arrangement, change to just Px for square grid
    NA = pix./(2.*f);
    lambda =lam/1000;
    amp = amppercent/100;
    amp = 0.17*amp+0.1; %map to the full known range

    fprintf('The amplitude percentage is %d percent \n',amppercent)
    fprintf('The focal length is %dum \n',f)
    fprintf('The lens size/diameter is %dum \n',pix)
    fprintf('The wavelength is %dnm \n',lam)
    fprintf('The Numerical Aperture is is %.2f \n',NA)
    
    %%
    sizes =importdata('Phase_Geo_10_SiNx_Pillars_561nm.txt');     %this is where you input the data file from CST with your pillar and corresponding phase values
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

%     figure(2)
%     imagesc(mask)
    if Vortex ==1
        figure(3)
        imagesc(vortmask)
    end
%     figure(4)
%     imagesc(combomask)

    for i=1:sx
        for j = 1:sy
            while combomask(i,j) > 1
                combomask(i,j) = combomask(i,j) - 1; %%this part is to wrap phase and create zones
            end
        end
    end

    if Vortex == 1

        %figure(5)
        %imagesc(combomask)

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
                rowIndex = find(roundTargets==ampRounded);
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
                    case 6                              %%All of these cases correspond to the number of chosen pillars, e.g. 8, 10, 16
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

    % %% This part replicates the quarter lens into the other 3 quadrants, so don't need to calculate, symmetric
    % diam(1:(ceil(sx/2)) , ((ceil(sy/2))+1):sy) = diam(1:(ceil(sx/2)) , 1:((floor(sy/2))));
    % diam(1:(ceil(sx/2)) , ((ceil(sy/2))+1):sy) = fliplr(diam(1:(ceil(sx/2)) , ((ceil(sy/2))+1):sy));
    % diam(((ceil(sx/2))+1):sx , 1:sy) = diam(1:(floor(sx/2)) , 1:sy);
    % diam(((ceil(sx/2))+1):sx , 1:sy) = flipud(diam(((ceil(sx/2))+1):sx , 1:sy));
    %% Make a file name to write data to with three headers
    save_name = sprintf('%s/%s.mat',FileName, FileNameDiam);
    save (save_name, 'combodiam');
    save_name = sprintf('%s/%s.mat',FileName, FileNameRot);
    save (save_name, 'comborotat');
    
    %% Plot the lens in terms of pillar diameter
    fig = figure('visible','off');
    imagesc(combodiam);
    save_fig = sprintf('%s/%s.fig',FileName, FileNameDiam);
    savefig(fig,save_fig);
    fig2 = figure('visible','off');
    imagesc(comborotat);
    save_fig = sprintf('%s/%s.fig',FileName, FileNameRot);
    savefig(fig2,save_fig);
    close all;
    rotationMap = comborotat;
    diameterMap = combodiam;
end

%% GDS Map Generation
function gdsDone = generateGDSIIFile(Px, f, pix, lam, diameterMap, rotationMap)
    %% TODO- change this to come from user inputs
                    split = 0;

                    Px=Px*1000; %period in x in nm (distance between pillar centres)

                    Py=Px; %((Px).*sqrt(3))./2; %period in y in um, for a honeycomb arrangement, change to just Px for square grid

                    f=f*1000;    %focal length in um

                    pix=pix*1000;  %aperture or lens diameter size in um

                    NA = pix./(2.*f);

                    fprintf('The focal length is %dum \n',f)
                    fprintf('The lens size/diameter is %dum \n',pix)
                    fprintf('The wavelength is %dnm \n',lam)
                    fprintf('The Numerical Aperture is is %.2f \n',NA)


      %%              
                   % TODO - change this to come from functions 
                    diam = diameterMap;
                    rotat = rotationMap;

                    % TODO- name should be the filename + GDS map
                    name='a10_d100um_f200um_561nm_0.25NA_l1';
                    FileName = sprintf(name);        %the file name, can modify to be based on date, time etc
                    sizes =importdata('Phase_Geo_10_SiNx_Pillars_561nm.txt');
                    rotations = importdata('Amp_Geo_10_SiNx_Pillars_561nm.csv');
                    rotations = rotations(2:end, :);
                    pill = sizes(:,1);

     %% Make the pillars and store in structure.
    repx=length(pill); 
    tops = gds_structure('nano_rod_array');                     % create top strcture to hold objects

    for Ln=1:length(pill)
        xy = ellipse(pill(Ln));
        be = gds_element('boundary', 'xy',xy.', 'layer',Ln)
        basic_pil{Ln}=gds_structure(strcat('single_nano_pil',num2str(Ln)),be);
    end

    time1 = toc

    T=datestr(now,'ddmmyy_HH-MM')

    %% make some arrays with all the required centre locations in.
    %including the x offsets for hex grid
    offset_px = ones(size(diam)).*(Px*0.5);  %makes matrix of px/2
    offset_px(:,1:2:end)=0;                     %odd elements of offset_px
    tmp = (1:size(diam,1))*Px;
    px = repmat(tmp.',1, size(diam,2));  %.' is transpose
    tmp = (1:size(diam,2))*Py;
    py = repmat(tmp, size(diam,1),1);
    px(:,2:2:end)=px(:,2:2:end)+0.5*Px;


    %% loop over pillars in diameter AND rotation maps, find their locations, and add by reference
    % i.e. find Dm (to match the row) then find Rt (to match the column)

    if split == 0  
        % add the rotation and diameter arrays together
        for j=1:length(pill)    
                index1=find(diam==pill(j)); %find any matching pillars of this length
            if ~isempty(index1)
                for i = 1:length(pill)
                    clear loc;
                    index2=find(rotat==rotations(j,i));

                    mem = find(ismember(index1, index2)==1);

                    if ~isempty(mem)
                        trueind = index1(mem);
                        loc(1,:)=px(trueind);
                        loc(2,:)=py(trueind);
                        sts.angle = rotations(j,i); % find the correct angle
                        tops = add_ref(tops, basic_pil{j}, 'xy',loc.', 'strans', sts);             % adds by reference, with correction location, angle and rod type  
                    end 

                end
            end
        end

        L = gds_library('nano_rod_array.DB', 'uunit', 1e-9, 'dbunit', 1e-12, tops, basic_pil);
        filename2 = sprintf('!%s.gds',FileName);
        write_gds_library(L, filename2);
    else 
        for j=1:length(pill)
        tops = gds_structure('nano_rod_array');
        clear loc;
        clear DBName;
        clear DBName2;

        [row,col,v]=find(rod_loc==pill(j));
        ind = sub2ind(size(px),row,col);
        loc(1,:)=px(ind);
        loc(2,:)=py(ind);
        tops = add_ref(tops,basic_pil{j}, 'xy',loc.');             % adds by reference, with correction location, angle and rod type
        DBName = sprintf('!nano_rod_array_%.2f.DB',j);
        L = gds_library(DBName, 'uunit',1e-9, 'dbunit',1e-12, tops,basic_pil{j});
        filename2 = sprintf('!%s_split_%.2f.gds',FileName, j);
        write_gds_library(L, filename2);
    %     write_gds_library(L, '!Pillar_arrays_split_%f.gds',j);
        clear tops;
        end

    end


       %%
    %     if circ(i,j) == 1           %%only for circlular data in the ellipse
    %       
    %     test = sizes(:,1)-diam(i,j);        %compares pillar phase and equation phase from phi
    %     index_neg = find(test<0);
    %     test(index_neg) = test(index_neg)+360;    
    %     % NEED TO delete the negative values, choose smallest positive value
    %     test2 = find(test==min(test));   
    %     
    %     if length(index_neg) == length(sizes)
    %         clear test2
    %         test2 = 1;
    %     end
    %     
    %     switch test2
    %         
    %         case 1
    %             Pillar_d = 1;
    %         case 2
    %             Pillar_d = 2;             
    %         case 3
    %             Pillar_d = 3;
    %         case 4
    %               Pillar_d = 4;
    %         case 5
    %               Pillar_d = 5;
    %         case 6                              %%All of these cases correspond to the number of chosen pillars, e.g. 8, 10, 16
    %               Pillar_d = 6;
    %         case 7
    %               Pillar_d = 7;
    %         case 8
    %               Pillar_d = 8; 
    %         case 9
    %               Pillar_d = 9; 
    %         case 10
    %               Pillar_d = 10; 
    %     end     
    %  
    %                     Pillar_d_all(i,j)=Pillar_d;         
    %                     xy = [0,0;0,Py;Px,0];  % assigns area of cell for pillar
    %                     
    %                                     if mod(j,2) ~= 0                    % if j is even, do stuff
    %                                     row = (row_offset*(i-1));
    %                                     col = (col_offset*(j-1));
    % %                                     xy = bsxfun(@plus,xy,[row_offset*(i-1),col_offset*(j-1)]);
    % 
    %                                     else                                % if j is odd, do stuff
    %                                     row = (row_offset*(i-1))+(Px/2);
    %                                     col = (col_offset*(j-1));
    %                                     end                                   
    %                                            
    %                     
    %                 xy = bsxfun(@plus,xy,[row,col]);
    %                 gs = add_ref(gs,basic_pil{Pillar_d}, 'xy',xy,'adim',adim1,'strans',st);
    %                 clear test
    %                 clear test2
    %     end
    %     end
    % 
    %             end
    %    
    %         time4 = toc;
    %         clear gs1
    %         clear gs

     gdsDone = 'TRUE';

     %% plot an elipse function
     function ellipse = ellipse(diameter)
        b= diameter/2; %minor axis
        a= (diameter/2) + 50;%major axis
        th = linspace(0,2*pi, 21) ; 
        % Ellipse 
        xe = a*cos(th) ; 
        ye = b*sin(th) ; 
        ellipse = [xe; ye];
%         figure;
%         scatter(xe,ye); 
     end
 end