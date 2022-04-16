%
% Creates a Sierpinski fractal pattern.
%
clear all

% create pattern
S = gdsii_sierpinski();

% write it to a file
write_gds_library(gds_library('SIERPINSKI.DB', S), '!sierpinski.gds');
