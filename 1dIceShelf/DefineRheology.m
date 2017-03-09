function  [AGlen,n,C,m,rho,rhow,g]=DefineRheology(Experiment,coordinates,connectivity,s,b,h,S,B,Itime,time,CtrlVar)
        
    % units: kPa, m , a
    
    x=coordinates(:,1);
    rho=900+x*0;rhow=1030; g=9.81/1000; 

    
    [UserVar,C,m]=DefineSlipperyDistribution(Experiment,coordinates,connectivity,s,b,h,S,B,rho,rhow,Itime,time,CtrlVar);
    [UserVar,AGlen,n]=DefineAGlenDistribution(Experiment,coordinates,connectivity,s,b,h,S,B,rho,rhow,Itime,time,CtrlVar);
        
    
end
