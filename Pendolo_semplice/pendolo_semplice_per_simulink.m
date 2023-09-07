%modello in SS
%grandezze fisiche
M=0.5; %massa carrello
m=0.2;  %massa pendolo
b=0.1;  %attrito carrello-pavimento
l=0.3;  %lunghezza pendolo
i=0.006; %inerzia pendolo
g=9.8;

%modello come fdt
q=(M+m)*(i+m*l^2)-(m*l)^2;
num=[m*l/q 0];
den=[1 b*(i+m*l^2)/q -(M+m)*m*g*l/q -b*m*g*l/q];
pend=tf(num,den);

t=[0:0.001:1];
impulse(pend,t)
rlocus(pend)

%rete correttrice per luogo radici
contr=tf(1,[1 0]);
rlocus(contr*pend);
%sigrid(0.92) comando obsoleto

%aggiunta di poli e zeri
z1=3; z2=4; 
p1=0; %polo che compensa zero in origine
p2=60; %polo lontano

% rete correttrice migliorata
numc=conv([1 z2],[1 z1]);
denc=conv([1 p2],[1 p1]);
contr1=tf(numc,denc);
rlocus(contr1*pend)

%prelevo gain per la rete correttrice
[k,poles]=rlocfind(contr1*pend);
sys_cl=feedback(pend,contr1*k);
impulse(sys_cl)



