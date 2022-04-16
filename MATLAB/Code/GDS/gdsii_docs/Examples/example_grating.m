%
% Shows how to create a grating test pattern.
% Gratings are useful for testing the performance
% of a lithography tool.
%
clear all

grt = gdsii_grating('GRATING', [-5000,-5000], 1, [], 10000, 10000, [], 6);
write_gds_library( gds_library('GRATING.DB', grt), '!grating.gds');

