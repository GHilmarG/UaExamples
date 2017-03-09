function [UserVar,C,m]=DefineSlipperyDistribution(Experiment,coordinates,connectivity,s,b,h,S,B,rho,rhow,Itime,time,CtrlVar)
    
    
    % units: kPa, m , a
    
    rho=900 ; g=9.81/1000; alpha=0.001; m=1  ; h=1000;
    
    SlipRatio=100; ud=0.1 ;
    tau=rho*g*h*sin(alpha);
    
    
    ub=SlipRatio*ud;
    C=ub/tau^m;
    
    Nnodes=size(coordinates,1);
    C=C+zeros(Nnodes,1);
    
end
