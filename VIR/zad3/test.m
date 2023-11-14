[robust_e,robust_y,u_robust,w_robust]=sim_URO1(Pop{1}(1,:))
[normal_e,normal_y,u_normal,w_normal]=sim_URO1(Pop{1}(1,:))
T = 0.1
figure
hold on
plot(w_robust,'r')
plot(robust_y,'g');
ydif=diff(robust_y)
ydif(4800)=ydif(4799)
figure
hold on
plot(ydif,'b')
ydif2=diff(ydif)
ydif2(4800)=ydif2(4799)
figure
hold on
plot(ydif2,'bo')
ydif3=diff(ydif2)
ydif3(4800)=ydif3(4799)
figure
hold on
plot(ydif3,'rx')
e_integral = cumsum(robust_e) * T;
figure
hold on
plot(e_integral,'g-')
udif=diff(u_robust)
udif(4800)=udif(4799)
figure
hold on
plot(udif,'b')
% Nd1y=Ny/T_sim
% Nd2y=Nd1y/T_sim
% Nd3y=Nd2y/T_sim
% Nie=Ne*T_sim
% Nd1u=Nu/T_sim
plot(normal_y,'r')
xlabel('t[s]');
ylabel('y[-]');
legend('Wanted','Robust','Normal')

figure;
plot(u_normal,'r')
title('AKCNY ZASAH NORMALNY NA ROBUSTNOM MODELY');
xlabel('t[s]');
ylabel('u[-]');
hold off