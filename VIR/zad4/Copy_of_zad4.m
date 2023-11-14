clc; clear;
% Define map dimensions
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

map(30, 44:46) = 2;
map(5:7, 30) = 2;
map(21, 12:14) = 2;
map(36, 30:32) = 2;
map(5:7, 44) = 2;
map(8, 44:46) = 2;
map(38:40,22) = 2;%
map(35,23:25) = 2;%
map(44:46,42) = 2;
map(5:7, 20) = 3;


% % map(6,20) = 4
% % player init
% player_pos = [6,20]
% player_path = []
% player_path = [player_path;player_pos]

% Fill in the interior of the loop with zeros
map(8:15, 8:43) = 0;

% Define a colormap for values 0, 1, and 2
customColormap = [1, 1, 1; % 0: White
                  0, 0, 1; % 1: Blue
                  0, 1, 0; % 2: Green
                  1, 0, 0;
                  0, 0, 0.5]; 

% nn init
n_input = 25;
h1 = 20;
h2 = 10;
n_output = 1;

W1 = zeros(h1, n_input) * sqrt(2 / (n_input + h1));
B1 = zeros(h1, 1); % Biases initialized to zero
 
W2 = zeros(h2, h1) * sqrt(2 / (h1 + h2));
B2 = zeros(h2, 1); % Biases initialized to zero

W3 = zeros(n_output, h2) * sqrt(2 / (h2 + n_output));

    % Population initialisation
    numgen=15000	% number of generations
    lpop=50;	% number of chromosomes in population
    lstring = numel(W1) + numel(W2) + numel(W3) + numel(B1) + numel(B2);
    M=1;          % maximum of the search space
    
    Space=[ones(1,lstring)*-M; ones(1,lstring)*M];
    Delta=Space(2,:)/300;    % additive mutation step
    
    Pop=genrpop(lpop,Space);
    
    % Main cyklus ---------------------------------
    
    for gen=1:numgen
        clc
        disp(['Progress: ' num2str((gen / numgen) * 100) '%']);
        
        for pop_num=1:size(Pop(:,1))

            % For demonstration, take the first chromosome as an example
            Chromosome = Pop(pop_num,:);
        
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

            [f1,path,h_arr] = zad4_neuro(W1, W2, W3, B1, B2);
            Path{pop_num}=path;
            Fit(pop_num) =f1;

        end

        [evolution(gen),min_ind]=min(Fit);
        player_path = Path{min_ind};
        
        temp_map = map;
        for i = 1:size(player_path, 1)
            
            x = player_path(i, 1);
            y = player_path(i, 2);
            
            % Check if the indices are within the bounds of your_array
            if x >= 1 && x <= size(temp_map, 1) && y >= 1 && y <= size(temp_map, 2)
                temp_map(x, y) = 4;
            end
        end
                    % Display the map with the custom colormap
        figure(1);
        imagesc(temp_map);
        colormap(customColormap);
        colorbar;
        

        % GA
        Best=selbest(Pop,Fit,[1,1]);   % optimum
        Old=selrand(Pop,Fit,10);      
        Work1=seltourn(Pop,Fit,50);    
        Work1 = [Work1; selsus(Pop,Fit,8)];
        Work1=[Work1; selrand(Pop,Fit,5)];      
        Work1=crossov(Work1,5,0);
        Work2=seltourn(Pop,Fit,10);
        Work2=[Work2; selsus(Pop,Fit,10)];
        Work2=mutx(Work2,0.3,Space);
        Work2=muta(Work2,0.3,Delta,Space);
        Pop=[Best;Old;Work1;Work2];
    
    end;  % gen
figure(2)
plot(evolution)








% % Display the map with the custom colormap
% figure(1);
% imagesc(map);
% colormap(customColormap);
% colorbar;
% 
% % Adjust axis properties for a clear display
% axis image;
% axis off;

% [err, reg] = getRegion(player_pos,map)
% reg = rot90(reg,3)


% sum_of_ones = sum(map(:) == 1);
% min_len = sum_of_ones/4;
% bounty_count = 0;
% if bounty_count == 4
% %     goal bounty
%     if map(x, y) == 3
%         bounty_count= bounty_count + 1;
%     end
% end
% 







