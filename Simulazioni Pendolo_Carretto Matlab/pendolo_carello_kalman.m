clear all
clc
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
ki=2; %integrativa
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
A = 1;
B = 1;
C = 1;
D = 1;
Q = 0.1;
R = 0.0288;
K = 0;
P_1 = 0;
P = 0;
P_pre = 0;
xs = 0; %posizione del pendolo stimata dal FdK
xs_pre = 0;
for t=0:h:50
  
   %VISUALIZZAZIONE GRAFICA DEL PENDOLO CON CARRETTO
   figure(2) %plot che vede il carretto dal punto di vista di un osservatore esterno
   plot(xc,0,'sb','MarkerSize',50) %plot carretto
   hold on
   plot([xc xc+xp],[0 d*cos(xp/d)],'r-'); %plot pendolo
   hold off
   title("Carretto con pendolo visto dall'esterno");
   xlim([-2*d 2*d]); 
   ylim([-2*d 2*d]);
   drawnow 
   
   %SIMULAZIONE DI SENSORE RUMOROSO
   y = xp;
   w = (-1 + 2*rand())/100;
   y = y + w;

   
   %IMPLEMENTAZIONE DELLE EQUAZIONI DEL FILTRO DI KALMAN
   P_1=A*P_pre*A + B*Q*B;
   K = P_1*C/(C*P_1*C + D*R*D); 
   xs = A*xs_pre + K*(y-C*A*xs_pre) ;
   P = (1 - K)*P_1;
   
   P_pre = P;
   xs_pre = xs;
			
   e=rif-xs; %calcolo errore posizione del pendolo rispetto al CM del carretto
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
   
   if abs(v_xp)<= 0.5 && abs(e)<=0.5 %resetto memoria NB:diminuire i parametri se si spegne il derivatore
       intgr=0; %serve per impedire che il pendolo cada
   end
   
   if mod(t,4)==0 %introduco in disturbo randomico
       if l==true  
            v_xp=v_xp+rand()/25;
            l=false;
       else
            v_xp=v_xp-rand()/25;
            l=true;
       end  
       print="Introduco un disturbo..."
   end
end
