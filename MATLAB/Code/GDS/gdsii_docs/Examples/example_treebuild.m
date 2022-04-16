%
% illustrates how to build a tree of structures
%

clear all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create a structure containing two polygons
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% create two polygons (squares)
xy1 = 1000 * [0,0; 0,1; 1,1; 1,0; 0,0]; % 1mm x 1mm
xy2 = bsxfun(@plus, xy1, [1000, 1000]);

% create two boundary elements
be1 = gds_element('boundary', 'xy',xy1, 'layer',1);
be2 = gds_element('boundary', 'xy',xy2, 'layer',2);

% create a structure and add the elements to it 
% during instantiation
boxes = gds_structure('boxes', {be1,be2});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% add another element to the structure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% create a polygon text
be3 = gdsii_boundarytext('Hello Nano-world',[0,-1000],500,3);

% add the element using the 'add' method for structures
boxes = add_element(boxes, be3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create a second set of structures
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

grating = gdsii_grating('grating',[4000,4000],100,0.5,1000,1000);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% make a top level structure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

top = gds_structure('top');

% add structure references
top = add_ref(top, boxes, 'xy',[0,0]);
top = add_ref(top, grating{3}, 'xy',[0,0]); % this is a bit ugly ...

% add all to library
glib = gds_library('tree_example', boxes, top, grating);

treeview(glib);

% save to a file
write_gds_library(glib, '!treebuild.gds')
