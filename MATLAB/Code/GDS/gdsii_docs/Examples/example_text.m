%
% a text string made from boundary elements
%

clear all

% string containing all ASCII characters in font
allchar = char([33:127]);

% draw the string with boundaries
be = gdsii_boundarytext(allchar, [0,0], 1000);

% draw it with paths
pe = gdsii_pathtext(allchar, [0,2000], 1000, [], 0.15*1000);

% put it in a library and write to a file
write_gds_library( gds_library('CHARS.DB', gds_structure('CHARS', {be,pe})), '!text.gds');
