mapWidth = 50;
mapHeight = 50;

% Create an empty map filled with zeros
map = zeros(mapHeight, mapWidth);

map(5:19, 5:7) = 1;
map(5:7, 8:46) = 1;
map(8:46, 44:46) = 1;
map(44:46, 30:43) = 1;
map(35:46, 30:32) = 1;
map(32:34, 25:32) = 1;
map(32:40, 23:25) = 1; %
map(38:40, 12:25) = 1; %
map(20:40, 12:14) = 1; %

map(17:19, 5:14) = 1;




map(30, 44:46) = 2;
map(5:7, 30) = 2;
map(21, 12:14) = 2;
map(36, 30:32) = 2;

map(5:7, 44) = 2;
map(8, 44:46) = 2;
map(38:40,22) = 2;%
map(35,23:25) = 2;%
map(44:46,42) = 2;


temp_map = map;
temp_map(33, 13) = 4;

figure(4);
imagesc(temp_map);
colormap(customColormap);
colorbar;