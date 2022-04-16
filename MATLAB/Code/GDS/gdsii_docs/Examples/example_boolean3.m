%
% Illustrates boolean operations for
% boundary elements using polygon operators
%
% NOTE: this does not permit to change the properties
% of the lhs elements.
%

clear all;

% create two equilateral triangles
h = sqrt(2000^2-1000^2);
xy_up = [0,0; 2000,0; 1000,h; 0,0];
up = gds_element('boundary', 'xy',xy_up, 'layer',2);

xy_dn = xy_up; xy_dn(:,2) = -xy_dn(:,2); xy_dn = xy_dn + repmat([0,h/sqrt(2)],4,1);
dn = gds_element('boundary', 'xy',xy_dn, 'layer',4);

% input triangles
write_gds_library(gds_library('TRI.DB', gds_structure('TRIANGLES',up,dn)), '!triangles.gds');

%
% The units must be defined for boolean polygon operations.
% In this case they were defined in the preceeding call to
% gds_library.
%
%gdsii_units(1e-6, 1e-9);

% union of the boundary elements
U = up | dn;
write_gds_library(gds_library('UNION.DB', gds_structure('UNION',U)), '!union.gds');

% intersection
I = up & dn;
write_gds_library(gds_library('INTER.DB', gds_structure('INTERSECTION',I)), '!intersection.gds');

% difference
D = up - dn;
write_gds_library(gds_library('DIFF.DB', gds_structure('DIFFERENCE',D)), '!difference.gds');

% xor
X = up ^ dn; % same notation as in C
write_gds_library(gds_library('XOR.DB', gds_structure('XOR',X)), '!xor.gds');
