close all;
clear all;
clc;

tic
tStart = tic
%% The start of the phase map code
                split = 0;
                
                Px=410; %period in x in um (distance between pillar centres)
                
                Py=((Px).*sqrt(3))./2; %period in y in um, for a honeycomb arrangement, change to just Px for square grid

                f=30000;    %focal length in um

                pix=2000;  %aperture or lens diameter size in um
                
                lambda = 0.561;    %this is the wavelength in um for the equation                
                lam = lambda.*1000;
                
                NA = pix./(2.*f);
                
                fprintf('The focal length is %dum \n',f)
                fprintf('The lens size/diameter is %dum \n',pix)
                fprintf('The wavelength is %dnm \n',lam)
                fprintf('The Numerical Aperture is is %.2f \n',NA)
                
%%
                % TODO - chnage this to come from functions 
                diam = importdata('DiamVortexLens_a100_d4um_f2929um_561nm_0.00NA_l1.mat');
                rotat = importdata('RotVortexLens_a100_d4um_f2929um_561nm_0.00NA_l1.mat');
                
                % TODO- name should be the filename + GDS map
                name='a100_d4um_f2929um_561nm_0.00NA_l1';
                FileName = sprintf(name);        %the file name, can modify to be based on date, time etc
                [status, msg, msgID] = mkdir(sprintf('%s_GDS_files',FileName))
                sizes =importdata('Phase_Geo_10_SiNx_Pillars_561nm.txt');
                rotations = importdata('Amp_Geo_10_SiNx_Pillars_561nm.csv');
                rotations = rotations(2:end, :);
                pill = sizes(:,1);


                                        %% Make the pillars and store in structure.
repx=length(pill); 
tops = gds_structure('nano_rod_array');                     % create top strcture to hold objects

for Ln=1:length(pill)
    xy = nsidedpoly(20,'Radius',pill(Ln)/2);  %using this doesnt work at the
    be = gds_element('boundary', 'xy',xy.Vertices, 'layer',Ln);
    basic_pil{Ln}=gds_structure(strcat('single_nano_pil',num2str(Ln)),be);
end

rod_loc = diam;
time1 = toc

T=datestr(now,'ddmmyy_HH-MM')

%% make some arrays with all the required centre locations in.
%including the x offsets for hex grid
offset_px = ones(size(rod_loc)).*(Px*0.5);  %makes matrix of px/2
offset_px(:,1:2:end)=0;                     %odd elements of offset_px
tmp = (1:size(rod_loc,1))*Px;
px = repmat(tmp.',1, size(rod_loc,2));  %.' is transpose
tmp = (1:size(rod_loc,2))*Py;
py = repmat(tmp, size(rod_loc,1),1);
px(:,2:2:end)=px(:,2:2:end)+0.5*Px;

%% loop over pillars, find their locations, and add by reference
    
if split == 0  
    
    for j=1:length(pill)    
    clear loc;
    
    [row,col,v]=find(rod_loc==pill(j));         %could increase speed with case/switch
    ind = sub2ind(size(px),row,col);
    loc(1,:)=px(ind);
    loc(2,:)=py(ind);
    tops = add_ref(tops,basic_pil{j}, 'xy',loc.');             % adds by reference, with correction location, angle and rod type   
        
    end
    
    L = gds_library('nano_rod_array.DB', 'uunit', 1e-9, 'dbunit', 1e-12, tops,basic_pil);
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
    
 tEnd = toc(tStart);
 fprintf('%d minutes and %f seconds\n', floor(tEnd/60), rem(tEnd,60));