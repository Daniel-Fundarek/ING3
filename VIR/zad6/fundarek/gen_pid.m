clear

K = 1.0121;
T = 0.891;
Td = 0.2811;

tout = [0;20;40;60;80;100]';
w = [4;6.5;3;5;7;3.5]';
tw = [tout;w]';

numgen=10;	% number of generations
lpop=56;	% number of chromosomes in population
lstring=3;	% number of genes in a chromosome
M=10;          % maximum of the search space

% Population initialisation

Space=[ones(1,lstring)*(0); ones(1,lstring)*M];

% Space=[ones(1,lstring)*(0); 50,1];
Delta=Space(2,:)/100;    % additive mutation step
Delta1 = Space(2,:)/2000;
Delta2 = Space(2,:)/10;
Pop = zeros(lpop,lstring);
% Pop=genrpop(lpop,Space);
evolution = zeros(1,numgen);
best_ch = ones(lstring,numgen);
% Main cyklus --------------------------------- b)

for gen=1:numgen
    tic
    [Fit]=getFitnessPid(Pop);
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
    toc
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
P = best_ch(1,end)
I = best_ch(2,end)
D = best_ch(3,end)

% First try
% P = 1.9724
% I = 1.0440
% D = 0
% Second
% P = 1.792
% I = 1.8267
% D = 0
% Third
% P = 0.8656
% I = 1.0656
% D = 0
%Forth
% P =0.8340
% I = 1.5712
% Fifth
% P = 0.6002
% I = 0.857
% Sixth
% P = 1.9695
% I = 2.5090
% Seventh
% P = 1.5014
% I = 1.8503

% P = 1.4396
% I =  1.5812

% Slow without overshoot
P = 0.6378
I = 0.7674
D = 0