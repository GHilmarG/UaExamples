function [UserVar,C,m]=DefineSlipperyDistribution(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)


%m=3 ;  C=1/20^m+zeros(Nnodes,1); % m=3 , 1 m/a and basal shear stress of 20 kPa
m=3 ;

if CtrlVar.CisElementBased
    C=zeros(MUA.Nele,1)+1/20^m;
else
    C=zeros(MUA.Nnodes,1)+1/20^m;
end

%C=C.*(1+10*Hi(y,x,0,0,1e4,1e4,1));

if CtrlVar.doDiagnostic
    
    switch lower(UserVar.RunType)
        
        case 'icestream'
            
            
            x=MUA.coordinates(:,1) ;
            y=MUA.coordinates(:,2);
            
            if CtrlVar.CisElementBased
                x=mean(reshape(x(MUA.connectivity,1),MUA.Nele,MUA.nod),2);
                y=mean(reshape(y(MUA.connectivity,1),MUA.Nele,MUA.nod),2);
            end
            
            sx=10e3 ; sy=10e3;
            C=C.*(1+100*exp(-(x.*x/sx^2+y.*y./sy^2)));
            
        case 'iceshelf'
            
    end
end





end