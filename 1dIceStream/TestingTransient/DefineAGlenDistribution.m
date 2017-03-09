function [UserVar,AGlen,n]=DefineAGlenDistribution(Experiment,coordinates,connectivity,s,b,h,S,B,rho,rhow,Itime,time,CtrlVar)
    

% units: kPa, m , a

T=-15;
AGlen=AGlenVersusTemp(T);
n=3; 

% rho=900 ; g=9.81/1000; alpha=0.001 ; n=3 ; h=1000;

% ud=0.1 ;
% tau=rho*g*h*sin(alpha);
% 
% AGlen=ud/(2*tau^n*h/(n+1));

Nnodes=size(coordinates,1);
AGlen=AGlen+zeros(Nnodes,1) ;




end