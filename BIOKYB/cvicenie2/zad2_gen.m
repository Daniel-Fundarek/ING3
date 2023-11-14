clear
tic
AP = readtable('IVGTT_data/Dat_IVGTT_AP.csv');
Gb = AP{1,2}
Ib = AP{1,3}
I = AP{:, 1:2:3};
ap_G = AP{:,1:2}


% p2 = 1.0160e-04
% Si = 1.3612e-01
% Sg = 3.6105e-02

% p2 = 0.904
% Si = 0
% Sg = 0.0443

% p2 = 6.954145979786164e-04
% Si = 0.022461155547838
% Sg = 0.034134523608337

% p2 = 0.001783444185777
% Si = 0.009560785425972
% Sg = 0.033626632801997

% p2 = 8.761585564673931e-06
% Si = 1.67961977775126
% Sg = 0.034809903648878
% Sg = efektivita glukozy
% Si = index inzulinovej citlivosti
p2 = 7.979767090422910e-04; % [1/min]
Si = 0.022114795308026;     % [ml/uU/min]
Sg = 0.037264544080487;     % [1/min]


numgen=30;	% number of generations
lpop=48;	% number of chromosomes in population
lstring=3;	% number of genes in a chromosome
M=3;          % maximum of the search space

% Population initialisation

Space=[ones(1,lstring)*(0); ones(1,lstring)*M];
Delta=Space(2,:)/100;    % additive mutation step
Delta1 = Space(2,:)/1000;
Pop=genrpop(lpop,Space);
evolution = zeros(1,numgen);
% Main cyklus --------------------------------- b)

for gen=1:numgen
    [Fit]=fitness(Pop);
    evolution(gen)=min(Fit);	            % convergence graph of the solution
    [Best,bfit]=selbest(Pop,Fit,[1,1]);          % optimum
    Old=selrand(Pop,Fit,8);                     % vyssii selektivny tlak avsak so
    Work1=seltourn(Pop,Fit,8);               % zachovanim nahodneho vyberu
    Work1=[Work1; selrand(Pop,Fit,8)];      % pomerne vysoka mutacia zvisuje diverzitu
    Work2=seltourn(Pop,Fit,8);
    Work2=[Work2; selsus(Pop,Fit,8)];
    Work1=mutx(Work1,0.2,Space);
    Work1=crossov(Work1,1,0);
    Work1 = muta(Work1,0.2,Delta1,Space);
    Work2=mutx(Work2,0.3,Space);
    Work2=muta(Work2,0.2,Delta,Space);
    Work3 = genrpop(6,Space);
    Pop=[Best;Old;Work1;Work2;Work3];
    gen
end;  % gen
% Best solution
figure(4);
hold on 
plot(evolution);
%legend('e)')
title('evolution');
xlabel('generation');
ylabel('fitness');


% Legend{num} = strcat('Fitness: ',num2str(round(bfit(1),3)), ', P1 = ',num2str(round(Best(1,1),3)),', I1 = ',num2str(round(Best(1,2),3)),', D1 = ',num2str(round(Best(1,3),3)), ', P2 = ',num2str(round(Best(1,4),3)),', I2 = ',num2str(round(Best(1,5),3)),', D2 = ',num2str(round(Best(1,6),3)));
% 
% 
% bestP = [bestP; Best(1,:)];

hold off
toc
% legend(Legend)