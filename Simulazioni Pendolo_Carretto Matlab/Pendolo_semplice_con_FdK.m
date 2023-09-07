clc
clear all 

g=10; 
d=1;
m=0.5;

%Matrici di sistema
A=[0 1; -g/d 0];
B=[0; 1/d^2*m];
C=[1 0]; %misuriamo solo l'angolo theta del pendolo

%Raggiungibilità e Osservabilità
R=ctrb(A,B);
r_R=rank(R); %RAGG
O=obsv(A,C);
r_O=rank(O); %OSS

Vd=0.1*eye(2); %matrice cov disturbo processo
Vn=0.1; %matrice cov rumore misurazione

Bd=[B Vd zeros(2,1)];
Dd=[0 0 0 1];

%Costruzione sistema con disturbo e rumore
sysD=ss(A,Bd,C,Dd)

%Costruzione sistema con disturbo senza rumore e 
%misura di tutte le variabili di stato(E per easy)
%Serve per confrontarlo con il KF
sysE=ss(A,Bd,eye(size(A,1)),zeros(size(A,1),size(Bd,2)))

%Costruzione del filtro di Kalman
[Kf,P,E]=lqe(A,Vd,C,Vd,Vn); %guadagno del filtro
sysKF=ss(A-Kf*C,[B Kf],eye(2),0*[B Kf])

%Simulazioni
dt=0.005; %dt più piccolo maggiore precisione
t=dt:dt:10;

u=zeros(1,size(t,2));
d=randn(2,size(t,2));
n=randn(1,size(t,2));

U=[u;d;n];

%Simulazione sistema ed osservazione uscita sensore rumoroso
[yD, t]=lsim(sysD,U,t,[0.1;0]);
figure(1)
plot(t,yD)
hold on

%Simulazione sistema con osservazione degli stati
[yE, t]=lsim(sysE,U,t,[0.1;0]);
plot(t,yE(:,1))
hold off
title('Comparazione tra uscita sensore rumoroso e stato reale')
legend('\theta misurato','\theta reale')

%Simulazione sistema KF
[yKF,t]=lsim(sysKF,[u; yD'],t,[0.1;0]);
figure(2)
plot(t,yKF)
hold on
plot(t,yE)
hold off
title('Comparazione tra stima del KF e stato reale')
legend('\theta reale','\omega reale','\theta stimato','\omega stimato')


% discretizzo il sistema con rumore sysD
discretizzato=c2d(sysD, 0.001, 'zoh');