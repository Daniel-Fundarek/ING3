clear
tic
FK = readtable('Dat_FK.csv');
FK = FK{:,1:2}

numgen=40;	% number of generations
lpop=56;	% number of chromosomes in population
lstring=3;	% number of genes in a chromosome
M=200;          % maximum of the search space

% Population initialisation

% Space=[ones(1,lstring)*(0.001); ones(1,lstring)*M];
Space=[ones(1,lstring)*(0);200,200,1];

Delta=Space(2,:)/100;    % additive mutation step
Delta1 = Space(2,:)/2000;
Delta2 = Space(2,:)/500;
Pop=genrpop(lpop,Space);
evolution = zeros(1,numgen);
best_ch = zeros(3,numgen);
% Main cyklus --------------------------------- b)

for gen=1:numgen
    [Fit]=fitness(Pop);
    evolution(gen)=min(Fit);	            % convergence graph of the solution
    [Best,bfit]=selbest(Pop,Fit,[1,1]);          % optimum
    best_ch(:,gen) = Best(1,:)';
    Old=selrand(Pop,Fit,8);                     % vyssii selektivny tlak avsak so
    Work1=seltourn(Pop,Fit,8);               % zachovanim nahodneho vyberu
    Work1=[Work1; selrand(Pop,Fit,8)];      % pomerne vysoka mutacia zvisuje diverzitu
    Work2=seltourn(Pop,Fit,8);
    Work2=[Work2; selsus(Pop,Fit,8)];
    Work4=seltourn(Pop,Fit,8);
    Work1=mutx(Work1,0.2,Space);
    Work1=crossov(Work1,1,0);
    Work1 = muta(Work1,0.2,Delta1,Space);
    Work2=mutx(Work2,0.3,Space);
    Work2=muta(Work2,0.2,Delta,Space);
    Work3 = genrpop(6,Space);
    Work4 = muta(Work4,0.2,Delta2,Space);
    Pop=[Best;Old;Work1;Work2;Work3;Work4];
    gen
end;  % gen
% Best solution
figure(4);
hold on 
plot(evolution);
title('evolution');
xlabel('generation');
ylabel('fitness');


hold off
figure(5);
hold on;
plot(best_ch(1,:));
plot(best_ch(2,:));
plot(best_ch(3,:));
hold off
toc
Ti = best_ch(1,end)
Vi = best_ch(2,end)
ki = best_ch(3,end)
v = 281.280
% Ti = 47.5078;
% ki = 0.1441;
% Vi = 152.038;
% legend(Legend)