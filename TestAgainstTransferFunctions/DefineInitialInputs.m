
function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)


CtrlVar.Experiment='TestingAgainstTransferFunctions';
CtrlVar.FlowApproximation="SSTREAM" ; % "SSTREAM" ; % 'Hybrid' ;  % 'SSTREAM'|'SSHEET'|'Hybrid'
CtrlVar.TimeDependentRun=1;
CtrlVar.alpha=0.05;   % slope of the coordinate system

xd=50e3; xu=-50e3 ; yl=20e3 ; yr=-20e3;


MeshBoundaryCoordinates=flipud([xu yr ; xd yr ; xd yl ; xu yl]);
CtrlVar.GmshGeoFileAdditionalInputLines{1}='Periodic Line {1,2} = {3,4};';  % these lines are added to the gmsh .geo input file each time such a file is created
CtrlVar.OnlyMeshDomainAndThenStop=0;

CtrlVar.TriNodes=6;   % [3,6,10]
CtrlVar.MeshSize=5e3;
CtrlVar.MeshSizeMin=0.01*CtrlVar.MeshSize;
CtrlVar.MeshSizeMax=CtrlVar.MeshSize;
CtrlVar.GmshMeshingAlgorithm=8;

%%
CtrlVar.Restart=0;
CtrlVar.time=0 ;
CtrlVar.dt=0.1; CtrlVar.AdaptiveTimeStepping=0 ;
CtrlVar.TotalNumberOfForwardRunSteps=100;

CtrlVar.ThicknessConstraints=0;
%%

CtrlVar.doplots=1;
CtrlVar.PlotXYscale=1000;     % used to scale x and y axis of some of the figures, only used for plotting purposes
CtrlVar.PlotLabels=0 ; CtrlVar.PlotMesh=1; CtrlVar.PlotBCs=1;CtrlVar.PlotNodes=1;

CtrlVar.InfoLevelNonLinIt=1;

%% Automated mesh refinement
CtrlVar.MeshGenerator='gmsh'; % mesh2d does not allow for periodic BCs 
CtrlVar.GmshMeshingAlgorithm=8;  % see gmsh manual
CtrlVar.AdaptMesh=0;  CtrlVar.InfoLevelAdaptiveMeshing=10;
CtrlVar.AdaptMeshInitial=1  ;
CtrlVar.AdaptMeshMaxIterations=5;
CtrlVar.AdaptMeshUntilChangeInNumberOfElementsLessThan=0;
CtrlVar.AdaptMeshAndThenStop=0;

CtrlVar.MaxNumberOfElements=25000;


CtrlVar.WhenPlottingMesh_PlotMeshBoundaryCoordinatesToo=0;  CtrlVar.PlotLabels=0;

CtrlVar.MeshRefinementMethod='explicit:local:newest vertex bisection';


I=1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Name='effective strain rates';
CtrlVar.ExplicitMeshRefinementCriteria(I).Scale=1e-3;
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMin=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMax=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).p=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).InfoLevel=1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Use=true;

%% Perturbations

UserVar.ampl_c=0.0; UserVar.sigma_cx=(xd-xu)/20; UserVar.sigma_cy=Inf;        %  UserVar.C0=...
UserVar.ampl_b=0.1; UserVar.sigma_bx=(xd-xu)/20; UserVar.sigma_by=(xd-xu)/0;  % UserVar.h0=...




end
