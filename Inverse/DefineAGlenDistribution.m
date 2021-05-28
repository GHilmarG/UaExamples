function  [UserVar,AGlen,n]=DefineAGlenDistribution(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)

n=3 ;


AGlen=AGlenVersusTemp(-10);



AGlen=AGlen+zeros(MUA.Nnodes,1);


if CtrlVar.doDiagnostic
    
    switch lower(UserVar.RunType)
        
        case 'iceshelf'
            
            
            x=MUA.coordinates(:,1) ;
            y=MUA.coordinates(:,2);
            
            
            sx=10e3 ; sy=10e3;
            AGlen=AGlen.*(1+100*exp(-(x.*x/sx^2+y.*y./sy^2)));
            
        case 'icestream'
            
            %  no modification
            
    end
end


end

