
function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)
    
  
    CtrlVar.Experiment='TestGaussPeak';
     %%
    
    CtrlVar.TimeDependentRun=false ;
   
    CtrlVar.Restart=0;  
    
 
    
    CtrlVar.StartTime=0 ; 
    CtrlVar.EndTime=inf ;   % only needed for a time-dependent run
    CtrlVar.dt=1;
    CtrlVar.TotalNumberOfForwardRunSteps=1;
    
    CtrlVar.FlowApproximation='SSTREAM';  
    
    %%
    xd=200e3; xu=-200e3 ; yl=200e3 ; yr=-200e3;
    MeshBoundaryCoordinates=flipud([xu yr ; xd yr ; xd yl ; xu yl]);


    CtrlVar.GmshGeoFileAdditionalInputLines{1}='Periodic Line {1,2} = {3,4};';  % these lines are added to the gmsh .geo input file each time such a file is created
    %CtrlVar.MeshGenerator='gmsh';  % possible values: {mesh2d|gmsh} 
    CtrlVar.OnlyMeshDomainAndThenStop=0;
    CtrlVar.GmshMeshingAlgorithm=8;  % only relevant if using gmsh, see gmsh manual
    CtrlVar.TriNodes=6;   % [3,6,10]
    CtrlVar.MeshSize=50e3;
    CtrlVar.MeshSizeMin=0.0001*CtrlVar.MeshSize;
    CtrlVar.MeshSizeMax=CtrlVar.MeshSize;
    
    
    CtrlVar.AdaptMesh=1;
    CtrlVar.AdaptMeshInitial=1  ;
    CtrlVar.AdaptMeshMaxIterations=20;
    CtrlVar.AdaptMeshUntilChangeInNumberOfElementsLessThan=0;  
    CtrlVar.AdaptMeshAndThenStop=0;
    
    CtrlVar.MaxNumberOfElements=2500;
    
    
    CtrlVar.WhenPlottingMesh_PlotMeshBoundaryCoordinatesToo=0;  CtrlVar.PlotLabels=0;
    
    CtrlVar.MeshRefinementMethod='explicit:local:newest vertex bisection';
    % CtrlVar.MeshRefinementMethod='explicit:local:red-green';
    % CtrlVar.MeshRefinementMethod='explicit:global';
    CtrlVar.LocalAdaptMeshSmoothingIterations=0;
    
    I=0 ; 
    I=I+1;
    CtrlVar.ExplicitMeshRefinementCriteria(I).Name='effective strain rates gradient';
    CtrlVar.ExplicitMeshRefinementCriteria(I).Scale=1e-8;
    CtrlVar.ExplicitMeshRefinementCriteria(I).EleMin=[];
    CtrlVar.ExplicitMeshRefinementCriteria(I).EleMax=[];
    CtrlVar.ExplicitMeshRefinementCriteria(I).p=[];
    CtrlVar.ExplicitMeshRefinementCriteria(I).InfoLevel=1;
    CtrlVar.ExplicitMeshRefinementCriteria(I).Use=false;
    
    I=I+1;
    CtrlVar.ExplicitMeshRefinementCriteria(I).Name='effective strain rates';
    CtrlVar.ExplicitMeshRefinementCriteria(I).Scale=5e-5;
    CtrlVar.ExplicitMeshRefinementCriteria(I).EleMin=[];
    CtrlVar.ExplicitMeshRefinementCriteria(I).EleMax=[];
    CtrlVar.ExplicitMeshRefinementCriteria(I).p=[];
    CtrlVar.ExplicitMeshRefinementCriteria(I).InfoLevel=1;
    CtrlVar.ExplicitMeshRefinementCriteria(I).Use=true;
    
    I=I+1;
    CtrlVar.ExplicitMeshRefinementCriteria(I).Name='lower surface gradient';
    CtrlVar.ExplicitMeshRefinementCriteria(I).Scale=0.01;
    CtrlVar.ExplicitMeshRefinementCriteria(I).EleMin=[];
    CtrlVar.ExplicitMeshRefinementCriteria(I).EleMax=[];
    CtrlVar.ExplicitMeshRefinementCriteria(I).p=[];
    CtrlVar.ExplicitMeshRefinementCriteria(I).InfoLevel=1;
    CtrlVar.ExplicitMeshRefinementCriteria(I).Use=false;
    
    
    
    
    
    %%
    CtrlVar.LineSeachAllowedToUseExtrapolation=1;
    
    %%
    CtrlVar.doplots=1;
    CtrlVar.doAdaptMeshPlots=1;
    CtrlVar.InfoLevelAdaptiveMeshing=10;
    
    CtrlVar.PlotNodes=1;       % If true then nodes are plotted when FE mesh is shown
    CtrlVar.PlotXYscale=1000;     % used to scale x and y axis of some of the figures, only used for plotting purposes
    CtrlVar.PlotLabels=0 ; CtrlVar.PlotMesh=1; CtrlVar.PlotBCs=00;CtrlVar.PlotNodes=1;
    
    CtrlVar.InfoLevelNonLinIt=1000;
    
end
