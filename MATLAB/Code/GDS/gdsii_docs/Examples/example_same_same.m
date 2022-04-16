%
% Illustrates the use of compound sref elements to write a 
% large number of identical structures
%

clear all

% define a boundary element and put it in a structure
xy = [0,0; 100,0; 100,100; 0,100; 0,0];
B = gds_structure('BOX', gds_element('boundary', 'xy',xy, 'layer',4));

% define a top level structure
T = gds_structure('TOP');

% define many random positions and create sref elements in top structure
rpos = 10000*rand(10000,2);
T = add_ref(T, B, 'xy',rpos); % makes a compound reference

% put in a library and write to file
write_gds_library( gds_library('MANY_BOXES.DB', T, B), '!same_same.gds');
