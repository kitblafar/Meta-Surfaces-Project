%% Creating a geometry demonstration image
close all
clc

% define elipse points
stepWidth = 10; % number of radius test values in each direction
th = linspace(0, 2*pi);
a = 20:stepWidth:200;
b = 20:stepWidth:200;
noRadValues = (200-20)/stepWidth +1;
figure;

for i=1:noRadValues
    for j=1:noRadValues
        % Ellipse 
        x = a(i)*50+a(i)*cos(th) ; 
        y = b(j)*50+b(j)*sin(th) ; 
        
        %plot the elipse
        hold on;
        plot(x,y);
        
    end
end

set(gca,'xtick',[])
set(gca,'ytick',[])
title('Polarised Pillar Geometry')
xlabel('Increasing Horizontal Radius')
ylabel('Increasing Vertical Radius')
xlim(gca,[760.36866359447 10382.4884792627]);
ylim(gca,[682.215743440234 10478.1341107872]);

%mark a cross showing maximum and minimum radius on each max and min elipse