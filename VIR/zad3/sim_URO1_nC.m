% funkcia na simulaciu regulacie SISO s regulatorom, bez simulinku
% obdlznikova nahrada integracie

function[e,y,u,w]=sim_URO1_nC(W1, W2, W3, B1, B2)


Umax = 1e5;



Ny = 228;
Ndy = 1.036e+03;
Ne = 200;
Nd1u = 2.66e+06;
% Nd1y = 1/((120));
% Nd2y = 1/((150));
% Nd3y = 1/((150));
% Ne = 1/((500)); %
% Nie = 1/((200)); %
% Nd1u = 1/((1500)); %

Ts=0.1; % perioda riadenia
Tsim=480; % doba simulacie

t=zeros(1,Tsim/Ts); y=zeros(1,Tsim/Ts); dy=zeros(1,Tsim/Ts); 
w=zeros(1,Tsim/Ts); u=zeros(1,Tsim/Ts); 
e=zeros(1,Tsim/Ts); et=zeros(1,Tsim/Ts);

% init. riadeneho dynamickeho systemu 3.rad
a0=2; a1=15; a2=8; a3=7; b0=0.2; b1=0.5; % par. riadeneho sys.
t1=0; u0=0; u1=0; y0=0; y1=0; du0=0; dy0=0; ddy0=0; ddy1=0; dy1=0; ie1=0;
ww=0; uu=0; d1y0 = 0; d2y0 =0;d1u = 0;

umax=1e5;  % maximalny vystup


% ------------ cyklus simulacie URO

for k=1:(Tsim/Ts)  
    
%--------- cas, vstupy, vystupy
    
    t(k)=t1+Ts; % t
    t1=t(k);
   
% scenar regulacie  
 
        if t(k)>=450
            ww=200;  
        elseif t(k)>=420
            ww=180;
        elseif t(k)>=390
            ww=200;
        elseif t(k)>=360
            ww=180;
        elseif t(k)>=330
            ww=20;
        elseif t(k)>=300
            ww=0;  
        elseif t(k)>=270
            ww=20;
        elseif t(k)>=240
            ww=0;
            a3=15;
        elseif t(k)>=210
            ww=180;
        elseif t(k)>=180
            ww=200; 
        elseif t(k)>=150
            ww=180;
        elseif t(k)>=120
            ww=200;
        elseif t(k)>=90
            ww=0;
        elseif t(k)>=60
            ww=20;  
        elseif t(k)>=30
            ww=0;
        elseif t(k)>=1
            ww=20; 
        elseif t(k)>=0
            ww=0;
        end

    
% --------------------------------- simulacia systemu
    
    dddy0=(b0*u0+b1*du0-(0.1+y0/2)*ddy0-a1*dy0-a0*y0)/a3;
    ddy0=ddy1+dddy0*Ts;
    dy0=dy1+ddy0*Ts; 
    y0=y1+dy0*Ts; %
    du0=(u0-u1)/Ts;
 
    
    % ------------- regulator
    
    y(k)=y0; u(k)=u0;  u2=u1; u1=u0; % posuny v case pre rekurencie
    
    
    w(k)=ww;
    ww1=ww;
    e(k)=w(k)-y(k);
    ie=ie1+e(k)*Ts;
    ie1=ie;
    dy(k)=(y0-y1)/Ts; %
    y1=y0;
    d1y = dy(k);

    d2y = (dy(k)-d1y0)/Ts;
    d3y = (d2y-d2y0)/Ts;
    d1u = (u1-u2)/Ts;



    % Input vector to NC
    X = [e(k)/200;ie/70;d1y/Ndy];
    % Cap each element of X to be within the range [-1, 1]
    %%%%%%%%%%%%%%%%%%%%%%
    X = max(min(X, 1), -1);
    % Neural controller calculations
    A1=(W1*X)+B1; 
    O1=tanh(3*A1);
    A2=(W2*O1)+B2; 
    O2=tanh(3*A2);
    uu=W3*O2;
    u0=uu*Umax;
    %%%%%%%%%%%%%%%%%%%%%%
    d2y0 = d2y;
    
%     u0=(ch(1)*e(k)+ch(2)*ie+ch(3)*dy(k))*umax;  % PID regulator z chromozomu, 0<ch(i)<1
    u(k)=u0;
    if (isnan(e(k)) | isinf(e(k)))
        e(k) = 1000000000;
        y(k) = 1000000000;
    end
    
   
end