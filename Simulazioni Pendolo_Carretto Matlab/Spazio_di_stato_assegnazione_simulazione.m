clear all
close all
clc

M = 0.5;
m = 0.2;
I = 0.006;
g = 9.8;
d = 1;

f=(-M*m*d^2+I*(m+M));

A= [0 1 0 0;
    0 0 (d^2*m^2*g)/f 0;
    0 0 0 1;
    0 0 (-d*M*g)/f 0];

B= [0;
    (I-d^2 * m)/f;
    0;
    (d*m)/f];

C= [1 0 0 0;  %misura posizione del carretto
    0 0 1 0]; %misura angolo del pendolo  

D= [0;
    0];

SYS=ss(A,B,C,D);
R=ctrb(A,B);
O=obsv(A,C);

rR=rank(R); %SYS Ragg
rO=rank(O); %SYS Oss

%risposta impulsiva catena aperta
figure(1)
impulse(SYS)
title('Risposta impulsiva in catena aperta')

%evoluzione libera catena aperta
x0=[0;0;0.1;0];
figure(2)
[y,t]=initial(SYS,x0,0:0.01:10);
plot(t,y(:,1),t,y(:,2))
title('Evoluzione libera in catena aperta')
legend('X carretto', '\theta pendolo')

%Controllore e Osservatore
K=place(A,B,[-2 -2.1 -2.3 -2.4]);
G=place(A',C',[-1 -2 -3 -4]);
G=G';

%Sistema catena chiusa
Ac=[A-B*K -B*K; zeros(4) A-G*C];
Bc=[B; zeros(4,1)];
Cc=[C zeros(2,4)];
Dc=[0;0];
SYS_cc=ss(Ac,Bc,Cc,Dc)

%Risposta impulsiva sistema in catena chiusa
figure(3)
impulse(SYS_cc)
title('Risposta impulsiva in catena chiusa')

%Evoluzione libera sistema in catena chiusa
x0=[0;0;0.1;0;0.2;0.3;0.01;0.01];
[y,t]=initial(SYS_cc,x0,0:0.01:10);
figure(4)
plot(t,y(:,1),t,y(:,2))
legend('X carretto', '\theta pendolo')
title('Evoluzione libera in catena chiusa')

%Animazione sistema
for i=1:2:1001
    figure(5)
    plot(y(i,1),0,'sb','MarkerSize',40)
    hold on
    plot([y(i,1) y(i,1)+d*sin(y(i,2))],[0 d*cos(y(i,2))],'-r')
    hold off
    xlim([-2 2])
    ylim([-2 2])
    drawnow
end
