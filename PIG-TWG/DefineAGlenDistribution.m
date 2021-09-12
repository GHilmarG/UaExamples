function [UserVar,AGlen,n]=DefineAGlenDistribution(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)


persistent FA


if ~UserVar.AGlen.ReadFromFile
    
    
    AGlen=AGlenVersusTemp(-10);
    n=3;
    
else
    
    if isempty(FA)
        
        if isfile(UserVar.AFile)
            
            fprintf('DefineSlipperyDistribution: loading file: %-s ',UserVar.AFile)
            load(UserVar.AFile,'FA')
            fprintf(' done \n')
            
        else
            
            load('AGlen-Estimate.mat','AGlen','xA','yA')
            FA=scatteredInterpolant(xA,yA,AGlen);
            save(UserVar.AFile,'FA')
            
        end
        
    end
    
    AGlen=FA(MUA.coordinates(:,1),MUA.coordinates(:,2));
    % make sure that interpolation/extrapolation does not violate parameter value constraints
    AGlen=kk_proj(AGlen,CtrlVar.AGlenmax,CtrlVar.AGlenmin) ;
    n=3;
    
end

