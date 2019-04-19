function  [UserVar,AGlen,n]=DefineAGlenDistribution(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)

n=3 ;


AGlen=AGlenVersusTemp(-10);


if CtrlVar.AGlenisElementBased
    AGlen=AGlen+zeros(MUA.Nele,1);
else
    AGlen=AGlen+zeros(MUA.Nnodes,1);
end

if CtrlVar.doDiagnostic
    
    switch lower(UserVar.RunType)
        
        case 'iceshelf'
            
            
            x=MUA.coordinates(:,1) ;
            y=MUA.coordinates(:,2);
            
            if CtrlVar.AGlenisElementBased
                x=mean(reshape(x(MUA.connectivity,1),MUA.Nele,MUA.nod),2);
                y=mean(reshape(y(MUA.connectivity,1),MUA.Nele,MUA.nod),2);
            end
            
            sx=10e3 ; sy=10e3;
            AGlen=AGlen.*(1+100*exp(-(x.*x/sx^2+y.*y./sy^2)));
            
        case 'icestream'
            
    end
end
















end

