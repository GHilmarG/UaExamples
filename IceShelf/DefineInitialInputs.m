
function [UserVar,CtrlVar,MeshBoundaryCoordinates]=Ua2D_InitialUserInput(UserVar,CtrlVar)

%%

UserVar.Geometry='square';
UserVar.Geometry='island';


%%


CtrlVar.Experiment='Test1dIceShelf';


CtrlVar.doplots=1; CtrlVar.doRemeshPlots=1;

Length=200e3 ; Width=100e3;
xu=0 ;
xd=Length;
yl=Width/2 ;
yr=-Width/2;

switch UserVar.Geometry
    
    case 'square'
        MeshBoundaryCoordinates=[xu yl ; xd yl ; xd yr ; xu yr];
        
    case 'island'
        x0=50e3;
         MeshBoundaryCoordinates=[xu yl ; xd yl ; xd yr ; xu yr ; ...                           % Outer boundary (clockwise orientation)
             NaN NaN ; xu/10+x0 yr/10 ; xd/10+x0 yr/10 ; xd/10+x0 yl/10 ; xu/10+x0 yl/10];      % inner boundary (anticlockwise orientation)
         
%         MeshBoundaryCoordinates=[-1 -1 ; -1 0 ; 0 1 ; 1 0 ; 1 -1 ; 0 -1 ; ...      
%             NaN NaN ;  0.5 -0.5 ; 0.5 0 ; 0.1 0 ; 0.1 -0.5 ; ...         
%             NaN NaN ; -0.1 -0.5 ; -0.1 0 ; -0.8 0 ; -0.8 -0.5 ];         % another innner boundary (anticlockwise orientation
end

%% Types of runs
CtrlVar.TimeDependentRun=1 ;
CtrlVar.dt=0.1;
CtrlVar.TotalNumberOfForwardRunSteps=200;
CtrlVar.TotalTime=50;          % maximum model time
CtrlVar.time=0; 
CtrlVar.ATSdtMax=2.0;  % Timestep maximum is 10 years




%% Restart
CtrlVar.Restart=0;  CtrlVar.WriteRestartFile=1;
CtrlVar.NameOfRestartFiletoRead=UserVar.Geometry;
CtrlVar.NameOfRestartFiletoWrite=UserVar.Geometry;



%% Mesh generation and remeshing parameters

CtrlVar.meshgeneration=1; 
CtrlVar.TriNodes=6 ;  % {3|6|10}  number of nodes per element
CtrlVar.MeshSize=Width/10;
CtrlVar.MeshSizeMin=0.01*CtrlVar.MeshSize;
CtrlVar.MeshSizeMax=CtrlVar.MeshSize;
CtrlVar.MaxNumberOfElements=5000;
%% for adaptive meshing
CtrlVar.AdaptMesh=1;

CtrlVar.GmshMeshingAlgorithm=8;     % see gmsh manual, only relevant if using the gmsh mesh generator
CtrlVar.MeshGenerator='mesh2d';      % 'mesh2d' | 'gmsh' 

CtrlVar.AdaptMeshInitial=1  ; % remesh in first run-step irrespecitivy of the value of AdaptMeshInterval
CtrlVar.AdaptMeshRunStepInterval=1 ; % Number of run-steps between mesh adaptation 
CtrlVar.AdaptMeshMaxIterations=1;  % Number of adapt mesh iterations within each run-step.
CtrlVar.AdaptMeshUntilChangeInNumberOfElementsLessThan=0;  
CtrlVar.AdaptMeshAndThenStop=0; 
CtrlVar.InfoLevelAdaptiveMeshing=1;  
CtrlVar.MeshRefinementMethod='explicit:local:newest vertex bisection';                       % 'explicit:global';'explicit:local:newest vertex bisection';




I=1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Name='effective strain rates';
CtrlVar.ExplicitMeshRefinementCriteria(I).Scale=0.01;
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMin=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMax=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).p=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).InfoLevel=0;
CtrlVar.ExplicitMeshRefinementCriteria(I).Use=false;


I=I+1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Name='effective strain rates gradient';
CtrlVar.ExplicitMeshRefinementCriteria(I).Scale=0.0001/1000;
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMin=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMax=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).p=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).InfoLevel=0;
CtrlVar.ExplicitMeshRefinementCriteria(I).Use=true;


I=I+1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Name='thickness gradient';
CtrlVar.ExplicitMeshRefinementCriteria(I).Scale=0.001;
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMin=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMax=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).p=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).InfoLevel=1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Use=false;



%%


%% plotting
CtrlVar.PlotXYscale=1000;
CtrlVar.PlotMesh=1; CtrlVar.PlotBCs=1;
CtrlVar.doplots=0;          % if true then plotting during runs by Ua are allowed, set to 0 to suppress all plots

CtrlVar.ThickMin=1; % minimum allowed thickness without (potentially) doing something about it
CtrlVar.ResetThicknessToMinThickness=0;  % if true, thickness values less than ThickMin will be set to ThickMin
CtrlVar.ThicknessConstraints=1  ;        % if true, min thickness is enforced using active set method
CtrlVar.ThicknessConstraintsItMax=2500  ;

CtrlVar.DefineOutputsDt=20;


end
