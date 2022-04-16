% Text elements are typically used for annotation of layouts.
% Unfortunately, the way different tools interpret text elements is
% not fully consistent. Cadence will read text elements with a
% datatype property whereas KLayout will not. The GDSII toolbox treats
% the datatype property as an optional property for text elements.

% Ulf Griesmann, August 2019

clear all

% a text element with datatype property (works with Cadence)
%te = gds_element('text', 'text','Hello!', 'xy',[0,0], 'layer',1, 'dtype',10);

% same without datatype property (works with KLayout)
te = gds_element('text', 'text','Hello!', 'xy',[0,0], 'layer',1);

% also something else
B = [0,0; 1,0; 1,1; 0,1; 0,0];
be = gds_element('boundary', 'xy',B, 'layer',2, 'dtype',20);

% put it in a library and write to a file
tlib = gds_library('GREETING.DB', gds_structure('GREETING',te,be));
write_gds_library(tlib, '!text_element.gds');
