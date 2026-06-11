
function  [UserVar,C,m,q,muk]=DefineSlipperyDistribution(UserVar,CtrlVar,MUA,F)
    
    
    %%
    %
    % [UserVar,C,m,q,muk]=DefineSlipperyDistribution(UserVar,CtrlVar,MUA,F)
    %
    % [UserVar,C,m,q,muk]=DefineSlipperyDistribution(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)
    %
    %
    % Defines sliding-law parameters.
    %
    % The sliding law used is determined by the value of 
    %
    %   CtrlVar.SlidingLaw
    %
    % which is defined in 
    %
    %   DefineInitialInputs.m
    %
    % See description in Ua2D_DefaultParameters.m for further details and the
    % UaCompendium.pdf.
    %
    %%


    m=1;

    if CtrlVar.FlowApproximation=="SSHEET" 
        C0=0;
    else
        % v=100; tau=10 ; v=C tau^m ; C=v/tau^m ;
        C0=10;
    end

    C=C0+zeros(MUA.Nnodes,1);


    q=1 ;      % only needed for Budd sliding law
    muk=0.5 ;  % required for Coulomb friction type sliding law as well as Budd, minCW (Tsai), rCW  (Umbi) and rpCW (Cornford).


end
