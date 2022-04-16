%
% another example to illustrate Boolean operations
%

clear all;

% big circle on layer 2
arc.r = 0; arc.w = 1000; arc.c = [0,0]; arc.a1 = 0; arc.a2 = 2*pi; 
arc.e = 5;
bc = gdsii_arc(arc, 2);  % filled circle on layer 2 

% smaller circles on layer 4
arc.r = 0; arc.w = 300; arc.c = [1000,0]; arc.a1 = 0; arc.a2 = 2*pi;
sc1 = gdsii_arc(arc, 4);
arc.c = [0,1000];
sc2 = gdsii_arc(arc, 4);
arc.c = [-1000,0];
sc3 = gdsii_arc(arc, 4);
arc.c = [0,-1000];
sc4 = gdsii_arc(arc, 4);

% combine the small circles
sc = sc1 + sc2 + sc3 + sc4;

% substract small circles from large one and put result on layer 6
gdsii_units(1e-6, 1e-9);
cbc = poly_bool(bc, sc, 'notb', 'layer',6);

% let there be a layout file
S = gds_structure('BOOLEAN_DEMO', bc, sc, cbc);
L = gds_library('BOOLDEMO.DB', S);
write_gds_library(L, '!boolean_demo.gds');
