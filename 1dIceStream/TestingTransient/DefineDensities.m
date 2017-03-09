function [UserVar,rho,rhow,g]=DefineDensities(Experiment,coordinates,connectivity,s,b,h,S,B,Itime,time,CtrlVar)
    

% units: kPa, m , a

Nnodes=size(coordinates,1);
rho=900+zeros(Nnodes,1); rhow=1000; g=9.81/1000; 


end