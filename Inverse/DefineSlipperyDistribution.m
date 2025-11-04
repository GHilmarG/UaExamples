function [UserVar,C,m,q,muk,V0]=DefineSlipperyDistribution(UserVar,CtrlVar,MUA,F)


%m=3 ;  C=1/20^m+zeros(Nnodes,1); % m=3 , 1 m/a and basal shear stress of 20 kPa
m=UserVar.m ;
q=1;
muk=0.5 ; 
V0=UserVar.V0; 


C=zeros(MUA.Nnodes,1)+UserVar.C0 ;




%C=C.*(1+10*Hi(y,x,0,0,1e4,1e4,1));

if CtrlVar.doDiagnostic
    
    switch lower(UserVar.RunType)
        
        case 'icestream'
       
            
            
            sx=10e3 ; sy=10e3;
            C=C.*(1+100*exp(-(F.x.*F.x/sx^2+F.y.*F.y./sy^2)));
            C=C.*(1+0.1*exp(-(F.x.*F.x/sx^2+F.y.*F.y./sy^2)));
            
        case 'iceshelf'
            
    end
end


end