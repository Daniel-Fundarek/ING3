Ti = 45.383;
ki = 0.1629;
Vi = 139.094;

Vg = 1.467;
Sg = 0;
Gb = 153;
Si = 0.00156;
p2 = 0.0109;
Ib = 6.5;

Ag =0.95;
weight = 64.4;

vb = 281.280

vB1= load("Dat_D00_bolus.csv");
vB = []
for i=1:size(vB1)
    vB(i*2-1,:) = vB1(i,:);
    vB(i*2,:) = [vB1(i,1)+5,0];
end

vB(:,2) = vB(:,2)*1e6/(64.4*5);

vb = load("Dat_D00_Basal.csv")
vb(:,2) =vb(:,2)* (1e6/(65*5))/60;

dt1 = load("Dat_D00_carb.csv");
dt = []
for i=1:size(dt1)
    dt(i*2-1,:) = dt1(i,:);
    dt(i*2,:) = [dt1(i,1)+5,0];
end
dt(:,2) = dt(:,2)*(1e4/(64.6*5));

sensorG = load("Dat_D00_sensor.csv")


% Td = 33.32;
% Sg =0.032;

Td = 39.00;
Sg =0.03376;

% figure(1)
% hold on
% plot(FK(:,1),FK(:,2)/6)
% plot(FK(:,1),FK(:,2)/6,'x')
% hold off
% 
% figure(8)
% hold on
% plot(FD(:,1),FD(:,2)/6)
% plot(FD(:,1),FD(:,2)/6,'x')
% hold off


numgen=40;	% number of generations
lpop=56;	% number of chromosomes in population
lstring=2;	% number of genes in a chromosome
M=0.1;          % maximum of the search space

% Population initialisation

% Space=[ones(1,lstring)*(0); ones(1,lstring)*M];

Space=[ones(1,lstring)*(0); 50,1];
Delta=Space(2,:)/100;    % additive mutation step
Delta1 = Space(2,:)/2000;
Delta2 = Space(2,:)/10;
Pop=genrpop(lpop,Space);
evolution = zeros(1,numgen);
best_ch = zeros(2,numgen);
% Main cyklus --------------------------------- b)

for gen=1:numgen
    [Fit]=fitness_last(Pop);
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

hold off
toc
p2 = best_ch(1,end)
Si = best_ch(2,end)