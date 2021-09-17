
function [UserVar,as,ab,dasdh,dabdh]=DefineMassBalance(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)


as=h;
dasdh=zeros(MUA.Nnodes,1)+1;

ab=s*0;
dabdh=zeros(MUA.Nnodes,1);

%  as = as_0 + das/dh  dh


%fprintf('time=%f \t as=%f \t h=%f \n ',time,mean(as),mean(h))

% if as=h and h=h0 at t=t0=0 and velocities are  zero, then:
% dh/dt=a=h
% h=h0 exp(t)  

end

