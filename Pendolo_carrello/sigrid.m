function [] = sigrid(sig)
 
narginchk(1,1);
hold on
%Plot sigma line
limits = axis;
mx=limits(1,4);
mn=limits(1,3);
stz=abs(mx)+abs(mn);
st=stz/50;
im=mn:st:mx;
lim=length(im);
for i=1:lim
    re(i)=-sig;
end
re(:);
plot(re,im,'k--')
hold off

return
 end