





function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)

CtrlVar.Experiment='Test1dIceStream';
CtrlVar.doplots=1; CtrlVar.doRemeshPlots=1;

xd=100e3; xu=-100e3 ; yl=10e3 ; yr=-10e3;
MeshBoundaryCoordinates=flipud([xu yr ; xd yr ; xd yl ; xu yl]);

%% Types of runs
CtrlVar.TimeDependentRun=true;
CtrlVar.StartTime=0;
CtrlVar.EndTime=1;
CtrlVar.dt=0.001;
CtrlVar.TotalNumberOfForwardRunSteps=inf;
CtrlVar.AdaptiveTimeStepping=1 ;
CtrlVar.ThicknessConstraints=0;
CtrlVar.FlowApproximation='SSTREAM' ;  % 'SSTREAM'|'SSHEET'|'Hybrid'

CtrlVar.ForwardTimeIntegration="-uvh-" ; % "-uv-h-" ; % "-uvh-" , "-uv-h-" , "-uv-" , "-h-" ; 

%CtrlVar.theta=1; % backward Euler
CtrlVar.theta=0.5; % Lax-Wendroff
%CtrlVar.theta=0; % forward Euler

CtrlVar.SUPG.beta0=1.0 ; CtrlVar.SUPG.beta1=0 ; % parameters related to the SUPG method.
%CtrlVar.SUPG.beta0=0.0 ; CtrlVar.SUPG.beta1=0 ; % parameters related to the SUPG method.

CtrlVar.DefineOutputsDt=0.01; % model time interval between calling DefineOutputs.m, output interval

CtrlVar.uvh.SUPG.tau="taus" ; % {'tau1','tau2','taus','taut'}  
CtrlVar.h.SUPG.tau="taus";  CtrlVar.h.SUPG.Use=1;
% CtrlVar.h.SUPG.tau="tau1";  CtrlVar.h.SUPG.Use=1;

CtrlVar.uvh.SUPG.tauMultiplier=1 ; 
CtrlVar.h.SUPG.tauMultiplier=1 ; 

%CtrlVar.SpeedZero=1e-10;
%% Solver

CtrlVar.InfoLevelNonLinIt=1;
CtrlVar.InfoLevel=1;
CtrlVar.LineSeachAllowedToUseExtrapolation=1;

%% Restart
CtrlVar.Restart=0;  CtrlVar.WriteRestartFile=1;


%% Mesh generation and remeshing parameters

CtrlVar.ReadInitialMesh=0;    % if true then read FE mesh (coordinates, connectivity) directly from a .mat file
% unless the adaptive meshing option is used, no further meshing is done.
CtrlVar.ReadInitialMeshFileName='NewMeshFile.mat';

CtrlVar.TriNodes=3 ;
CtrlVar.MeshSize=2e3;
CtrlVar.MeshSizeMin=0.05*CtrlVar.MeshSize;
CtrlVar.MeshSizeMax=CtrlVar.MeshSize;
CtrlVar.MaxNumberOfElements=25000;

%% for adaptive meshing
CtrlVar.AdaptMesh=1;
CtrlVar.MeshGenerator='mesh2d';  % possible values: {mesh2d|gmsh}


CtrlVar.AdaptMeshInitial=1  ;            % remesh in first run-step irrespecitivy of the value of AdaptMeshInterval
CtrlVar.AdaptMeshRunStepInterval=inf ;   % Number of run-steps between mesh adaptation
CtrlVar.AdaptMeshMaxIterations=10;       % Number of adapt mesh iterations within each run-step.
CtrlVar.AdaptMeshUntilChangeInNumberOfElementsLessThan=10;

CtrlVar.InfoLevelAdaptiveMeshing=10;
%CtrlVar.InfoLevelAdaptiveMeshing=0;
CtrlVar.MeshRefinementMethod='explicit:local:newest vertex bisection';

I=1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Name='effective strain rates';
CtrlVar.ExplicitMeshRefinementCriteria(I).Scale=0.01;
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMin=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMax=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).p=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).InfoLevel=1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Use=false;


I=I+1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Name='effective strain rates gradient';
CtrlVar.ExplicitMeshRefinementCriteria(I).Scale=0.001/1000;
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMin=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMax=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).p=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).InfoLevel=1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Use=false;

I=I+1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Name='thickness gradient';
CtrlVar.ExplicitMeshRefinementCriteria(I).Scale=0.001;
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMin=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMax=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).p=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).InfoLevel=1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Use=false;

 CtrlVar.MeshAdapt.GLrange=[10000 2000 ; 5000 500 ; 2000 100 ];
% CtrlVar.MeshAdapt.GLrange=[5000 1000 ; 1000 250 ];

%CtrlVar.MeshAdapt.GLrange=[10000 2000 ; 2000 500];                                                    
%% plotting

CtrlVar.PlotLabels=0 ; CtrlVar.PlotMesh=1; CtrlVar.PlotBCs=1;
CtrlVar.PlotXYscale=1000;     % used to scale x and y axis of some of the figures, only used for plotting purposes



end
