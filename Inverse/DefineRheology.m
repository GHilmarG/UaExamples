function [AGlen,n,C,m,rho,rhow,g]=DefineRheology(Experiment,coordinates,connectivity,s,b,h,S,B,Itime,time,CtrlVar)  
    
    % units: kPa, m , a
    
    rho=900+zeros(length(coordinates),1) ; rhow=1030; g=9.81/1000; 
    
    % PIGnm  PIGmn
    %m=1 ; C=100/20+zeros(Nnodes,1);
    %n=1 ; AGlen=1e-5;
    
    [UserVar,C,m]=DefineSlipperyDistribution(Experiment,coordinates,connectivity,s,b,h,S,B,rho,rhow,Itime,time,CtrlVar);
    [UserVar,AGlen,n]=DefineAGlenDistribution(Experiment,coordinates,connectivity,s,b,h,S,B,rho,rhow,Itime,time,CtrlVar);
    
		

    
    
   
end
