%
% makes a slightly less basic gds file
%

clear all

% create a structure containing a compound boundary element
xy1 = 1000 * [0,0; 0,1; 1,1; 1,0; 0,0]; % 1mm x 1mm
xy2 = bsxfun(@plus, xy1, [-1000, -1000]);
be = gds_element('boundary', 'xy',{xy1,xy2}, 'layer',4);
sa = gds_structure('A', be);

% create another structure containing a compound boundary element
xy3 = bsxfun(@plus, xy1, [-1200, 200]);
xy4 = bsxfun(@plus, xy1, [200, -1200]);
be = gds_element('boundary', 'xy',{xy3,xy4}, 'layer',6);
sb = gds_structure('B', be);

% create a top level structure
ts = gds_structure('TOP');
ts = add_ref(ts, {sa,sb});  % add sref elements to top level

% create a library to hold the structure
% NOTE: ALL structures must be added to the library !
glib = gds_library('FOUR_BLOCKS', 'uunit',1e-6, 'dbunit',1e-9, ...
                   sa,sb,ts);

% finally write the library to a file
write_gds_library(glib, '!basic2.gds');
