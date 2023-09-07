clear all
close all
clc

M = 0.5;
m = 0.2;
I = 0.006;
g = 9.8;
d = 0.3;

f=(-M*m*d^2+I*(m+M));

A= [0 1 0 0;
    0 0 (d^2*m^2*g)/f 0;
    0 0 0 1;
    0 0 (-d*M*g)/f 0]

B= [0;
    (I-d^2 * m)/f;
    0;
    (d*m)/f]

C= [1 0 0 0;
    0 0 1 0]

D= [0;
    0];

SYS=ss(A,B,C,D)
impulse(SYS)