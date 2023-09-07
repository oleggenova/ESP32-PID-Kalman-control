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
K=place(A,B,[-15 -15.1 -15.2 -15.3]);
G=place(A',C',[-7 -6 -5 -4]);
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
x0=[0;0;0.1;0;0;0;0.1;0];
[y,t]=initial(SYS_cc,x0,0:0.01:10);
figure(4)
plot(t,y(:,1),t,y(:,2))
legend('X carretto', '\theta pendolo')
title('Evoluzione libera in catena chiusa')

%Animazione sistema
for i=1:1:1001
    figure(5)
    plot(y(i,1),0,'o','MarkerSize',20)
    hold on
    plot([y(i,1) y(i,1)+d*sin(y(i,2))],[0 d*cos(y(i,2))],'-r')
    hold off
    xlim([-2 2])
    ylim([-0.2 0.2])
    drawnow
end

SYS_ARDUINO=c2d(SYS,0.017,'zoh');
Vd=10^-2*eye(4);
Vn=10^-4*eye(2);
[Kf,P,E]=lqe(SYS_ARDUINO.A,Vd,SYS_ARDUINO.C,Vd,Vn); %guadagno del filtro

