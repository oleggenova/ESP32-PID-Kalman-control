clc
clear all
close all


%Pendolo linearizzato range di lavoro 0°%13°, 0rad%0.23rad
g=9.81; %accelerazione gravitazionale [m/s^2]
theta=0.10; %angolo iniziale [rad]
d=2; %lunghezza asta [m], regolare il proporzionale in base all'asta
x=theta*d; %posizione iniziale [m]
v_x=0; %velocità iniziale [m/s]
a_x=g*x/abs(d); %accelerazione iniziale [m/s^2]
pos=[x d*cos(x/d)]; %coordinate x y del pendolo
h=0.025; %passo
kp=15;  %proporzionale 
ki=2; %integrativa
e=0; %errore
intgr=0; %memoria
rif=0; %posizione desiderata


for t=0:h:300
   pos=[x d*cos(x/d)]; %aggiorno posizione
   
   plot([0 pos(1,1)], [0 pos(1,2)],'r-') %plot
   xlim([-2*abs(d) 2*abs(d)]); %utili al plot
   ylim([-2*abs(d) 2*abs(d)]); %utili al plot
   drawnow %utili al plot
   
   e=rif-x; %calcolo errore posizione
   intgr=intgr+e*h; %memorizzazione
   a_x=g*x/abs(d)+ kp*e - ki*intgr; %controllo e aggiorno l'accelerazione
   v_x=v_x+a_x*h; %aggiorno velocità
   x=x+v_x*h; %aggiorno coordinata x 
   
   if abs(v_x)<= 0.018 && abs(e)<=0.1 %resetto memoria
       intgr=0; %serve per impedire che il pendolo cada
   end
   
   if mod(t,10)==0 %introduco in disturbo randomico
         v_x=v_x+abs(rand-0.8);
         print="Introduco un disturbo..."
   end   
end