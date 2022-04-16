%
% demonstates compound boundary elements
%

clear all;

% create polygons
xy1 = 1000 * [0,0; 0,1; 1,1; 1,0; 0,0]; % 1mm x 1mm
xy2 = bsxfun(@plus, xy1, [1000, 1000]);
xy3 = bsxfun(@plus, xy1, [2000, 2000]);
xy4 = bsxfun(@plus, xy1, [2000, 0]);
xy5 = bsxfun(@plus, xy1, [0, 2000]);

% create boundary elements and add to the structure (on different layers)
be1 = gds_element('boundary', 'xy',xy1, 'layer',1);
be2 = gds_element('boundary', 'xy',xy2, 'layer',2);
be3 = gds_element('boundary', 'xy',xy3, 'layer',3);
be4 = gds_element('boundary', 'xy',xy4, 'layer',4);
be5 = gds_element('boundary', 'xy',xy5, 'layer',5);

% compound element on layer 1
be = be1 + be2 + be3 + be4 + be5;

% move it to layer 6
be.layer = 6;

% create a library to hold the structure
glib = gds_library('BLOCKS.DB', 'uunit',1e-6, 'dbunit',1e-9, gds_structure('BLOCKS',be));

% finally write the library to a file
write_gds_library(glib, '!blocks.gds');

% and write it as a compound file
write_gds_library(glib, '!blocks.cgds');
