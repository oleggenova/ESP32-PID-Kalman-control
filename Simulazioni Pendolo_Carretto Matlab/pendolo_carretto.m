clc
clear all
close all


%Pendolo linearizzato range di lavoro 0°%13°, 0rad%0.23rad
g=9.81; %accelerazione gravitazionale [m/s^2]
theta=0.15; %angolo iniziale [rad]
d=0.3; %lunghezza asta [m], regolare il proporzionale in base all'asta
xc=0; %posizione iniziale carretto [m]
v_xc=0; %velocità iniziale carretto [m/s]
a_xc=0; %accelerazione iniziale carretto [m/s^2]
xp=theta*d; %posizione iniziale pendolo rispetto al carretto [m]
v_xp=0; %velocità iniziale pendolo rispetto al carretto [m/s]
a_xp=g*xp/abs(d); %accelerazione iniziale pendolo rispetto al carretto[m/s^2]
pos_p=[xp d*cos(xp/d)]; %coordinate x y del pendolo pendolo rispetto al carretto
h=0.025; %passo
kp=20;  %proporzionale 
ki=5; %integrativa
kd=1; %derivativa
e=0; %errore
p_e=0; %errore precedente 
intgr=0; %memoria
rif=0; %posizione desiderata del pendolo rispetto al carretto [m]
M=0.5; %massa carrello [kg]
m=0.2; %massa pendolo [kg]
I=0.006; %momento d'inerzia pendolo [Kgm^2]
F=0; %forzamento impresso al carrello per controllare il pendolo [N]
l=true;

for t=0:h:50
%    pos_p=[xp d*cos(xp/d)]; %aggiorno posizione pendolo rispetto al carretto
%    figure(1) %plot che vede l'asta dal punto di vista del carretto
%    plot([0 pos_p(1,1)], [0 pos_p(1,2)],'r-') %plot pendolo
%    xlim([-2*abs(d) 2*abs(d)]); %utili al plot
%    ylim([-2*abs(d) 2*abs(d)]); %utili al plot
%    title("Pendolo visto dal carretto");
  
   figure(2) %plot che vede il carretto dal punto di vista di un osservatore esterno
   plot(xc,0,'sb','MarkerSize',40) %plot carretto
   hold on
   plot([xc xc+xp],[0 d*cos(xp/d)],'r-'); %plot pendolo
   hold off
   title("Carretto con pendolo visto dall'esterno");
   xlim([-2*d 2*d]); %NB: i disturbi possono portare il carretto ad uscire dai limiti del plot
   ylim([-2*d 2*d]);
   drawnow %utili al plot
   
   e=rif-xp; %calcolo errore posizione del pendolo rispetto al CM del carretto
   intgr=intgr+e*h; %memorizzazione
   dervt=(e-p_e)/h; %predizione
   p_e=e; %aggiorno errore precedente
   
   F=(kp*e+ki*intgr+kd*dervt)*(-1);  %forzamento
   
   
   %VEDI MODELLO MATEMATICO PER CHIARIMENTI
   theta=xp/d;
   a_xc= (g*theta*d^2*m^2 + F*d^2*m + F*I)/(M*m*d^2 + M*I + m*I); %accelerazione del carretto
   a_xp= d*-(d*m*(M*g*theta - F + g*m*theta))/(- M*m*d^2 + M*I + m*I) - a_xc; %accelerazione del pendolo
   
   v_xc=v_xc+a_xc*h; %velocità del carretto
   v_xp=v_xp+a_xp*h; %velocità del pendolo
   
   xc=xc+v_xc*h; %posizione del carretto   
   xp=xp+v_xp*h; %posizione del pendolo 
   
%    if abs(v_xp)<= 0.5 && abs(e)<=0.5 %resetto memoria NB:diminuire i parametri se si spegne il derivatore
%        intgr=0; %serve per impedire che il pendolo cada
%    end
   
   if mod(t,4)==0 %introduco in disturbo randomico
       if l==true  
            v_xp=v_xp+rand()/15;
            l=false;
       else
            v_xp=v_xp-rand()/15;
            l=true;
       end  
       print="Introduco un disturbo..."
   end
end