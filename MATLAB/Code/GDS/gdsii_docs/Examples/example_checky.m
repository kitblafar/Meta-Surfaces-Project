%
% Creates a nested checky pattern.
%
% A nested checky pattern is a demanding test of a 
% lithography tool because of the sharp corners of
% the checky boxes and the large range of feature 
% sizes in the pattern. 
%
clear all

% create checky pattern
C = gdsii_checky([],[],[],[],[],[],[],[],4);

% write it to a file
write_gds_library(gds_library('CHECKY.DB', C), '!checky.gds');
