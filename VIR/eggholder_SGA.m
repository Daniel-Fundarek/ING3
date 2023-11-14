clear
iterations = 10
numgen=2500 % number of generations	
lpop=250;	% number of chromosomes in population
lstring=10;	% number of genes in a chromosome
M=500;          % maximum of the search space
mean_evo = zeros(1,numgen);

for i=1: iterations


figure(5); hold on;

% Population initialisation

Space=[ones(1,lstring)*(-M); ones(1,lstring)*M];
Delta=Space(2,:)/40;    % additive mutation step

Pop=genrpop(lpop,Space);
% Main cyklus --------------------------------- b)

for gen=1:numgen

    Fit=eggholder(Pop);

    evolution(gen)=min(Fit);	% convergence graph of the solution

    % GA
    Best=selbest(Pop,Fit,[1,1]);   % optimum
    Old=selrand(Pop,Fit,10);       % vyssii selektivny tlak avsak so
    Work1=seltourn(Pop,Fit,5);     % zachovanim nahodneho vyberu
    Work1 = [Work1; selsus(Pop,Fit,8)];
    Work1=[Work1; selrand(Pop,Fit,5)];      % pomerne vysoka mutacia zvisuje diverzitu
    Work1=crossov(Work1,2,0);
    Work2=seltourn(Pop,Fit,10);
    Work2=[Work2; selsus(Pop,Fit,10)];
    Work2=mutx(Work2,0.3,Space);
    Work2=muta(Work2,0.2,Delta,Space);
    Pop=[Best;Old;Work1;Work2];

end;  % gen



% -------------------------------------------------

% Best solution
figure(5);
hold on 
plot(evolution,'DisplayName',sprintf('Run number: %g', i));
legend
% legend(sprintf('Run number: %g', i))
title('SGA');
xlabel('generation');
ylabel('fitness');

mean_evo = mean_evo + evolution;


hold off

end;
mean_evo = mean_evo/iterations
figure(6);
plot(mean_evo);

legend(sprintf('mean: %g iterations', i))
title(sprintf('SGA mean'));
xlabel('generation');
ylabel('fitness');
