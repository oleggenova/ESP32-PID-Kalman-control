clc
clear all
close all

syms theta omega alpha real

theta=pi+0.5; %angolo iniziale
alpha=0;
omega=0;
d=2;
pos=[d*sin(theta) d*cos(theta)];
g=9.81;
h=0.025;

for t=0:h:100
   pos=[d*sin(theta) d*cos(theta)];
   plot([0 pos(1,1)], [0 pos(1,2)],'r-')
   xlim([-2*d 2*d]);
   ylim([-2*d 2*d]);
   drawnow
   alpha=g*sin(theta)/d;
   omega=omega+alpha*h;
   theta=theta+omega*h;
end

