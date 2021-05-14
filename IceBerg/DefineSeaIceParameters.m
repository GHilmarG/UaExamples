function [UserVar,uo,vo,Co,mo,ua,va,Ca,ma]=DefineSeaIceParameters(UserVar,CtrlVar,MUA,BCs,GF,ub,vb,ud,vd,uo,vo,ua,va,s,b,h,S,B,rho,rhow,AGlen,n,C,m)







uo=zeros(MUA.Nnodes,1);
vo=zeros(MUA.Nnodes,1);
ua=zeros(MUA.Nnodes,1);
va=zeros(MUA.Nnodes,1);


mo=2; Co=1e+10; 
ma=1; Ca=1e+10;



end