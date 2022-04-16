close all;
clear all;
clc;

tic
tStart = tic

%% TODO- change this to come from user inputs
                split = 0;
                
                Px=0.41*1000; %period in x in nm (distance between pillar centres)
                
                Py=Px; %((Px).*sqrt(3))./2; %period in y in um, for a honeycomb arrangement, change to just Px for square grid

                f=200*1000;    %focal length in um

                pix=100*1000;  %aperture or lens diameter size in um
                
                lambda = 0.561;    %this is the wavelength in um for the equation                
                lam = lambda.*1000;
                
                NA = pix./(2.*f);
                
                fprintf('The focal length is %dum \n',f)
                fprintf('The lens size/diameter is %dum \n',pix)
                fprintf('The wavelength is %dnm \n',lam)
                fprintf('The Numerical Aperture is is %.2f \n',NA)
                

  %%              
               % TODO - change this to come from functions 
                diam = importdata('DiamVortexLens_a10_d100um_f200um_561nm_0.25NA_l1.mat');
                rotat = importdata('RotVortexLens_a10_d100um_f200um_561nm_0.25NA_l1.mat');
                
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
    
 tEnd = toc(tStart);
 fprintf('%d minutes and %f seconds\n', floor(tEnd/60), rem(tEnd,60));
 
 %% plot an elipse function
 function ellipse = ellipse(diameter)
    b= diameter/2; %minor axis
    a= (diameter/2) + 50;%major axis
    th = linspace(0,2*pi, 21) ; 
    % Ellipse 
    xe = a*cos(th) ; 
    ye = b*sin(th) ; 
    ellipse = [xe; ye];
    figure;
    scatter(xe,ye); 
 end