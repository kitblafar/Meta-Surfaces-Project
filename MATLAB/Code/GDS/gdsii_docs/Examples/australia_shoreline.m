function australia_shoreline;
%
% convert Australian shoreline data from
% http://www.soest.hawaii.edu/pwessel/gshhs/ 
% into GDS format
%

clear all

% cell array of shoreline polygons
spb = {};  % boundaries for islands
spp = {};  % paths for shoreline segments

% open the data file
fd = fopen('australia_shoreline.dat', 'r');

% read polygons until file end
npb = 0;
npp = 0;
while 1
  
   % read all data for one polygon
   xy = [];
   while 1
     
     line = fgets(fd);
     if line(1) == '>'
        if length(xy) > 2  % must have at least 3 points
           if any(xy(1,:) ~= xy(end,:))  % not an island, use path
              npp = npp + 1;
              spp{npp} = xy;
              if ~mod(npp,100)
                  fprintf('%d paths\n', npp);
              end
           else
              npb = npb + 1;
              spb{npb} = xy;
              if ~mod(npb,100)
                  fprintf('%d boundaries\n', npb);
              end
           end
        end
        break
     end
     
     xy(end+1,:) = sscanf(line, '%f%f');
     
   end
   
   if feof(fd)
      break
   end
   
end

fclose(fd);

% create compound boundary element containing small islands
spbel = gds_element('boundary', 'xy',spb, 'layer',9);

% continent and large islands are described by a compound path element
sppel = gds_element('path', 'xy',spp, 'layer',6);   

% add to top level structure
tops = gds_structure('AUSTRALIA', sppel, spbel); % top level
                                                 % structure
% now add some locations (coordinates from Google Maps)
% first coordinate is the city center, the second coordinate
% marks the approximate edge of the city.
clayer = 25;  % layer for cities
sydney =     [151.020584,-33.815666; 151.291122,-33.832779];
tops = add_element(tops, city_label(sydney(1,:), sydney(2,:), ...
                                    'Sydney', clayer));

melbourne =  [144.994583,-37.819548; 145.196457,-37.856423];
tops = add_element(tops, city_label(melbourne(1,:), melbourne(2,:), ...
                                    'Melbourne', clayer) );

adelaide =   [138.59642,-34.9017;    138.489304,-34.896069];
tops = add_element(tops, city_label(adelaide(1,:), adelaide(2,:), ...
                                    'Adelaide', clayer) );

brisbane =   [153.02536,-27.461976;  153.13797,-27.542371];
tops = add_element(tops, city_label(brisbane(1,:), brisbane(2,:), ...
                                    'Brisbane', clayer) );

perth =      [115.858841,-31.946336; 115.957718,-32.039512];
tops = add_element(tops, city_label(perth(1,:), perth(2,:), ...
                                    'Perth', clayer) );

darwin =     [130.921211,-12.40573;  130.84156,-12.386952];
tops = add_element(tops, city_label(darwin(1,:), darwin(2,:), ...
                                    'Darwin', clayer) );

townsville = [146.780663,-19.283276; 146.810188,-19.244384];
tops = add_element(tops, city_label(townsville(1,:), townsville(2,:), ...
                                    'Townsville', clayer) );

uluru =      [131.035595,-25.343716; 131.050014,-25.372258];
tops = add_element(tops, city_label(uluru(1,:), uluru(2,:), ...
                                    'Uluru', clayer) );

% create the library and write it to a file
lib = gds_library('AU.DB', tops, 'uunit',1, 'dbunit',1e-7, 'layer',2);
write_gds_library(lib, '!australia_shoreline.gds');

return

function [ce] = city_label(loc, edge, name, layer);
%
% returns a cell array of elements marking city location and
% name

% city radius
R = norm(loc - edge);

% create arc
arc = [];
arc.r = 0;      % arc inside radius
arc.c = loc;
arc.a1 = 0;
arc.a2 = 2*pi;
arc.w = R;      % arc outside radius
arc.e = R/50;

ce = {};
ce{1} = gdsii_arc(arc, layer);
ce{2} = gdsii_ptext(name, loc+1.1*[R,R], 0.5, layer);

return
