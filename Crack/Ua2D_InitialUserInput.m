
function [UserVar,CtrlVar,MeshBoundaryCoordinates]=Ua2D_InitialUserInput(UserVar,CtrlVar)


CtrlVar.Experiment='Crack';
CtrlVar.TimeDependentRun=1;
CtrlVar.Restart=0;
CtrlVar.time=0 ; 
CtrlVar.dt=1e-5; 
CtrlVar.TotalNumberOfForwardRunSteps=1;


%%

[UserVar,CtrlVar,MeshBoundaryCoordinates]=CreateMeshBoundaryCoordinatesForCrack(UserVar,CtrlVar);

 
CtrlVar.OnlyMeshDomainAndThenStop=0;

CtrlVar.TriNodes=3;   % [3,6,10]


%CtrlVar.MeshGenerator='gmsh' ; % 'mesh2d';
% The following options fields are only of relevance if gmsh is selected as a mesh generator. 
CtrlVar.GmshMeshingAlgorithm=8 ; 
CtrlVar.GmshCharacteristicLengthFromCurvature = 1 ;
CtrlVar.GmshCharacteristicLengthExtendFromBoundary=1;

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
