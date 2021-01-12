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
Priors.n=3; 

% Come up with a rough guess for C based on measured velocities and typical basal stress
SpeedMeasured=vecnorm([Meas.us Meas.vs],2,2) ; 
SpeedMin=10 ; 
SpeedMeasured(SpeedMeasured<SpeedMin)=SpeedMin ; 
tau=50 ;  tauMin=5 ; 
CGuess=SpeedMeasured./tau.^F.m ;
Cmax=max(SpeedMeasured.*F.GF.node./tauMin.^F.m) ;
CGuess(CGuess>Cmax)=Cmax ; 

Priors.C=CGuess;
Priors.rho=F.rho;
Priors.rhow=F.rhow;

%% Define Start Values for the Inversion.
% This is only used at the very start of the inversion. (In an inverse restart run the initial value is always the last values from
% previous run.)
InvStartValues.C=Priors.C ;
InvStartValues.m=F.m ;
InvStartValues.q=F.q;
InvStartValues.muk=F.muk ;
InvStartValues.AGlen=Priors.AGlen;
InvStartValues.n=F.n ;




end
