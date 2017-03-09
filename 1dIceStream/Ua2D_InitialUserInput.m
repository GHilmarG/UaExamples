
function [UserVar,CtrlVar,MeshBoundaryCoordinates]=Ua2D_InitialUserInput(UserVar,CtrlVar)
 
    CtrlVar.Experiment='Test1dIceStream'; 
    CtrlVar.doplots=1; CtrlVar.doRemeshPlots=1;
    
	xd=100e3; xu=-100e3 ; yl=10e3 ; yr=-10e3;
	MeshBoundaryCoordinates=flipud([xu yr ; xd yr ; xd yl ; xu yl]);
    
    %% Types of runs
    CtrlVar.TimeDependentRun=1;
    CtrlVar.time=0 ; 
    CtrlVar.dt=0.01; 
    CtrlVar.TotalNumberOfForwardRunSteps=5; 
    CtrlVar.AdaptiveTimeStepping=1 ;
    CtrlVar.TotalTime=10; 
    CtrlVar.ThicknessConstraints=0;
    CtrlVar.FlowApproximation='SSTREAM' ;  % 'SSTREAM'|'SSHEET'|'Hybrid'
    
    
    CtrlVar.Implicituvh=0;      CtrlVar.TG3=0; 
    CtrlVar.uvhTimeSteppingMethod='theta';  % theta | tg3 | supg
    CtrlVar.uvhTimeSteppingMethod='supg';  % theta | tg3 | supg
    CtrlVar.SUPG.beta0=0.5 ; CtrlVar.SUPG.beta1=0.0 ;
    CtrlVar.theta=0.5;
    
    %CtrlVar.uvhTimeSteppingMethod='tg3';  CtrlVar.TG3=1 ; % theta | tg3 | supg
    %CtrlVar.uvhTimeSteppingMethod='shocks';  
    
    
    %CtrlVar.SpeedZero=1e-10;
    %% Solver
    CtrlVar.NLtol=1e-15; % this is the square of the error, i.e. not root-mean-square error
    CtrlVar.InfoLevelNonLinIt=1;
    CtrlVar.InfoLevel=10;
    CtrlVar.LineSeachAllowedToUseExtrapolation=1;
    
    %% Restart
    CtrlVar.Restart=0;  CtrlVar.WriteRestartFile=1;
        
    
    %% Mesh generation and remeshing parameters
    
    CtrlVar.ReadInitialMesh=1;    % if true then read FE mesh (coordinates, connectivity) directly from a .mat file
    % unless the adaptive meshing option is used, no further meshing is done.
    CtrlVar.ReadInitialMeshFileName='NewMeshFile.mat';
    
    CtrlVar.TriNodes=6 ; 
    CtrlVar.MeshSize=2.5e3;
    CtrlVar.MeshSizeMin=0.05*CtrlVar.MeshSize;
    CtrlVar.MeshSizeMax=CtrlVar.MeshSize;
    CtrlVar.MaxNumberOfElements=25000;
    %% for adaptive meshing
    CtrlVar.AdaptMesh=0; 
    CtrlVar.AdaptMeshInterval=1;
    CtrlVar.AdaptMeshIterations=1;    % in the explicit adapt method set this to 1, for an implicit adaptation set larger than one 
    %%
  
      
    CtrlVar.RefineCriteria='effective strain rates';
    %CtrlVar.RefineCriteria='thickness gradient';
    %CtrlVar.RefineCriteria={'flotation','thickness gradient'};
    %CtrlVar.RefineCriteria={'f factor'};
	%CtrlVar.RefineCriteria={'flotation'};
    % CtrlVar.RefineCriteria='gradient of effective strain rates';
    CtrlVar.RefineDiracDeltaInvWidth=1000;
    
    
    %% plotting

    CtrlVar.PlotLabels=0 ; CtrlVar.PlotMesh=1; CtrlVar.PlotBCs=1;
    CtrlVar.PlotXYscale=1000;     % used to scale x and y axis of some of the figures, only used for plotting purposes    
    
    
    
end
