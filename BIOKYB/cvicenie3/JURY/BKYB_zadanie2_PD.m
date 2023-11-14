% BKYB ZS 2023
% Zadanie č.2
% Juraj Čižmár

clear; clc;
load data;

%% Farmakodynamika

time = data_FK(:,1);
pk = data_FK(:,2)/6;
PK = [time pk];

time = data_FD(:,1);
pd = data_FD(:,2)/64.5; % 64.5
PD = [time pd]; 
Ra = [time pd];

sampleTime = 0.5;

% figure(1)
% plot(time, pd); grid on;

vb = 281.218;

G0 = 153;
Gb = G0;
SI = 1.59e-3;
p2 = 1.06e-2;
VG = 1.467;
SG = 0; % 0.0361;

% TI = 43.5513; 
% KI = 0.0908; 
% VI = 253.3319;

TI = 41.9163; 
KI = 0.1638; 
VI = 145.7607;

% TI = 44.55; % Marianove
% KI = 0.1645;
% VI = 138.8;

S1b = vb*TI;
S2b = vb*TI;
Ib = vb/(KI*VI);

out = sim('BKYB_zadanie2_PD_Berg_sim.slx');
RA = out.RA;

time = 0:sampleTime:600;
bazalTime = 0:10:600;
plotbazal = ones(1,(600/10)+1)*G0/18;
bazal = ones(1,(600/sampleTime)+1)';

%% ========================= GA ==============================

numgen = 50;	% number of generations
PopSize = 50;	% number of chromosomes in population
lstring = 2;	% number of genes in a chromosome
M = 1;          % maximum of the search space

% Population initialisation
Space = [zeros(1, lstring); ones(1, lstring)*M];
Delta = Space(2,:)/5e2;    % additive mutation step

Pop = genrpop(PopSize, Space);
Fit = zeros(1, PopSize);
evolution = zeros(1,numgen);

NajPapi = ones(1,2);
[~,s] =size(NajPapi);
susPop = floorDiv(PopSize,4);
randPop = PopSize-s-susPop;

%% Main cyklus ---------------------------------
for gen = 1:1:numgen
    for i = 1:1:PopSize
        p2 = Pop(i,1);
        SI = Pop(i,2);
        out = sim('BKYB_zadanie2_PD_Berg_sim.slx');
        e = out.VgXG - out.RA;
        Fit(i) = sum(abs(e));
    end

    evolution(gen) = min(Fit);	% convergence graph of the solution

    % GA
    Best = selbest(Pop,Fit,NajPapi);
    Old = selsus(Pop,Fit,susPop);
    Work = selrand(Pop,Fit,randPop);
    Work = crossov(Work,1,0);
    Work = mutx(Work,0.15,Space);
    Work = muta(Work,0.15,Delta,Space);
    Pop = [Best;Old;Work];

fprintf('progress: %3.2f%%\n', (gen/numgen)*100);
end 
%% -------------------------------------------------
% Best solution
for i = 1:1:PopSize
    p2 = Pop(i,1);
    SI = Pop(i,2);
    out = sim('BKYB_zadanie2_PD_Berg_sim.slx');
    e = out.VgXG - out.RA;
    Fit(i) = sum(abs(e));
end

najlepsi = selbest(Pop, Fit, 1);
p2 = najlepsi(1);
SI = najlepsi(2);

figure(1); 
plot(evolution, 'LineWidth',2); grid on;
title('evolution');
xlabel('generation');
ylabel('fitness');
%%
out = sim('BKYB_zadanie2_PD_Berg_sim.slx');
G = out.G;
X = out.X;
RA = out.RA;
VgXG = out.VgXG;

figure(2)
plot(time, RA, 'b-', 'LineWidth', 2); hold on; grid on;
plot(time, VgXG, 'r-', 'LineWidth', 2);
title('Inzulin - Obdržane dáta vs namerané');
xlabel('time [min]');
ylabel('I(t) [μU/ml]');
xlim([0 600]);

figure(3)
plot(time, G, 'g-', 'LineWidth', 2); hold on; grid on;
plot(bazalTime, plotbazal, 'k--')
title('Glykemia');
xlabel('time [min]');
ylabel('I(t) [μU/ml]');
xlim([0 600]);
ylim([6 12]);

SI = 1.59e-3;
p2 = 1.06e-2;


