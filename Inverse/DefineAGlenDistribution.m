function  [UserVar,AGlen,n]=DefineAGlenDistribution(UserVar,CtrlVar,MUA,F)

n=3 ;


AGlen=AGlenVersusTemp(-10);



AGlen=AGlen+zeros(MUA.Nnodes,1);


if CtrlVar.doDiagnostic
    
    switch lower(UserVar.RunType)
        
        case 'iceshelf'
            
       
            
            sx=10e3 ; sy=10e3;
            AGlen=AGlen.*(1+100*exp(-(F.x.*F.x/sx^2+F.y.*F.y./sy^2)));
            
        case 'icestream'
            
            %  no modification
            
    end
end


end

