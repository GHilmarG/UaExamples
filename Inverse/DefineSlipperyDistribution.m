function [UserVar,C,m]=DefineSlipperyDistribution(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)


%m=3 ;  C=1/20^m+zeros(Nnodes,1); % m=3 , 1 m/a and basal shear stress of 20 kPa
m=3 ;


C=zeros(MUA.Nnodes,1)+1/20^m;

%C=C.*(1+10*Hi(y,x,0,0,1e4,1e4,1));

if CtrlVar.doDiagnostic
    
    switch lower(UserVar.RunType)
        
        case 'icestream'
            
            
            x=MUA.coordinates(:,1) ;
            y=MUA.coordinates(:,2);
            
            
            
            sx=10e3 ; sy=10e3;
            C=C.*(1+100*exp(-(x.*x/sx^2+y.*y./sy^2)));
            
        case 'iceshelf'
            
    end
end


end