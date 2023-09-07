clc
clear all
close all


%Pendolo linearizzato range di lavoro 0°%13°, 0rad%0.23rad
g=9.81; %accelerazione gravitazionale [m/s^2]
theta=0.1; %angolo iniziale [rad]
d=1; %lunghezza asta [m], regolare il proporzionale in base all'asta
xc=0; %posizione iniziale carretto [m]
v_xc=0; %velocità iniziale carretto [m/s]
a_xc=0; %accelerazione iniziale carretto [m/s^2]
xp=theta*d; %posizione iniziale pendolo rispetto al carretto [m]
v_xp=0; %velocità iniziale pendolo rispetto al carretto [m/s]
a_xp=g*xp/abs(d); %accelerazione iniziale pendolo rispetto al carretto[m/s^2]
pos_p=[xp d*cos(xp/d)]; %coordinate x y del pendolo pendolo rispetto al carretto
h=0.025; %passo
kp=35;  %proporzionale 
ki=10; %integrativa
e=0; %errore
intgr=0; %memoria
rif=0; %posizione desiderata del pendolo rispetto al carretto


for t=0:h:300
   pos_p=[xp d*cos(xp/d)]; %aggiorno posizione
   
%    figure(1) %plot che vede l'asta dal punto di vista del carretto
%    plot([0 pos_p(1,1)], [0 pos_p(1,2)],'r-') %plot pendolo
%    xlim([-2*abs(d) 2*abs(d)]); %utili al plot
%    ylim([-2*abs(d) 2*abs(d)]); %utili al plot
%    title("Pendolo visto dal carretto");
  
   figure(2) %plot che vede il carretto dal punto di vista di un osservatore esterno
   plot(xc,0,'sb','MarkerSize',50) %plot carretto
   hold on
   plot([xc xc+xp],[0 d*cos(xp/d)],'r-'); %plot pendolo
   hold off
   title("Carretto visto dall'esterno");
   xlim([-3*d 3*d]); %NB: i disturbi possono portare il carretto ad uscire dai limiti del plot
   ylim([-2*d 2*d]);
   drawnow %utili al plot
   
   e=rif-xp; %calcolo errore posizione del pendolo rispetto al CM del carretto
   intgr=intgr+e*h; %memorizzazione 
   
   a_xc=kp*e - ki*intgr; %accelerazione del carretto
   a_xp=g*xp/abs(d)+ a_xc; %aggiorno accelerazione del pendolo rispetto al carretto
   
   v_xc=v_xc-a_xc*h; %velocità del carretto
   v_xp=v_xp+a_xp*h; %aggiorno velocità del pendolo rispetto al carretto
   
   xc=xc+v_xc*h; %posizione del carretto   
   xp=xp+v_xp*h; %aggiorno coordinata x del pendolo rispetto al carretto
   
   if abs(v_xp)<= 0.03 && abs(e)<=0.5 %resetto memoria
       intgr=0; %serve per impedire che il pendolo cada
   end
   
   if mod(t,10)==0 %introduco in disturbo randomico
       if rand()>0.5  
            v_xp=v_xp+rand()/10;
       else
            v_xp=v_xp-rand()/10;
       end  
       print="Introduco un disturbo..."
   end
end