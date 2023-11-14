% funkcia na simulaciu regulacie SISO s regulatorom, bez simulinku
% obdlznikova nahrada integracie

function[e,y]=sim_URO2(ch)

Ts=0.1; % perioda riadenia
Tsim=480; % doba simulacie

t=zeros(1,Tsim/Ts); y=zeros(1,Tsim/Ts); dy=zeros(1,Tsim/Ts); 
w=zeros(1,Tsim/Ts); u=zeros(1,Tsim/Ts); 
e=zeros(1,Tsim/Ts); et=zeros(1,Tsim/Ts);

% init. riadeneho dynamickeho systemu 3.rad
a0=2; a1=15; a2=8; a3=11; b0=0.2; b1=0.5; % par. riadeneho sys.
t1=0; u0=0; u1=0; y0=0; y1=0; du0=0; dy0=0; ddy0=0; ddy1=0; dy1=0; ie1=0;
ww=0; uu=0;

umax=1e5;  % maximalny vystup


% ------------ cyklus simulacie URO

for k=1:(Tsim/Ts)  
    
%--------- cas, vstupy, vystupy
    
    t(k)=t1+Ts; % t
    t1=t(k);
   
% scenar regulacie  
 
        if t(k)>=450
            ww=110;  
        elseif t(k)>=420
            ww=90;
        elseif t(k)>=390
            ww=110;
        elseif t(k)>=360
            ww=90;
        elseif t(k)>=330
            ww=110;
        elseif t(k)>=300
            ww=90;  
        elseif t(k)>=270
            ww=110;
        elseif t(k)>=240
            ww=90;
%             a3=15;
        elseif t(k)>=210
            ww=110;
        elseif t(k)>=180
            ww=90; 
        elseif t(k)>=150
            ww=110;
        elseif t(k)>=120
            ww=90;
        elseif t(k)>=90
            ww=110;
        elseif t(k)>=60
            ww=90;  
        elseif t(k)>=30
            ww=110;
        elseif t(k)>=1
            ww=90; 
        elseif t(k)>=0
            ww=0;
        end

    
% --------------------------------- simulacia systemu
    
    dddy0=(b0*u0+b1*du0-(0.1+y0/2)*ddy0-a1*dy0-a0*y0)/a3;
    ddy0=ddy1+dddy0*Ts;
    dy0=dy1+ddy0*Ts;
    y0=y1+dy0*Ts;
    du0=(u0-u1)/Ts;
 
    
    % ------------- regulator
    
    y(k)=y0; u(k)=u0; y1=y0; u2=u1; u1=u0; % posuny v case pre rekurencie
    
    w(k)=ww;
    ww1=ww;
    e(k)=w(k)-y(k);
    ie=ie1+e(k)*Ts;
    ie1=ie;
    dy(k)=(y0-y1)/Ts;
    
    u0=(ch(1)*e(k)+ch(2)*ie+ch(3)*dy(k))*umax;  % PID regulator z chromozomu, 0<ch(i)<1
    u(k)=u0;
    if (isnan(e(k)) | isinf(e(k)))
        e(k) = 1000000000;
        y(k) = 1000000000;
    end
    
   
end