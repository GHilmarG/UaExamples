function [UserVar,InvStartValues,Priors,Meas,BCsAdjoint,RunInfo]=DefineInputsForInverseRun(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,Priors,Meas,BCsAdjoint,RunInfo)



x=MUA.coordinates(:,1) ; y=MUA.coordinates(:,2);
Lx=max(x)-min(x); Ly=max(y)-min(y);

if CtrlVar.CisElementBased
    xC=mean(reshape(x(MUA.connectivity,1),MUA.Nele,MUA.nod),2);
    yC=mean(reshape(y(MUA.connectivity,1),MUA.Nele,MUA.nod),2);
else
    xC=x; yC=y;
end


if CtrlVar.AGlenisElementBased
    xA=mean(reshape(x(MUA.connectivity,1),MUA.Nele,MUA.nod),2);
    yA=mean(reshape(y(MUA.connectivity,1),MUA.Nele,MUA.nod),2);
else
    xA=x ; yA=y;
end
%

%% Define boundary conditions of adjoint problem
% Generally there is nothing that needs to be done here If BCsAdjoint is not
% modified, then Ua will define the BCs of the adjoint problem based on the BCs
% of the forward problem. 
%BCsAdjoint=BCs; % periodic BCs of forward model -> periodic BCs of adjoint model



%%  Covariance matrices of priors
% 
if CtrlVar.AGlenisElementBased
    CAGlen=sparse(1:MUA.Nele,1:MUA.Nele,1,MUA.Nele,MUA.Nele);
else
    CAGlen=sparse(1:MUA.Nnodes,1:MUA.Nnodes,1,MUA.Nnodes,MUA.Nnodes);
end

if strcmpi(CtrlVar.Inverse.Regularize.Field,'cov')
    Err=1e-2 ; Sigma=1e3 ; DistanceCutoff=10*Sigma;
    
    if CtrlVar.CisElementBased
        [CC]=SparseCovarianceDistanceMatrix(xC,yC,Err,Sigma,DistanceCutoff);
    else
        [CC]=SparseCovarianceDistanceMatrix(xC,yC,Err,Sigma,DistanceCutoff);
    end
    
else
    if CtrlVar.CisElementBased
        CC=sparse(1:MUA.Nele,1:MUA.Nele,1,MUA.Nele,MUA.Nele);
    else
        CC=sparse(1:MUA.Nnodes,1:MUA.Nnodes,1,MUA.Nnodes,MUA.Nnodes);
    end
end

Priors.CovAGlen=CAGlen;
Priors.CovC=CC;


[UserVar,Priors.C,Priors.m]=DefineSlipperyDistribution(UserVar,CtrlVar,MUA,CtrlVar.time,F.s,F.b,F.s-F.b,F.S,F.B,F.rho,F.rhow,GF);
[UserVar,Priors.AGlen,Priors.n,Priors.q,Priors.muk]=DefineAGlenDistribution(UserVar,CtrlVar,MUA,CtrlVar.time,F.s,F.b,F.s-F.b,F.S,F.B,F.rho,F.rhow,GF);

[Priors.AGlen,Priors.n]=TestAGlenInputValues(CtrlVar,MUA,Priors.AGlen,Priors.n);
[Priors.C,Priors.m]=TestSlipperinessInputValues(CtrlVar,MUA,Priors.C,Priors.m,Priors.q,Priors.muk);

Priors.rho=F.rho;
Priors.rhow=F.rhow;

%% Define start values
% I'm here setting starting values equal to priors.
InvStartValues.C=Priors.C + 0.5* sin(xC*2*pi/Lx)*mean(Priors.C) ; 
InvStartValues.m=Priors.m;
InvStartValues.AGlen=Priors.AGlen+0.5*sin(xA*2*pi/Lx)*mean(Priors.AGlen) ; 
InvStartValues.n=Priors.n;


%% Define measurements and measurement errors

fprintf(' Creating synthetic data for iC \n')

CtrlVar.doDiagnostic=1;
[UserVar,F.C,F.m]=DefineSlipperyDistribution(UserVar,CtrlVar,MUA,CtrlVar.time,F.s,F.b,F.s-F.b,F.S,F.B,F.rho,F.rhow,GF);
[UserVar,F.AGlen,F.n]=DefineAGlenDistribution(UserVar,CtrlVar,MUA,CtrlVar.time,F.s,F.b,F.s-F.b,F.S,F.B,F.rho,F.rhow,GF);
[F.AGlen,F.n]=TestAGlenInputValues(CtrlVar,MUA,F.AGlen,F.n);
[F.C,F.m]=TestSlipperinessInputValues(CtrlVar,MUA,F.C,F.m,F.q,F.muk);


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

















end
