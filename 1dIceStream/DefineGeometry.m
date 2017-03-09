
function [UserVar,s,b,S,B,alpha]=DefineGeometry(UserVar,CtrlVar,MUA,time,FTBD)


% Defines model geometry

x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);
alpha=0.;

gamma=0.01;
S=x*0 ; 
B0=-850;
B=B0-gamma*x ;
b=B;
s=b+1000;


end
