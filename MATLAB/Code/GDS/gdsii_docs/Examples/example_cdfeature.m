%
% generates a CD feature for 
% lithography process control
%
% shows that feature dimensions are independent of 
% user units.
%

clear all

cdfeature = gdsii_cdfeature(6,0,1e-3);
write_gds_library( gds_library('!cdfeature.gds', 'uunit',1e-3, cdfeature) );
