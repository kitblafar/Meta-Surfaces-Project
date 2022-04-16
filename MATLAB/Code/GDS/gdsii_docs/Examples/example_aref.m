%
% example of an array reference

clear all

dgrid = 1200;     % grid spacing
layer = 5;

% structure with a box
xy = [0,0; 700,0; 700,700; 0,700; 0,0];
be = gds_element('boundary', 'xy',xy, 'layer',layer);
bs = gds_structure('BOX', be);

% create a top structure
tops = gds_structure('BOX_TOP');

% make array of boxes
adim.row = 5;
adim.col = 5;
xy = [-2*dgrid,-2*dgrid; 3*dgrid,-2*dgrid; -2*dgrid,3*dgrid];
xy = poly_rotzd(xy, -30);   % rotate the whole array
st.angle = 20;              % rotate the individual instances
tops = add_ref(tops, 'BOX', 'xy',xy, 'adim',adim, 'strans',st);

% create a library
L = gds_library('BOXES.DB', 'uunit',1e-6, 'dbunit',1e-9, tops, bs);

% writ the library
write_gds_library(L, '!many_boxes.gds');
