%
% orientation of polygons in boundary elements
%

clear all;

% boundary elements
xy = [0,0;1,0;1,1;0,1;0,0];
be = gds_element('boundary', 'xy',{xy, xy(end:-1:1,:), xy},'layer',4);

% calculate orientation
cw = poly_iscw(be)

% change orientation
be = poly_cw(be);
cw = poly_iscw(be)


