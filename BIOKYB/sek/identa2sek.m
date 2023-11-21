clear

y = [158
158
152
147
142
139
135
131
127
119
115
114
110
111
108
110
105
99
99
96
92
94
92
92
94]
y = y -y(1)
tout = [0:10:240]'
figure(1)

plot(tout,y)
ty = [tout,y]
u = zeros(25,1)
u(1,1) = 1
tu = [tout, u]



numgen=250;	% number of generations
lpop=56*2;	% number of chromosomes in population
lstring=3;	% number of genes in a chromosome
M=10;          % maximum of the search space

% Population initialisation

Space=[ones(1,lstring)*(-M); ones(1,lstring)*M];
Space=[-2 -0.2 -0.0001; 0 0.2 0.0001];

% Space=[ones(1,lstring)*(0); 50,1];
Delta=Space(2,:)/300;    % additive mutation step
Delta1 = Space(2,:)/2000;
Delta2 = Space(2,:)/50;
Pop=genrpop(lpop,Space);
evolution = zeros(1,numgen);
best_ch = zeros(lstring,numgen);
% Main cyklus --------------------------------- b)

for gen=1:numgen
    tic
    [Fit]=getFitness1(Pop);
    evolution(gen)=min(Fit);	            % convergence graph of the solution
    [Best,bfit]=selbest(Pop,Fit,[1*2,1*2]);          % optimum
    best_ch(:,gen) = Best(1,:)';
    Old=selrand(Pop,Fit,8*2);                     % vyssii selektivny tlak avsak so
    Work1=seltourn(Pop,Fit,8*2);               % zachovanim nahodneho vyberu
    Work1=[Work1; selrand(Pop,Fit,8*2)];      % pomerne vysoka mutacia zvisuje diverzitu
    Work2=seltourn(Pop,Fit,8*2);
    Work2=[Work2; selsus(Pop,Fit,8*2)];
    Work4=seltourn(Pop,Fit,8*2);
    Work1=mutx(Work1,0.2,Space);
    Work1=crossov(Work1,1,0);
    Work1 = muta(Work1,0.2,Delta1,Space);
    Work2=mutx(Work2,0.3,Space);
    Work2=muta(Work2,0.2,Delta,Space);
    Work3 = genrpop(6*2,Space);
    Work4 = muta(Work4,0.2,Delta2,Space);
    Pop=[Best;Old;Work1;Work2;Work3;Work4];
    a1 = best_ch(1,gen)
    b1 = best_ch(2,gen)
    b2 = best_ch(3,gen)
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

    a1 = best_ch(1,gen)
    b1 = best_ch(2,gen)
    b2 = best_ch(3,gen)
% a1 = 1.0125
% b1 = 0.3862
% b2 = 1.4276

% a1 = -0.0839
% b1 = 0.0198
% b2 =-8.0183e-05


% a1 = -0.0583
% b1 = 0.0083
% b2 = -1.5695e-05
% 
a1 = -0.0583
b1 = 0.0074
b2 =-5.4078e-06