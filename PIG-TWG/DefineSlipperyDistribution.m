function [UserVar,C,m,q,muk]=DefineSlipperyDistribution(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)

persistent FC


q=3 ; 
muk=0.5 ; 
m=3; 

if ~UserVar.Slipperiness.ReadFromFile
    
    switch CtrlVar.SlidingLaw
      % Rough estimates for reasonable order of magnitue for C
    
    case {"W","Weertman","Tsai","Cornford","Umbi"}
        
        % u=C tau^m
        
        tau=100 ; % units meters, year , kPa
        Speed=100;
        C0=Speed./(tau.^m);
        C=C0;
        
    case {"Budd","W-N0"}
        
        % u=C tau^m/N^q
        % N=rho g (h-hf)
        % hf=rhow (S-B)/rho
        % rhow=1030 ; rho=900 ; 
        hf=rhow.*(S-B)./rho;
        hf(hf<eps)=0;
        Dh=h-hf; Dh(Dh<eps)=0;
        g=9.81/1000;
        N=rho.*g.*Dh;

        
        Speed=100;
        tau=100+zeros(MUA.Nnodes,1) ; 
        C0=N.^q.*Speed./(tau.^m);
        C=C0 ; 
    
        otherwise
            
            error(' case not found')
        
    end
        
    
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