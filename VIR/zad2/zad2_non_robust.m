clear
clc
iterations = 1;
numgen=1500	;% number of generations
lpop=50;	% number of chromosomes in population
lstring=3;	% number of genes in a chromosome
M=1;          % maximum of the search space
mean_evo = zeros(1,numgen);

for iteration=1: iterations

% Population initialisation

Space=[ones(1,lstring)*(0); ones(1,lstring)*M];
Delta=Space(2,:)/40;    % additive mutation step

% generate populations
for i=1:5
    Pop{i}=genrpop(lpop,Space);
end
evolution = cell(5,1);
for gen=1:numgen
    gen
    % evaluate current generation populations
    for pop_ind =1:5
        [evolution{pop_ind}, Pop{pop_ind}] = new_generation2(Pop{pop_ind},gen,Space,Delta,evolution{pop_ind});
    end
    % migrate population
    if mod(gen,50) == 0
        Pop = migrate_best(Pop);
    end
    % regenarate new population
    if mod(gen,500) == 0
        for i=2:5
            Pop{i}=genrpop(lpop,Space);
        end
    end

end
figure(8)
[e,y] = sim_URO1(Pop{1}(1,:));
hold on 
plot(y)
plot(y+e)
ylim([-500, 500]); % Set ymin and ymax to the desired limits for the y-axis
xlim([0, 5000]);
hold off

f1 = figure(1);
clf(f1);
% Loop through the 'evolution' cell array and plot each array
hold on; % To overlay the plots on the same figure
for i = 1:length(evolution)
    plot(1:numgen, evolution{i});
end
hold off;
xlabel('Iteration');
ylabel('Fitness');
legend()

mean_evo = mean_evo + evolution{1};
end
mean_evo = mean_evo/iterations;
figure(7);
plot(mean_evo);
figure(1);
hold on 
plot(mean_evo,'--');
hold off


