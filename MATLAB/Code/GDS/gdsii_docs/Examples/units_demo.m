%
% All coordinates in a GDSII file are stored as multiples of the
% database unit (dbunit) in 4-byte signed integer numbers. At the
% level of Octave/Matlab, coordinates are specified in multiples of
% a user unit (uunit). Both units are a fraction of a meter and are 
% defined when a library is created (or with the gds_units'
% function).
%
% The units must be chosen with some care to avoid rounding
% errors. The number of digits after the decimal point in user
% units is equal to
%
% log10(uunit/dbunit)
%
% Ulf GRIESMANN, May 26, 2019

% create a boundary element with a rectangle
xy = [0,0; 1.5,0; 1.5,1.5; 0,1.5; 0,0];
E = gds_element('boundary', 'xy',xy, 'layer',20, 'dtype',727);

% display the polygon of the element
E.xy

% and a structure
S = gds_structure('UNITS_TEST', E);

% and a library with uunit = dbunit = 1e-9
L = gds_library('UNITS_TEST.DB', 'uunit',1e-9, 'dbunit',1e-9, S);
write_gds_library(L, '!units_test.gds');

% clear all data
clear all

% read library back from file
L = read_gds_library('units_test.gds');

% copy out the element
%E = L(1)(1); % works with Octave
S = L(1); E = S(1);

% display polygon again
E.xy
