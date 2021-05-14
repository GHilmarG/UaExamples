function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)


CtrlVar.Experiment='Iceberg';

CtrlVar.IncludeMelangeModelPhysics=true;

CtrlVar.TimeDependentRun=0;  % {0|1} if true (i.e. set to 1) then the run is a forward transient one, if not



%% time steps and total run limits
CtrlVar.dt=0.01; 
CtrlVar.time=0; 
CtrlVar.ATSdtMax=0.1; 
CtrlVar.TotalNumberOfForwardRunSteps=1; 
CtrlVar.TotalTime=500; 

CtrlVar.DefineOutputsDt=5;

 
%% Restart options
CtrlVar.Restart=0;
CtrlVar.WriteRestartFile=1;

CtrlVar.NameOfRestartFiletoWrite=[CtrlVar.Experiment,'-RestartFile.mat'];
CtrlVar.NameOfRestartFiletoRead=CtrlVar.NameOfRestartFiletoWrite;

%% Mesh
CtrlVar.TriNodes=6 ;
CtrlVar.MeshSizeMax=2e3; % Changed by Xianwei from 5000 to 5000
CtrlVar.MeshSize=CtrlVar.MeshSizeMax/2;
CtrlVar.MeshSizeMin=CtrlVar.MeshSizeMax/5;
CtrlVar.MeshSizeBoundary=CtrlVar.MeshSize;
CtrlVar.ReadInitialMesh=0;
MeshBoundaryCoordinates=[-10e3  -10e3 ; 10e3 -10e3 ; 10e3 10e3 ; -10e3 10e3] ;

CtrlVar.OnlyMeshDomainAndThenStop=0; % if true then only meshing is done and no further calculations. Usefull for checking if mesh is reasonable
CtrlVar.MaxNumberOfElements=70e3;


%% plotting
CtrlVar.PlotXYscale=1000;
CtrlVar.doplots=1;
CtrlVar.PlotOceanLakeNodes=0;
CtrlVar.PlotMesh=0;  
CtrlVar.PlotBCs=1;




end
