
function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)
    
  
    CtrlVar.Experiment='TestGaussPeak';
     %%

     CtrlVar.ForwardTimeIntegration="-uv-";
     CtrlVar.ForwardTimeIntegration="-uvh-";
     %CtrlVar.ForwardTimeIntegration="-uv-h-"; CtrlVar.uv2h.MaxIterations=1; CtrlVar.uv2h.uvTolerance=0; CtrlVar.hTheta=0; 

     CtrlVar.alpha=0.0;

     CtrlVar.Restart=0;

     CtrlVar.StartTime=0;
     CtrlVar.EndTime=100;

     CtrlVar.dt=10;
     CtrlVar.AdaptiveTimeStepping=0 ; 
     CtrlVar.TotalNumberOfForwardRunSteps=inf;

     CtrlVar.FlowApproximation='SSTREAM';   % 'hybrid'
    % CtrlVar.FlowApproximation='SSHEET';
     %CtrlVar.ALSpower=6;

     %%

      CtrlVar.AsymmSolver="NullSpace";   

    %%
    xd=300e3; xu=-300e3 ; yl=300e3 ; yr=-300e3;
    MeshBoundaryCoordinates=flipud([xu yr ; xd yr ; xd yl ; xu yl]);
  
    CtrlVar.OnlyMeshDomainAndThenStop=0;
    
    CtrlVar.MeshGenerator="UaSquareMesh";
    CtrlVar.UaSquareMesh.xmin=xu ; 
    CtrlVar.UaSquareMesh.xmax=xd;
    CtrlVar.UaSquareMesh.ymin=yr;
    CtrlVar.UaSquareMesh.ymax=yl;

    CtrlVar.UaSquareMesh.nx=20;
    CtrlVar.UaSquareMesh.ny=20; 

    CtrlVar.TriNodes=6;   % [3,6,10]
    CtrlVar.MeshSize=25e3;  % Not used initially when using UaSquareMesh, but will be used in later mesh refinements
    CtrlVar.MeshSizeMin=0.0001*CtrlVar.MeshSize;
    CtrlVar.MeshSizeMax=CtrlVar.MeshSize;
    
    
    CtrlVar.AdaptMesh=1;
    CtrlVar.AdaptMeshInitial=1  ;
    CtrlVar.AdaptMeshMaxIterations=20;
    CtrlVar.AdaptMeshUntilChangeInNumberOfElementsLessThan=0;  
    CtrlVar.AdaptMeshAndThenStop=0;
    
    CtrlVar.MaxNumberOfElements=25000;
    
    
    CtrlVar.WhenPlottingMesh_PlotMeshBoundaryCoordinatesToo=0;  CtrlVar.PlotLabels=0;
    
    CtrlVar.MeshRefinementMethod='explicit:local:newest vertex bisection';
    %CtrlVar.MeshRefinementMethod='explicit:local:red-green';
    %CtrlVar.MeshRefinementMethod='global';
    %CtrlVar.LocalAdaptMeshSmoothingIterations=32; 
    %CtrlVar.GlobalAdaptMeshSmoothingIterations=0;
    
    I=1;
    CtrlVar.ExplicitMeshRefinementCriteria(I).Name='effective strain rates gradient';
    CtrlVar.ExplicitMeshRefinementCriteria(I).Scale=1e-8;
    CtrlVar.ExplicitMeshRefinementCriteria(I).EleMin=[];
    CtrlVar.ExplicitMeshRefinementCriteria(I).EleMax=[];
    CtrlVar.ExplicitMeshRefinementCriteria(I).p=[];
    CtrlVar.ExplicitMeshRefinementCriteria(I).InfoLevel=1;
    CtrlVar.ExplicitMeshRefinementCriteria(I).Use=false;
    
    I=2;
    CtrlVar.ExplicitMeshRefinementCriteria(I).Name='effective strain rates';
    CtrlVar.ExplicitMeshRefinementCriteria(I).Scale=5e-5;
    CtrlVar.ExplicitMeshRefinementCriteria(I).EleMin=[];
    CtrlVar.ExplicitMeshRefinementCriteria(I).EleMax=[];
    CtrlVar.ExplicitMeshRefinementCriteria(I).p=[];
    CtrlVar.ExplicitMeshRefinementCriteria(I).InfoLevel=1;
    CtrlVar.ExplicitMeshRefinementCriteria(I).Use=true;
    
   

    %% BCs

    CtrlVar.BCsRowSubsetSelection=true; 


    %%
    CtrlVar.LineSeachAllowedToUseExtrapolation=1;
    
    %%
    CtrlVar.doplots=1;
    CtrlVar.doAdaptMeshPlots=1;
    CtrlVar.InfoLevelAdaptiveMeshing=10;
    
    CtrlVar.PlotNodes=1;       % If true then nodes are plotted when FE mesh is shown
    CtrlVar.PlotXYscale=1000;     % used to scale x and y axis of some of the figures, only used for plotting purposes
    CtrlVar.PlotLabels=0 ; CtrlVar.PlotMesh=1; CtrlVar.PlotBCs=00;CtrlVar.PlotNodes=1;
    CtrlVar.InfoLevelNonLinIt=1;

    %% Rhubarb
    CtrlVar.AdaptMesh=0;
    
end
