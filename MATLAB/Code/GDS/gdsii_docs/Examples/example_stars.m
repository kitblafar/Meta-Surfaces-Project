%
% Demonstrates the replication of 
% polygons

clear all

% element with five polygons that look like a star
xy1 = 100 * [0.5,0.5; 0.5,-0.5; 1.7,0; 0.5,0.5];
xy2 = 100 * [0.5,0.5; 0,1.7;-0.5,0.5; 0.5,0.5];
xy3 = 100 * [-0.5,0.5; -0.5,-0.5; -1.7,0; -0.5,0.5];
xy4 = 100 * [0.5,-0.5; 0,-1.7;-0.5,-0.5; 0.5,-0.5];
xy5 = 100 * [0.5,0; 0,0.5; -0.5,0; 0,-0.5; 0.5,0];
XY = {xy1, xy2, xy3, xy4, xy5}; % the star
star = gds_element('boundary', 'xy',XY, 'layer',4);

% put star in a structure
star_struc = gds_structure('STAR', star);

% a 5 x 5 grid
grid.nr = 5;
grid.nc = 5;
grid.dr = 500;
grid.dc = 500;

% create a structure containing the stars on a grid
stars = gds_structure('STARS');
stars = gdsii_replicate(stars, star_struc, [0,-sqrt(2)*1000], grid, 45);

% create a library and write it to a file
write_gds_library( gds_library('STARS.DB', stars, star_struc), '!stars.gds' );
