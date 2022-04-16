%
% create structures containing arcs
%

clear all

% create a library
glib = gds_library('ARC.DB');

% and a top level structure
tls = gds_structure('ARC_BOX');

% arc shaped element
arc.r = 400;        % inside radius of arc
arc.c = [0,500];    % arc center
arc.a1 = 0;         % arc angles
arc.a2 = pi;
arc.w = 100;        % arc width
arc.e = 2;          % approximation error
tls(end+1) = gdsii_arc(arc, 3);

% box shaped element
xy = [500,500; -500,500; -500,-500; 500,-500; 500,500];
tls(end+1) = gds_element('boundary', 'xy',xy, 'layer',2);

% write library to file
glib(end+1) = tls;
write_gds_library(glib, '!arc.gds');
