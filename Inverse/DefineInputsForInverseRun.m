





function [UserVar,InvStartValues,Priors,Meas,BCsAdjoint,RunInfo]=DefineInputsForInverseRun(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,Priors,Meas,BCsAdjoint,RunInfo)



x=MUA.coordinates(:,1) ; y=MUA.coordinates(:,2);


%

%% Define boundary conditions of adjoint problem
% Generally there is nothing that needs to be done here If BCsAdjoint is not
% modified, then Ua will define the BCs of the adjoint problem based on the BCs
% of the forward problem. 
%BCsAdjoint=BCs; % periodic BCs of forward model -> periodic BCs of adjoint model



%%  Priors



Priors.C=zeros(MUA.Nnodes,1)+UserVar.C0; 
Priors.m=UserVar.m ;
Priors.AGlen=AGlenVersusTemp(-10)+zeros(MUA.Nnodes,1);
Priors.n=UserVar.n  ;
Priors.q=1 ;
Priors.muk=0.5 ;
Priors.V0=UserVar.V0 ;
%% Start values
% 
wavelength=(max(x)-min(x))/4 ; 
Ampl=0.1; 
InvStartValues.C=Priors.C.*(1+Ampl.*sin(2*pi*x/wavelength)) ;
InvStartValues.m=Priors.m;
InvStartValues.AGlen=Priors.AGlen.*(1+Ampl.*sin(2*pi*x/wavelength)) ;
InvStartValues.n=Priors.n;
InvStartValues.q=Priors.q ; 
InvStartValues.muk=Priors.muk ;
InvStartValues.V0=Priors.V0 ;


%% Define measurements and measurement errors

fprintf(' Creating synthetic data \n')

CtrlVar.doDiagnostic=1;
[UserVar,F.C,F.m,F.q,F.muk,F.V0]=DefineSlipperyDistribution(UserVar,CtrlVar,MUA,CtrlVar.time,F.s,F.b,F.s-F.b,F.S,F.B,F.rho,F.rhow,GF);
[UserVar,F.AGlen,F.n]=DefineAGlenDistribution(UserVar,CtrlVar,MUA,CtrlVar.time,F.s,F.b,F.s-F.b,F.S,F.B,F.rho,F.rhow,GF);

[F.C,F.m,F.q,F.muk,F.V0]=TestSlipperinessInputValues(CtrlVar,MUA,F.C,F.m,F.q,F.muk,F.V0);

[UserVar,RunInfo,F,l,Kuv,Ruv,Lubvb]= uv(UserVar,RunInfo,CtrlVar,MUA,BCs,F,l);

Priors.TrueC=F.C;
Priors.TrueAGlen=F.AGlen;



%[UserVar,ub,vb,ud,vd,l,Kuv,Ruv,RunInfo,ubvbL]=uv(UserVar,CtrlVar,MUA,BCs,s,b,h,S,B,ub,vb,ud,vd,l,AGlen,C,n,m,alpha,rho,rhow,g,GF);
Meas.us=F.ub ;
Meas.vs=F.vb;


VelScale=mean(F.ub);
usError=1e-3*VelScale; 
vsError=1e-3*VelScale  ; 


Meas.usCov=sparse(1:MUA.Nnodes,1:MUA.Nnodes,usError.^2,MUA.Nnodes,MUA.Nnodes);
Meas.vsCov=sparse(1:MUA.Nnodes,1:MUA.Nnodes,vsError.^2,MUA.Nnodes,MUA.Nnodes);


% if add errors

Meas.us=Meas.us+UserVar.AddDataErrors*usError.*randn(MUA.Nnodes,1);
Meas.vs=Meas.vs+UserVar.AddDataErrors*vsError.*randn(MUA.Nnodes,1);





%%
FindOrCreateFigure('Synthetic velocity measurements') ; 
QuiverColorGHG(MUA.coordinates(:,1),MUA.coordinates(:,2),Meas.us,Meas.vs) ;
title('Synthetic velocity measurements') 

FindOrCreateFigure('True C') ; PlotMeshScalarVariable(CtrlVar,MUA,Priors.TrueC) ; 
FindOrCreateFigure('True A') ; PlotMeshScalarVariable(CtrlVar,MUA,Priors.TrueAGlen) ; 

FindOrCreateFigure('Prior C') ; PlotMeshScalarVariable(CtrlVar,MUA,Priors.C) ; 
FindOrCreateFigure('Prior A') ; PlotMeshScalarVariable(CtrlVar,MUA,Priors.AGlen) ; 

FindOrCreateFigure('Start C') ; PlotMeshScalarVariable(CtrlVar,MUA,InvStartValues.C) ; 
FindOrCreateFigure('Start A') ; PlotMeshScalarVariable(CtrlVar,MUA,InvStartValues.AGlen) ; 

F.C=InvStartValues.C; 
F.AGlen=InvStartValues.AGlen; 
[UserVar,RunInfo,F,l,Kuv,Ruv,Lubvb]= uv(UserVar,RunInfo,CtrlVar,MUA,BCs,F,l);

FindOrCreateFigure('Calculated velocites based on starting A and C values') ;
QuiverColorGHG(MUA.coordinates(:,1),MUA.coordinates(:,2),F.ub,F.vb) ;
title('Calculated velocities based on initial A and C fields') 








end
