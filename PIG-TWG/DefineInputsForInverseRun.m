function [UserVar,InvStartValues,Priors,Meas,BCsAdjoint,RunInfo]=...
    DefineInputsForInverseRun(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,Priors,Meas,BCsAdjoint,RunInfo)


persistent FuMeas FvMeas FerrMeas


%% get measurments and define error covariance matrices
if isempty(FuMeas)
    
    fprintf('Loading interpolants for surface velocity data: %-s ',UserVar.SurfaceVelocityInterpolant)
    load(UserVar.SurfaceVelocityInterpolant,'FuMeas','FvMeas','FerrMeas')
    fprintf(' done.\n')
end

Meas.us=double(FuMeas(MUA.coordinates(:,1),MUA.coordinates(:,2)));
Meas.vs=double(FvMeas(MUA.coordinates(:,1),MUA.coordinates(:,2)));
Err=double(FerrMeas(MUA.coordinates(:,1),MUA.coordinates(:,2)));

MissingData=isnan(Meas.us) | isnan(Meas.vs) | isnan(Err) | (Err==0);
Meas.us(MissingData)=0 ;  Meas.vs(MissingData)=0 ; Err(MissingData)=1e10; 


usError=Err ; vsError=Err ; 
Meas.usCov=sparse(1:MUA.Nnodes,1:MUA.Nnodes,usError.^2,MUA.Nnodes,MUA.Nnodes);
Meas.vsCov=sparse(1:MUA.Nnodes,1:MUA.Nnodes,vsError.^2,MUA.Nnodes,MUA.Nnodes);



%% Define Priors

Priors.AGlen=AGlenVersusTemp(-10);
Priors.n=F.n; 


switch CtrlVar.SlidingLaw
    
    case {"Weertman","Tsai","Cornford","Umbi"}
        
        % u=C tau^m
        
        tau=100 ; % units meters, year , kPa
        MeasuredSpeed=sqrt(Meas.us.*Meas.us+Meas.vs.*Meas.vs);
        Priors.m=F.m;
        C0=(MeasuredSpeed+1)./(tau.^Priors.m);
        Priors.C=C0;
        
        
    case {"Budd","W-N0"}

        hf=F.rhow.*(F.S-F.B)./F.rho;
        hf(hf<eps)=0;
        Dh=(F.s-F.b)-hf; Dh(Dh<eps)=0;
        N=F.rho.*F.g.*Dh;
        
        MeasuredSpeed=sqrt(Meas.us.*Meas.us+Meas.vs.*Meas.vs);
        tau=100+zeros(MUA.Nnodes,1) ; 
        C0=N.^F.q.*MeasuredSpeed./(tau.^F.m);
        Priors.C=C0 ; 
        Priors.m=F.m ; 
        
    otherwise
        
        error('asfd')
end


%% Define Start Values 
% This is only used at the very start of the inversion. (In an inverse restart run the initial value is always the last values from
% previous run.)
InvStartValues.C=Priors.C ;
InvStartValues.m=F.m ;
InvStartValues.q=F.q;
InvStartValues.muk=F.muk ;
InvStartValues.AGlen=Priors.AGlen;
InvStartValues.n=F.n ;




end
