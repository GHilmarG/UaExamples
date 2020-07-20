
function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)


if isempty(UserVar)
    UserVar.RunType="-ManuallyDeactivateElements-";
end

%%

UserVar.Outputsdirectory='ResultsFiles'; % This I use in UaOutputs


CtrlVar.Experiment="Calving"+UserVar.RunType;
%% Types of run
%
CtrlVar.TimeDependentRun=1; 
CtrlVar.TotalNumberOfForwardRunSteps=10000;
CtrlVar.TotalTime=5;
CtrlVar.Restart=0;  
CtrlVar.InfoLevelNonLinIt=1; 

CtrlVar.dt=0.01; 
CtrlVar.time=0; 

CtrlVar.DefineOutputsDt=0.1; % interval between calling UaOutputs. 0 implies call it at each and every run step.
                       % setting CtrlVar.DefineOutputsDt=1; causes UaOutputs to be called every 1 years.
                       % This is a more reasonable value once all looks OK.

CtrlVar.ATSdtMax=1;  % maximum time step allowed using the automated time stepping method
CtrlVar.ATSTargetIterations=3;  % if the number of non-lin iteration in the NR solver falls below this value, dt is increased 


CtrlVar.WriteRestartFile=1;

%% Reading in mesh
CtrlVar.ReadInitialMesh=0;    % if true then read FE mesh (i.e the MUA variable) directly from a .mat file
                              % unless the adaptive meshing option is used, no further meshing is done.
% CtrlVar.ReadInitialMeshFileName='AdaptMesh.mat';
% CtrlVar.SaveInitialMeshFileName='NewMeshFile.mat';
%% Plotting options
CtrlVar.PlotMesh=0; 
CtrlVar.PlotBCs=0;
CtrlVar.WhenPlottingMesh_PlotMeshBoundaryCoordinatesToo=1;

CtrlVar.PlotXYscale=1000; 
%%

CtrlVar.TriNodes=3;


CtrlVar.NameOfRestartFiletoWrite="Restart"+CtrlVar.Experiment+".mat";
CtrlVar.NameOfRestartFiletoRead=CtrlVar.NameOfRestartFiletoWrite;




%% mesh generation


CtrlVar.MeshGenerator='gmsh';
CtrlVar.GmshMeshingAlgorithm=8;     % see gmsh manual
                                    % 1=MeshAdapt
                                    % 2=Automatic
                                    % 5=Delaunay
                                    % 6=Frontal
                                    % 7=bamg
                                    % 8=DelQuad (experimental)
% very coarse mesh resolution
CtrlVar.MeshSize=10e3;       % over-all desired element size
CtrlVar.MeshSizeMax=10e3;    % max element size
CtrlVar.MeshSizeMin=0.01*CtrlVar.MeshSize;     % min element size

% reasonably fine mesh resolution
%CtrlVar.MeshSize=8e3;       % over-all desired element size
%CtrlVar.MeshSizeMax=8e3;    % max element size
%CtrlVar.MeshSizeMin=200;    % min element size

CtrlVar.MaxNumberOfElements=250e3;           % max number of elements. If #elements larger then CtrlMeshSize/min/max are changed

%% Adapt mesh

CtrlVar.AdaptMesh=1;         
CtrlVar.AdaptMeshMaxIterations=10;  % Number of adapt mesh iterations within each run-step.
CtrlVar.MeshRefinementMethod='explicit:local:newest vertex bisection';    % can have any of these values:
                                                   % 'explicit:global' 
                                                   % 'explicit:local'
                                                   % 'explicit:local:red-green'
                                                   % 'explicit:local:newest vertex bisection';
%  

CtrlVar.SaveAdaptMeshFileName=[];          % file name for saving adapt mesh. If left empty, no file is written
CtrlVar.AdaptMeshInitial=1 ;       % if true, then a remeshing will always be performed at the inital step
CtrlVar.AdaptMeshAndThenStop=0;    % if true, then mesh will be adapted but no further calculations performed
                                   % usefull, for example, when trying out different remeshing options (then use CtrlVar.doRemeshPlots=1 to get plots)

CtrlVar.AdaptMeshUntilChangeInNumberOfElementsLessThan=5;
CtrlVar.AdaptMeshRunStepInterval=1;  % number of run-steps between mesh adaptation
CtrlVar.MeshAdapt.GLrange=[20000 5000 ; 5000 2000];
%CtrlVar.MeshAdapt.GLrange=[20000 5000 ];



%% Pos. thickness constr


CtrlVar.ThickMin=1; % minimum allowed thickness without (potentially) doing something about it
CtrlVar.ResetThicknessToMinThickness=0;  % if true, thickness values less than ThickMin will be set to ThickMin
CtrlVar.ThicknessConstraints=1  ;        % if true, min thickness is enforced using active set method
CtrlVar.ThicknessConstraintsItMax=5  ; 

%%

xd=640e3; xu=0e3 ; yr=0 ; yl=80e3 ;  
MeshBoundaryCoordinates=[xu yr ; xu yl ; xd yl ; xd yr];

%% Things that I�m testing and that are specifically realted to ideas around implementing calving

if contains(UserVar.RunType,"-ManuallyDeactivateElements-")
    CtrlVar.ManuallyDeactivateElements=1 ;
else
    CtrlVar.ManuallyDeactivateElements=0 ;
end

if contains(UserVar.RunType,"-ManuallyModifyThickness-")
    CtrlVar.GeometricalVarsDefinedEachTransienRunStepByDefineGeometry="sb";
else
    CtrlVar.GeometricalVarsDefinedEachTransienRunStepByDefineGeometry="";
end


CtrlVar.doAdaptMeshPlots=1; 
CtrlVar.InfoLevelAdaptiveMeshing=100;
%CtrlVar.doplots=1;
   


end

