%grandezze fisiche
M=40e-3; %massa carrello
m=60e-3;  %massa pendolo
%b=0.1;  %attrito carrello-pavimento
l=71e-3;  %lunghezza pendolo punta-asse orizzontale
I=m*l^2; %inerzia pendolo
g=9.81;

f=-M*m*l^2+I*(M+m);

%sistema senza distrurbi o rumori
A=[0 1 0 0; 0 0 l^2*m^2*g/f 0; 0 0 0 1; 0 0 -l*M*g/f 0];
B=[0 (I-l^2*m)/f 0 l*m/f]';
C=[1 0 1 0]; % NOTA: Kalman vuole sia theta che la posiione (che però è non osservabile tramite sensori)
D=0;

Vn=1;
Vd0=0.16; %varianza
Vd=Vd0*eye(4);

Bd=[B Vd zeros(4,1)];
Dd=[D 0 0 0 0 1];

% modelli con distrurbi e rumor i
Ts = 0.001;
sysD=ss(A,Bd,C,Dd); % modello t continuo
sysDD=c2d(sysD,Ts,'zoh'); % modello discreto Ts=1 ms