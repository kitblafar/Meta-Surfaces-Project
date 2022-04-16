%
% demonstrates paths and their rendering by polygons
%
% This script creates two library files: path.gds and 
% boundary.gds. The two files can be viewed with KLayout
% in the same panel. They should overlap exactly (with the 
% exception of acute path corners, which are clipped by 
% KLayout).
%

clear all;

% make a path approximating an Archimedian spiral r = a * theta
dt = pi * 10 / 180;  % 10 degrees increment
a = 100;             % controls space between turns
T = [pi/4:dt:5*pi]';
R = a * T;
xy = [R.*cos(T), R.*sin(T)];
pe = gds_element('path', 'xy',xy, 'layer',1, 'width',150, 'ptype',1);

% make simple paths a bit off to the side
xy1 = [0,0; 100,100; 300,0; 300,200] + repmat([-1600,-800], 4, 1);
xy2 = [0,0; 0,200; 300,200]          + repmat([-1600,-800], 3, 1);
pe1 = gds_element('path', 'xy',xy1, 'layer',2, 'width',50, 'ptype',2);
pe2 = gds_element('path', 'xy',xy2, 'layer',3, 'width',40, 'ptype',2);

pstruc = gds_structure('PATHS', pe, pe1, pe2);
write_gds_library( gds_library('PATH_LIB', pstruc), '!path.gds');

% convert paths to boundary elements
bstruc = poly_convert(pstruc, 'path');
bstruc = rename(bstruc, 'BOUNDARIES');
write_gds_library( gds_library('BOUNDARY_LIB', bstruc), '!boundary.gds');
