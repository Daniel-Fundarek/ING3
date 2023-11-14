% Create a blank canvas
canvas = zeros(10, 10);


% Draw the boat hull
canvas(4, 1:5) = 2; % Hull
canvas(5, 2:4) = 2; % Hull


canvas(1:3, 3) = 1; % sail
canvas(1:2, 4) = 1; % sail
% % Draw the sail
% sail = [0, 1, 0; 0, 1, 0; 0, 1, 0];
% canvas(1:3, 4:6) = sail; % Attach the sail

% Display the boat
imshow(canvas, 'InitialMagnification', 'fit');