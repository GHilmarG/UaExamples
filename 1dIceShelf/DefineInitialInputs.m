
function [UserVar,CtrlVar,MeshBoundaryCoordinates]=Ua2D_InitialUserInput(UserVar,CtrlVar)



CtrlVar.Experiment='Test1dIceShelf';


CtrlVar.doplots=1; CtrlVar.doRemeshPlots=1;

xd=100e3; xu=-100e3 ; yl=100e3 ; yr=-100e3;
MeshBoundaryCoordinates=flipud([xu yr ; xd yr ; xd yl ; xu yl]);

%% Types of runs
CtrlVar.TimeDependentRun=false ;
CtrlVar.doInverseStep=0;
CtrlVar.time=0 ;
CtrlVar.dt=0.1;
CtrlVar.TotalNumberOfForwardRunSteps=1;


%% Solver
CtrlVar.NLtol=1e-15; % this is the square of the error, i.e. not root-mean-square error
CtrlVar.InfoLevelNonLinIt=1;
CtrlVar.LineSeachAllowedToUseExtrapolation=1;

%% Restart
CtrlVar.Restart=0;  CtrlVar.WriteRestartFile=1;
CtrlVar.NameOfRestartFiletoRead='iA-Restart.mat';
CtrlVar.NameOfRestartFiletoWrite='iA-Restart.mat';



%% Mesh generation and remeshing parameters

CtrlVar.meshgeneration=1; CtrlVar.TriNodes=6 ; CtrlVar.sweep=1;
CtrlVar.MeshSize=25e3;
CtrlVar.MeshSizeMin=0.01*CtrlVar.MeshSize;
CtrlVar.MeshSizeMax=CtrlVar.MeshSize;
CtrlVar.MaxNumberOfElements=1000;
%% for adaptive meshing
CtrlVar.AdaptMesh=1;
CtrlVar.GmshMeshingAlgorithm=8;     % see gmsh manual

CtrlVar.AdaptMeshInitial=1  ; % remesh in first run-step irrespecitivy of the value of AdaptMeshInterval
CtrlVar.AdaptMeshRunStepInterval=1 ; % Number of run-steps between mesh adaptation 
CtrlVar.AdaptMeshMaxIterations=10;  % Number of adapt mesh iterations within each run-step.
CtrlVar.AdaptMeshUntilChangeInNumberOfElementsLessThan=0;  
                                
CtrlVar.InfoLevelAdaptiveMeshing=10;  
CtrlVar.MeshRefinementMethod='explicit:local:newest vertex bisection';

I=1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Name='effective strain rates';
CtrlVar.ExplicitMeshRefinementCriteria(I).Scale=0.01;
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMin=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMax=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).p=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).InfoLevel=1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Use=true;


I=I+1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Name='effective strain rates gradient';
CtrlVar.ExplicitMeshRefinementCriteria(I).Scale=0.001/1000;
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMin=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMax=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).p=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).InfoLevel=1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Use=false;

%%


%% plotting
CtrlVar.PlotXYscale=1000;
CtrlVar.PlotMesh=1; CtrlVar.PlotBCs=1;





end
