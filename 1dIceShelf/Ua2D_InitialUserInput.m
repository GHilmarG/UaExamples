
function [UserVar,CtrlVar,MeshBoundaryCoordinates]=Ua2D_InitialUserInput(UserVar,CtrlVar)
    
	
  
    CtrlVar.Experiment='Test1dIceShelf'; 
    
    
    CtrlVar.doplots=1; CtrlVar.doRemeshPlots=1;
    
	xd=100e3; xu=-100e3 ; yl=100e3 ; yr=-100e3;
	MeshBoundaryCoordinates=flipud([xu yr ; xd yr ; xd yl ; xu yl]);
    
    %% Types of runs
    CtrlVar.doPrognostic=0 ; 
    CtrlVar.doDiagnostic=1 ;
    CtrlVar.doInverseStep=0;
    time=0 ; dt=0.1; CtrlVar.TotalNumberOfForwardRunSteps=1;
    
    
    %% Solver
    CtrlVar.NLtol=1e-15; % this is the square of the error, i.e. not root-mean-square error
    CtrlVar.InfoLevelNonLinIt=10;
    CtrlVar.LineSeachAllowedToUseExtrapolation=1;
    
    %% Restart
    CtrlVar.Restart=0;  CtrlVar.WriteRestartFile=1;
    CtrlVar.NameOfRestartFiletoRead='iA-Restart.mat';
    CtrlVar.NameOfRestartFiletoWrite='iA-Restart.mat';
    
    
    
    %% Mesh generation and remeshing parameters
    
    CtrlVar.meshgeneration=1; CtrlVar.TriNodes=6 ; CtrlVar.sweep=1;
    CtrlVar.MeshSize=25e3;
    CtrlVar.MeshSizeMin=0.05*CtrlVar.MeshSize;
    CtrlVar.MeshSizeMax=CtrlVar.MeshSize;
    CtrlVar.MaxNumberOfElements=1000;
    %% for adaptive meshing
    CtrlVar.AdaptMesh=1; 
    CtrlVar.AdaptMeshInterval=1;
    CtrlVar.AdaptMeshIterations=1;    % in the explicit adapt method set this to 1, for an implicit adaptation set larger than one 
    CtrlVar.TotalNumberOfForwardRunSteps=1;  % this is a diagnostic calclation, but I introduce a fictous time step for mesh adapting
    %%
   
    CtrlVar.hpower=1;
    
    CtrlVar.RefineCriteria='effective strain rates';
    %CtrlVar.RefineCriteria='thickness gradient';
    %CtrlVar.RefineCriteria={'flotation','thickness gradient'};
    %CtrlVar.RefineCriteria={'f factor'};
	%CtrlVar.RefineCriteria={'flotation'};
    % CtrlVar.RefineCriteria='gradient of effective strain rates';
    CtrlVar.RefineDiracDeltaInvWidth=1000;
    
    
    %% plotting
    CtrlVar.PlotXYscale=1000;
    CtrlVar.PlotMesh=1; CtrlVar.PlotBCs=1;

    
    
    
    
end
