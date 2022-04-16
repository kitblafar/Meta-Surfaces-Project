%
% Generates a layout idential to the
% layout test file that can be found at
% http://boolean.klaasholwerda.nl
%

clear all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% a structure AAP with a boundary element on layer 1
xy = [-920000.000, 452000.000; ...
       656500.000, 765500.000; ...
       175000.000,-174000.000; ...
      -756000.000,-198000.000; ...
      -920000.000, 452000.000];
AAP = gds_structure('AAP', gds_element('boundary', 'xy',xy, 'layer',1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% a top level structure LAYOUT with several elements
xy = [-2032000.000, 1410000.000; ...
       1427000.000, 1666000.000; ...
       502000.000, -1580500.000; ...
       502000.000, -1523500.000; ...
      -2032000.000, 1410000.000];
bnd = gds_element('boundary', 'xy',xy, 'layer',0);

xy = [1526500.000,-1034500.000; ...
      2623500.000,-1034500.000; ...
      2623500.000, 1105500.000; ...
      1526500.000, 1105500.000; ...
      1526500.000,-1034500.000];
box = gds_element('box', 'xy',xy, 'btype',0, 'layer',2);

xy = [-1112500.000,-1267000.000]; 
sref = gds_element('sref', 'sname','AAP', 'xy',xy);

xy = [891912.000, 2322024.000; ...
      966537.000, 1854278.000; ...
     2599515.000, 2311647.000; ...
     2626485.000, 2005353.000];
path = gds_element('path', 'xy',xy, 'layer',3, 'width',100000);

% text labels
strans.mag = 1875;
bnd_txt = gds_element('text', 'text','Boundary', ...
                      'xy',[-2256500.000,1539500.000], ...
                      'ptype', 1, 'strans',strans, ...
                      'ttype',0, 'layer',1);
path_txt = gds_element('text', 'text','Path', ...
                      'xy',[-151500.000,1924500.000], ...
                      'ptype', 1, 'strans',strans, ...
                      'ttype',0, 'layer',1);
sref_txt = gds_element('text', 'text','Sref', ...
                      'xy',[-1740000.000,-511500.000], ...
                      'ptype', 1, 'strans',strans, ...
                      'ttype',0, 'layer',1);
box_txt = gds_element('text', 'text','Box', ...
                      'xy',[1579000.000,1301500.000], ...
                      'ptype', 1, 'strans',strans, ...
                      'ttype',0, 'layer',1);

% create LAYOUT structure
E = {bnd, box, sref, path, bnd_txt, path_txt, sref_txt, box_txt};
LAYOUT = gds_structure('LAYOUT', E);

% write the layout to a file
glib = gds_library('SIMPLE.DB', 'dbunit',1e-8, 'uunit',1e-6, LAYOUT, AAP);
write_gds_library(glib, '!simple.gds');
