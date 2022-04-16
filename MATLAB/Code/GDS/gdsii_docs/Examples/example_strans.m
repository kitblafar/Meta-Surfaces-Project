%
% Illustrates the use of strans records in GDS II libraries
%

% define a boundary element and put it in a structure
xy = [0,0; 100,0; 100,100; 0,100; 0,0];
B = gds_structure('SQUARE', gds_element('boundary', 'xy',xy, 'layer',4));

% define a top level structure
T = gds_structure('TOP');

% add to structure T reference(s) to structure B
xy = [-200,-150; -50,-150; 100,-150];
T = add_ref(T, B, 'xy',xy); % makes a compound reference

% now rotate and replicate
strans.angle = 60; % in GDS II, angles are specified in degrees
T = add_ref(T, B, 'xy',[-200,50], 'strans',strans);
strans.angle = 40;
T = add_ref(T, B, 'xy',[-50,50], 'strans',strans);
strans.angle = 20; strans.mag = 0.5;
T = add_ref(T, B, 'xy',[100,50], 'strans',strans);

% put in a library and write to file
L = gds_library('DEMOSTRANS.DB', T, B);
write_gds_library(L, '!demo_strans.gds');
