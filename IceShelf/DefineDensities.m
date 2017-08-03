function [UserVar,rho,rhow,g]=DefineDensities(UserVar,CtrlVar,MUA,time,s,b,h,S,B)
        
    % units: kPa, m , a
    
    x=MUA.coordinates(:,1);
    rho=900+x*0;rhow=1030; g=9.81/1000; 
        
    
end
