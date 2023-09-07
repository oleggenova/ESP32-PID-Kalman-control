%% modello in SS
%grandezze fisiche
M=0.5; %massa carrello
m=0.2;  %massa pendolo
b=0.1;  %attrito carrello-pavimento
l=0.3;  %lunghezza pendolo
i=0.006; %inerzia pendolo
g=9.8;

%condizione iniziale 
p0 = 0;
theta0 = 1.5;
w0 = 2;
velocita0 = 0;

%modello come fdt
q=(M+m)*(i+m*l^2)-(m*l)^2;
num=[m*l/q 0];
den=[1 b*(i+m*l^2)/q -(M+m)*m*g*l/q -b*m*g*l/q];
pend=tf(num,den);


t=[0:0.001:3];
figure(1)
impulse(pend,t)
title('Risposta impulsiva catena aperta')
grid on

%% PID
Ki=1;
Kp=100;
Kd=20;
contr_PID=tf([Kd Kp Ki],[1 0]);
sys_cl_PID=feedback(pend,contr_PID);
figure(2)
impulse(sys_cl_PID,t)
axis([0 5 -2 2])
title('Risposta impulsiva controllo PID')
grid on