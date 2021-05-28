
function [UserVar,AGlen,n]=DefineAGlenDistribution(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)

%%
% Units:
%
% distance in meters
% time in years
% stresses in kPa 
%
%   
%%

n=3;


A=6.338e-25 ;
AGlen=A*1e9*365.2422*24*60*60+zeros(MUA.Nnodes,1);


end

