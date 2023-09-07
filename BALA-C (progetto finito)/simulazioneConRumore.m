clear all
close all
clc

M = 0.055;
m = 0.044;
g = 9.8;
d = 0.083;
r = 0.0315;
l = 0.083; %[m]
Ip = (m*l^3)/3; %inerzia asta
l1 = 0.0315;
l2 = 0.0215;
Ir = M*(l1^2+l2^2); %inerzia ruote
f=Ip*(Ir+M*r^2+m*r^2);

A= [0 1 0 0;
    0 0 -r^2*g*d^2*m^2/f 0;
    0 0 0 1;
    0 0 (d*M*g)/Ip 0];

B= [0;
    (r^2*d*m+Ip)/f;
    0;
    -1/Ip];

C= [1 0 0 0;  %misura posizione del carretto
    0 0 1 0]; %misura angolo del pendolo  

D= [0;
    0];

pendolo = ss(A,B,C,D);
R = ctrb(A,B);
O = obsv(A,C);
rank(R);
rank(O);

%Controllore
K=place(A,B,[-15 -15.1 -15.2 -15.3]);


%% Consideriamo il sistema soggetto ad un WN sulla misura dell'angolo
Ts = 0.1;
t = 0:Ts:2;

v = wgn(length(t),1,0.1);

R = cov(v);

% Per il principio di sovrapposizione degli effetti separo i due
% problemi, quello di controllo tramite retroazione e quello della stima.
% Posso andare a stimare direttamente lo stato del sistema retroazionato

% Sistema con retroazione dallo stato
sys = ss(A-B*K,zeros(4,1),C,D);
sys.OutputName = {'yt1','yt2'};

x0 = [0 0 0.1 0]';
figure(1)
y=initial(sys,x0,t);
plot(t,y(:,2)+v,'LineWidth',2)
grid
legend('\theta misurato')
title('Angolo misurato')

% Costruisco il filtro di Kalman
[kalmf,L,~,Mx,Z] = kalman(sys,0,R);
kalmf = kalmf(1:2,:);
kalmf.InputName = {'y1','y2'};
kalmf.OutputName = {'ye1','ye2'};

x0K = [1 0.001 1 0.03]';
figure(2)
yk = lsim(kalmf,y,t,x0K);
plot(t,yk(:,2),'LineWidth',2)
grid
legend('\theta stimato')
title('Angolo stimato')

% Confronto tra la misura e la stima
figure(3)
plot(t,y(:,2)+v,'LineWidth',1)
hold on
plot(t,yk(:,2),'LineWidth',2)
grid
legend('\theta misurato','\theta stimato')
title('Confronto tra misura e stima')

% Confronto tra il valore realre e la stima
figure(4)
plot(t,y(:,2),'LineWidth',1)
hold on
plot(t,yk(:,2),'LineWidth',1)
grid
legend('\theta reale','\theta stimato')
title('Confronto tra valore reale e stima')




