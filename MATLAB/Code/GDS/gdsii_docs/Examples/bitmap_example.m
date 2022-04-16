function bitmap_example;

% beautiful homeland picture with 1 um size pixels

clear all

% read the bitmap and set pixels either 0 or 1
pm = imread('beautiful_homeland.png');
bm=zeros(size(pm));
bm(find(pm>126)) = 0;
bm(find(pm<=126)) = 1;
bm = rot90(bm, 3);

% define pixel, 1 micrometer square and write to GDS library
pixel.width  = 1;
pixel.height = 1;
bs = gdsii_bitmap(bm, pixel, 'BEAUTIFUL_BITMAP', 6);

% create library
L = gds_library('BEAUTIFUL.DB', 'uunit',1e-6, 'dbunit',1e-9, bs);
write_gds_library(L, '!beautiful_homeland.gds');
