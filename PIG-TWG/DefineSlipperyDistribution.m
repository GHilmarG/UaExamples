function [UserVar,C,m]=DefineSlipperyDistribution(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)

persistent FC

if ~UserVar.Slipperiness.ReadFromFile
    
    
    m=3;
    ub=10 ; tau=80 ; % units meters, year , kPa
    C0=ub/tau^m;
    C=C0;
    
    
else
    
    
    if isempty(FC)
        
        if isfile(UserVar.CFile)
            fprintf('DefineSlipperyDistribution: loading file: %-s ',UserVar.CFile)
            load(UserVar.CFile,'FC')
            fprintf(' done \n')
        else
            % create a FC file
            load('C-Estimate.mat','C','xC','yC')
            FC=scatteredInterpolant(xC,yC,C); 
            save(UserVar.CFile,'FC')
        end
    end
    
    C=FC(MUA.coordinates(:,1),MUA.coordinates(:,2));
    m=3;
    
    
end