clear;
best = load("best_hard.mat")

canvas = zeros(5, 5);


% Draw the boat hull
canvas(4, 1:5) = 1; % Hull
canvas(5, 2:4) = 1; % Hull


canvas(1:3, 3) = 2; % sail
canvas(1:2, 4) = 2; % sail



mapWidth = 50;
mapHeight = 50;

% Create an empty map filled with zeros
map = zeros(mapHeight, mapWidth);
Chromosome = best(1).Best(1,:);

n_input = 25;
h1 = 20;
h2 = 10;
n_output = 1;

W1 = zeros(h1, n_input) * sqrt(2 / (n_input + h1));
B1 = zeros(h1, 1); % Biases initialized to zero
 
W2 = zeros(h2, h1) * sqrt(2 / (h1 + h2));
B2 = zeros(h2, 1); % Biases initialized to zero

W3 = zeros(n_output, h2) * sqrt(2 / (h2 + n_output));

% Decode chromosome to matrices and vectors
idx = 1;

% W1
len = numel(W1);
W1 = reshape(Chromosome(idx:idx+len-1), size(W1));
idx = idx + len;

% W2
len = numel(W2);
W2 = reshape(Chromosome(idx:idx+len-1), size(W2));
idx = idx + len;

% W3
len = numel(W3);
W3 = reshape(Chromosome(idx:idx+len-1), size(W3));
idx = idx + len;

% B1
len = numel(B1);
B1 = reshape(Chromosome(idx:idx+len-1), size(B1));
idx = idx + len;

% B2
len = numel(B2);
B2 = reshape(Chromosome(idx:idx+len-1), size(B2));

map(5:19, 5:7) = 1;
map(5:7, 8:46) = 1;
map(8:46, 44:46) = 1;
map(44:46, 30:43) = 1;
map(35:46, 30:32) = 1;
map(32:34, 25:32) = 1; %
map(32:40, 23:25) = 1; %
map(38:40, 12:25) = 1; %
map(20:40, 12:14) = 1; %
map(17:19, 5:14) = 1;

% Define a colormap for values 0, 1, 2, and 3
customColormap = [0.8, 0.8, 1; % 0: Very Light Blue
                  0, 0, 1;     % 1: Blue
                  0.5, 0.2, 0; % 2: Brown
                  0, 0, 0];    % 3: White

player_pos = [6,20];
player_path = [];
heading = 0;


Tsim=700; % doba simulacie

for k=1:(Tsim)  
[err, reg] = getRegion(player_pos,map);
    if err
       fit = 500000000;
       break
    end
    reg = rot90(reg,heading);
    reg = reg(:);
    X = reg;
    % Cap each element of X to be within the range [-1, 1]
    %%%%%%%%%%%%%%%%%%%%%%
%     X = max(min(X, 1), -1);
    % Neural controller calculations
    A1=(W1*X)+B1; 
    O1=tanh(3*A1);
    A2=(W2*O1)+B2; 
    O2=tanh(3*A2);
    uu=W3*O2;
    u0=uu;
    %%%%%%%%%%%%%%%%%%%%%%
    if 0.3>uu && uu>-0.3
        heading =heading+ 0;
    elseif uu> 0.3
        heading =heading + 1;
    else
        heading =heading -1;
    end
    if heading >=4
        heading =heading-4;
    end
    if heading <0
        heading = heading+4;
    end
    player_pos = updatePlayerPos(player_pos,heading);

    player_path = [player_path;player_pos];
    temp_map = map*0.9;
    temp_ship = canvas;
    temp_ship = rot90(temp_ship,heading);
    temp_map(player_pos(1)-2:player_pos(1)+2, player_pos(2)-2:player_pos(2)+2) = temp_ship;
    temp_map(player_pos(1), player_pos(2)) = 2;


    figure(3);
    imagesc(temp_map);
    colormap(customColormap);
    colorbar;
end




