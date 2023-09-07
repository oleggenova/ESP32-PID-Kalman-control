clc
clear all
close all

syms N H R theta alpha I F_ F m M d a_xc g real


eq1=H==m*a_xc+m*alpha*d
eq2=N-m*g==0
eq3=d*H-d*N*theta==I*alpha
eq4=F-H==M*a_xc


[N,H,alpha,a_xc]=solve(eq1,eq2,eq3,eq4,N,H,alpha,a_xc);
N=simplify(N)
H=simplify(H)
alpha=simplify(alpha)
a_xc=simplify(a_xc)

