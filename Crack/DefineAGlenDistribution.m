

function [UserVar,AGlen,n]=DefineAGlenDistribution(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)

%%
%  User input m-file to define A and n in the Glenn-Steinemann flow law
% [UserVar,AGlen,n]=DefineAGlenDistribution(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)
%
% Usually A is defined on the nodes, but sometimes in an inverse run A might be
% defined as an element variable. The user makes this decision by setting
% CtrlVar.AGlenisElementBased to true or false in Ua2D_InitialUserInput

n=3 ; AGlen=AGlenVersusTemp(-25);
 
n=1; eps=0.01 ; tau=100; AGlen=eps/tau ; %     % eps=A*tau^n ;  eps=0.01 ; tau=100; 

end

