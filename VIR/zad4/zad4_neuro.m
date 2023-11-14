% funkcia na simulaciu regulacie SISO s regulatorom, bez simulinku
% obdlznikova nahrada integracie

function[fit,player_path,h_arr]=zad4_neuro(W1, W2, W3, B1, B2)

mapWidth = 50;
mapHeight = 50;

% Create an empty map filled with zeros
map = zeros(mapHeight, mapWidth);
% Define the loop outline with a thickness of 3 cells
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

player_pos = [6,20];
player_path = [];
heading = 0;
fit = 0;

checkpoints = cell(1,10);
checkpoint1 = [5:7;30,30,30];
checkpoint2 = [5:7;44,44,44];
checkpoint3 = [8,8,8;44:46];
checkpoint4 = [30,30,30;44:46];
checkpoint5 = [44:46;42,42,42];
checkpoint6 = [36,36,36;30:32];
checkpoint7 = [38:40;22,22,22];
checkpoint8 = [35,35,35;23:25];
checkpoint9 = [21,21,21;12:14];
finish = [5:7;20,20,20];

checkpoints{1} = checkpoint1;
checkpoints{2} = checkpoint2;
checkpoints{3} = checkpoint3;
checkpoints{4} = checkpoint4;
checkpoints{5} = checkpoint5;
checkpoints{6} = checkpoint6;
checkpoints{7} = checkpoint7;
checkpoints{8} = checkpoint8;
checkpoints{9} = checkpoint9;
checkpoints{10} = finish;

% map(5:7, 30) = 2; - prvy check
% map(30, 44:46) = 2; - druhy
% map(36, 30:32) = 2; - treti
% map(21, 12:14) = 2; - 4
% map(5:7, 20) = 3; - ciel
Tsim=700; % doba simulacie
err = 0;
reg = [];
h_arr =[];
checkpoint_id = 1;
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
        fit = fit -10;
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
    h_arr = [h_arr;heading];
    player_pos = updatePlayerPos(player_pos,heading);
    player_path = [player_path;player_pos];
%     distance penalty
    if length(player_path)>200
        fit = fit + length(player_path)-200;
    end
    %% fitness 
    if map(player_pos(1),player_pos(2)) == 0
        fit = fit + 5000;
    end
    if any(checkpoints{checkpoint_id}(1,:) ==player_pos(1)) && any(checkpoints{checkpoint_id}(2,:) == player_pos(2))
        checkpoint_id = checkpoint_id +1;
        fit = fit - 4000;
        if checkpoint_id == length(checkpoints)+1
%             end condition if finish reached
            break
        end
    end
end
% Combine the x and y values into a single column, so each position becomes a unique value
combined_positions = player_path(:, 1) + 1i * player_path(:, 2);

% Use the 'unique' function to find unique positions and their counts
[unique_positions, ~, counts] = unique(combined_positions);

% Display the unique positions and their counts
unique_positions = complex(real(unique_positions), imag(unique_positions));  % Separate real and imaginary parts
unique_counts = accumarray(counts, 1);

fit= fit+ 10*sum(unique_counts);