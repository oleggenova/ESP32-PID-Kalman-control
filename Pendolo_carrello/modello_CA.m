%% modello in SS
%grandezze fisiche
M=40e-3; %massa carrello
m=60e-3;  %massa pendolo
b=0.1;  %attrito carrello-pavimento
l=71e-3;  %lunghezza pendolo punta-asse orizzontale
i=m*l^2; %inerzia pendolo
g=9.81;

%condizione iniziale 
p0 = 0;
theta0 = rand();
w0 = rand();
velocita0 = 0;

%modello come fdt
q=(M+m)*(i+m*l^2)-(m*l)^2;
num=[m*l/q 0];
den=[1 b*(i+m*l^2)/q -(M+m)*m*g*l/q -b*m*g*l/q];
pend=tf(num,den);


t=[0:0.001:5];

impulse(pend,t)
title('Risposta impulsiva catena aperta')
grid on

%% LUOGO RADICI
%plot luogo radici open loop
figure
rlocus(pend)
title('Luogo radici catena aperta')
sigrid(0.92)
axis([-6 6 -6 6])

%rete correttrice per luogo radici
contr_rlc1=tf(1,[1 0]);
figure
rlocus(contr_rlc1*pend);
sigrid(0.92)
axis([-10 10 -10 10])
title('Luogo radici compensazione 1')

%aggiunta di poli e zeri
z1=3; z2=4; 
p1=0; %polo che compensa zero in origine
p2=60; %polo lontano

% rete correttrice migliorata
numc=conv([1 z2],[1 z1]);
denc=conv([1 p2],[1 p1]);
contr_rlc=tf(numc,denc);
figure
rlocus(contr_rlc*pend)
title('Luogo radici compensazione 2')

%prelevo gain per la rete correttrice
[k_freq,poles]=rlocfind(contr_rlc*pend); %scelgie graficamente gain e poli corrispondenti
sys_cl_rlc=feedback(pend,contr_rlc*k_freq);


%% PID
Ki=177.3;
Kp=27.59;
Kd=1.073;
contr_PID=tf([Kd Kp Ki],[1 0]);
sys_cl_PID=feedback(pend*contr_PID,1);

%% Studio in freq
%riceve da tastiera i valore del controllore
% nc=input('inserire il numeratore del controllore: ');
% dc=input('inserire il denominatore del controllore: ');
% k_freq=input('inserire il guadagno del controllore: ');

nc=[20 140 200];
dc=[0.001 1 0];
k_freq=20;

%BODE 
figure
contr_freq=k_freq*tf(nc,dc);
sys_cl_freq=pend*contr_freq;
bode(sys_cl_freq);
grid on

%NYQUIST
figure
nyquist(sys_cl_freq)
grid on

%risp impulsiva
sys_cl_freq=feedback(pend,contr_freq);

%% Confronto tra le risposte impulsive

figure
impulse(sys_cl_rlc,t) %con root locus
hold on
impulse(sys_cl_PID,t) %con PID
impulse(sys_cl_freq,t) %con sintesi in freq
title('Risposta impulsiva');
legend('retro root locus','retro PID','retro freq')
grid on
xlabel('time')
ylabel('\theta (rad)')