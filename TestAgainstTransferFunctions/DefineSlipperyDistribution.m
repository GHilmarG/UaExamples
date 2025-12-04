function [UserVar,C,m]=DefineSlipperyDistribution(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)


%m=3 ; C=0.0145300017528364 ; % m=3
%m=1 ; C=1.13263129082193    ; % m=1


rho=900 ; h=1000 ; alpha=0.05 ; g=9.81/1000 ; ub=1000; taud=rho*g*sin(alpha)*h ; m=3;

C0=ub/taud^m ;

x=MUA.coordinates(:,1); y=MUA.coordinates(:,2) ;
dc=UserVar.ampl_c*exp(-x.^2./UserVar.sigma_cx^2-y.^2./UserVar.sigma_cy^2); dc=dc-mean(dc(:)) ;

C=C0*(1+dc);

end
