%
% makes a basic gds file
%

clear all

% create a structure to hold elements
gs = gds_structure('BASIC');

% create two polygons
xy1 = 1000 * [0,0; 0,1; 1,1; 1,0; 0,0]; % 1mm x 1mm
xy2 = bsxfun(@plus, xy1, [1000, 1000]);

% create boundary elements and add to the structure (on different layers)
gs(end+1) = gds_element('boundary', 'xy',xy1, 'layer',1);
gs(end+1) = gds_element('boundary', 'xy',xy2, 'layer',2);

% create a library to hold the structure
glib = gds_library('TWO_BLOCKS', 'uunit',1e-6, 'dbunit',1e-9, gs);

% finally write the library to a file
write_gds_library(glib, '!basic.gds');
