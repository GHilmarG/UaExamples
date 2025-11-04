
function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)

%%

UserVar.Crack.a=0.01e3 ;  % horizontal   
UserVar.Crack.b=2e3   ;  % vertical
UserVar.Crack.x0=0; 
UserVar.Crack.y0=0;
UserVar.Domain=20e3 ; % 

%%
CtrlVar.MeshSizeMax=1e3; 
CtrlVar.MeshSizeMin=0.001e3;
CtrlVar.AdaptMesh=1;  
CtrlVar.AdaptMeshMaxIterations=2;  
%%

CtrlVar.Experiment='Crack';
CtrlVar.TimeDependentRun=0;
CtrlVar.Restart=0;
CtrlVar.TotalNumberOfForwardRunSteps=5;

%%

%%

[UserVar,CtrlVar,MeshBoundaryCoordinates]=CreateMeshBoundaryCoordinatesForCrack(UserVar,CtrlVar);

 
CtrlVar.OnlyMeshDomainAndThenStop=0;
CtrlVar.TriNodes=3;   % [3,6,10]


%%

CtrlVar.WriteRestartFile=1;

CtrlVar.doplots=1;
CtrlVar.doRemeshPlots=1;
CtrlVar.doAdaptMeshPlots=1; % if true and if CtrlVar.doplots true also, then do some extra plotting related to adapt meshing
CtrlVar.PlotNodes=1;       % If true then nodes are plotted when FE mesh is shown
CtrlVar.PlotXYscale=1000;     % used to scale x and y axis of some of the figures, only used for plotting purposes
CtrlVar.PlotLabels=0 ; 
CtrlVar.PlotMesh=1; 
CtrlVar.PlotBCs=1;
CtrlVar.PlotNodes=1;

%%
CtrlVar.InfoLevelNonLinIt=1;
CtrlVar.LineSeachAllowedToUseExtrapolation=1;

end
