syms m M d q dq ddq xp dxp ddxp x dx ddx V0 H0 T g Ip Ir N w dw r tau

eq1 = -H0==m*(ddx+ddq*d)
eq2 = -m*g-V0==m*d
eq3 = d*m*g*q - tau==Ip*ddq
eq4 = H0-T==M*ddx
eq5 = V0-M*g+N==0
eq6 = tau + T*r == Ir*dw
eq7 = dx==w*r
eq8 = ddx==dw*r

solve(eq1,eq2,eq3,eq4,eq5,eq6,eq7,eq8,ddx,ddq,H0,V0,T,dw,dx,N)