%
% A clear box for exposure experiments and to measure
% photoresist dissolution rates. The layout information
% is on layer 0, a number is written in the lower right
% corner of the layout. By processing layer 0 together
% with another layer an exposure containing a run number
% can be made, which helps with record keeping. 
%
% Ulf Griesmann, November 2014

clear all

% structure with box
poly = [ 1500, 0; ...
         1500, 1500; ...
        -1500, 1500; ...
        -1500,-1500; ...
         0,   -1500; ...
         0,    0; ...
         1500, 0];
boxe = gds_element('boundary', 'xy',poly, 'layer',0);
boxs = gds_structure('BOX', boxe);

% annotation in lower right corner
labels = gds_structure('LABELS');
for k = 1:30
  
    % number string
    nums = sprintf('%d', k);
    
    % make element, add to label structure
    [be,wid] = gdsii_boundarytext(nums, [0,0], 700, k); % need width
    labels(end+1) = gdsii_boundarytext(nums, [(1500-wid)/2,-1300], 700, k);
    
end

% CD feature
cdf = gdsii_cdfeature(0, 0.6, 1e-6);

% top structure
T = gds_structure('TOP');
T = add_ref(T, {boxs, labels});
T = add_ref(T, topstruct(cdf), 'xy',[550,-450]);

% library
L = gds_library('BOX.DB', 'uunit',1e-6, 'dbunit',1e-9, ...
                T, boxs, labels, cdf);
write_gds_library(L, '!clear_box.gds');
