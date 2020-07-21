
function [UserVar,AGlen,n]=DefineAGlenDistribution(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)
    
    n=3;
    
    
    if contains(UserVar.RunType,"-MismipPlus-")
        A=6.338e-25;
        AGlen=A*1e9*365.2422*24*60*60+zeros(MUA.Nnodes,1);
    else
        AGlen=AGlenVersusTemp(-10);
        
    end
    
end

