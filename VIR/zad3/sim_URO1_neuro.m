% funkcia na simulaciu regulacie SISO s regulatorom, bez simulinku
% obdlznikova nahrada integracie

function [e,y,u,w] = sim_URO1_neuro(W1, W2, W3, B1, B2)

Umax = 300000;
Ny = 1/((225-(-30))/2);
Nd1y = 1/((30-(-30))/2);
Nd2y = 1/((100-(-100))/2);
Nd3y = 1/((120-(-120))/2);
Ne = 1/((50-(-50))/2); %
Nie = 1/((100-(-100))/2); %
Nd1u = 1/((30000-(-30000))/2); %

Ts=0.1; % perioda riadenia
Tsim=480; % doba simulacie

t=zeros(1,Tsim/Ts); y=zeros(1,Tsim/Ts); dy=zeros(1,Tsim/Ts); 
w=zeros(1,Tsim/Ts); u=zeros(1,Tsim/Ts); 
e=zeros(1,Tsim/Ts); et=zeros(1,Tsim/Ts);

% init. riadeneho dynamickeho systemu 3.rad
a0=2; a1=15; a2=8; a3=7; b0=0.2; b1=0.5; % par. riadeneho sys.
t1=0; u0=0; u1=0; y0=0; y1=0; du0=0; dy0=0; ddy0=0; ddy1=0; dy1=0; ie1=0;
ww=0; uu=0;

d1y1 = 0;
d2y1 = 0;
d1u1 = 0;

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
    y0=y1+dy0*Ts;
    du0=(u0-u1)/Ts;
 
    
 % ------------- neurocontroller
    
    % First derivative
    d1y=(y0-y1)/Ts; 
    % Second derivative
    d2y=(d1y-d1y1)/Ts; 
    % Third derivative
    d3y=(d2y-d2y1)/Ts; 
    d2y1=d2y; 
    d1y1=d1y;

    d1u=(u0-u1)/Ts; 
    d2u=(d1u-d1u1)/Ts; 
    d1u1=d1u;

    dy1=dy0; y(k)=y0; u(k)=u0; y1=y0; u1=u0;

    w(k)=ww; 
    e(k)=y(k)-w(k);
    ie=ie1+e(k)*Ts; 
    ie1=ie;
    dy(k)=d1y;

    % Input vector to NC
    X = [y0*Ny-1; d1y*Nd1y-1; d2y*Nd2y-1; d3y*Nd3y-1; e(k)*Ne-1; ie*Nie-1; d1u*Nd1u-1];
    % Cap each element of X to be within the range [-1, 1]
    X = max(min(X, 1), -1);
%     y0
%     d1y
%     e(k)
%     d1u
%     y0*Ny
%     d1y*Nd1y
%     d2y*Nd2y
%     d3y*Nd3y
%     e(k)*Ne
%     ie*Nie
%     d1u*Nd1u
    % Neural controller calculations
    A1=(W1*X)+B1; 
    O1=tanh(3*A1);
    A2=(W2*O1)+B2; 
    O2=tanh(3*A2);
    uu=W3*O2;
    u0=uu*Umax;

    % If any conditions or limits on the output, place them here.
    if isnan(u0) || isinf(u0) || u0>10^6
        u0 = 10^6;
    end
    u(k) = u0;

    if isnan(e(k)) || isinf(e(k))
        e(k) = 1e10;
    end
end
end