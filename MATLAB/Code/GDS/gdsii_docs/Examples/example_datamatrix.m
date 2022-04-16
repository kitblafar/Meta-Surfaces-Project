%
% A DataMatrix barcode example
%
% The generated DataMatrix can be displayed with 
% e.g. the KLayout software and decoded with a 
% smartphone barcode reader

clear all

% make the DataMatrix barcode
DM = gdsii_datamatrix(['[Layout : Magic Hologram]', ...
                       '[Date : November 25, 2011]', ...
                       '[Creator : Harry Potter]'], 1000, [], 5);

% add the structures to a library and write it to a file
write_gds_library( gds_library('DMATRIX.DB', DM), '!dmatrix.gds' );
