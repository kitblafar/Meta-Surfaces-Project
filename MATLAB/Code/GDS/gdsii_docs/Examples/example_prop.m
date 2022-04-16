%
% test element property atribute/value pairs
%

clear all

box = [0,0; 1000,0; 1000,1000; 0,1000; 0,0];

% two properties
prop(1).attr = 10;
prop(1).name = 'a simple script';

prop(2).attr = 11;
prop(2).name = 'for a simple box';

% gds_element
box_el = gds_element('boundary', 'xy',box, 'prop',prop, 'layer',4);

% top level tructure
top = gds_structure('TOP', box_el);

% make and file the library
write_gds_library(gds_library('BOX.DB', top), '!box_with_attributes.gds');
