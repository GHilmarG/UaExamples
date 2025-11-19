
%%

load("TestSaveExplicit.mat","UserVar","RunInfo","CtrlVar","MUA","F0","Fm1","BCs1","l1","BCs0","l0")

%%


[UserVar,dhdt]=dhdtExplicitSUPG(UserVar,CtrlVar,MUA,F0,BCs0);


CtrlVar.ThicknessConstraints=true;
CtrlVar.LevelSetMethodAutomaticallyApplyMassBalanceFeedback=true;
CtrlVar.ThicknessPenalty=true;
CtrlVar.h.SUPG.tau="tau0";
CtrlVar.h.SUPG.tau="tau0";
CtrlVar.h.SUPG.tau="tau2";  % smooth 
CtrlVar.h.SUPG.tau="tau1";  % smooth
CtrlVar.h.SUPG.tau="taus";  % wiggles 
%CtrlVar.h.SUPG.tau="taut";  % smooth

[UserVar,RunInfo,h1,l1,BCs1]=MassContinuityEquationNewtonRaphsonThicknessContraints(UserVar,RunInfo,CtrlVar,MUA,F0,F0,l0,BCs0) ;

dhdtMass=(h1-F0.h)/F0.dt;

dhdtDiff=dhdtMass-dhdt;
%%
UaPlots(CtrlVar,MUA,F0,dhdt,FigureTitle="dhdt explicit",GetRidOfValuesDownStreamOfCalvingFronts=false)
CL=clim; CM=cmocean('balanced',25,'pivot',0) ; colormap(CM);

UaPlots(CtrlVar,MUA,F0,dhdtMass,FigureTitle="dhdt Mass",GetRidOfValuesDownStreamOfCalvingFronts=false)
plot(F0.x(BCs0.hPosNode)/1000,F0.y(BCs0.hPosNode)/1000,"or",MarkerSize=2)
clim(CL)
CM=cmocean('balanced',25,'pivot',0) ; colormap(CM);


UaPlots(CtrlVar,MUA,F0,dhdtDiff,FigureTitle="dhdt Diff",GetRidOfValuesDownStreamOfCalvingFronts=false)
clim(CL)
CM=cmocean('balanced',25,'pivot',0) ; colormap(CM);

UaPlots(CtrlVar,MUA,F0,"-speed-",FigureTitle="speed",GetRidOfValuesDownStreamOfCalvingFronts=false)

UaPlots(CtrlVar,MUA,F0,"-uv-",FigureTitle="uv",GetRidOfValuesDownStreamOfCalvingFronts=false)


%%

UaPlots(CtrlVar,MUA,F,F.dhdt,FigureTitle="F.dhdt",GetRidOfValuesDownStreamOfCalvingFronts=false)
plot(F.x(BCs.hPosNode)/1000,F.y(BCs.hPosNode)/1000,"or",MarkerSize=2)
CM=cmocean('balanced',25,'pivot',0) ; colormap(CM);
title("dh/dt as in F.dhdt")
%%