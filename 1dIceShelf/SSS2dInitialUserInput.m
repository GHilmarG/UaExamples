
function [UserVar,CtrlVar,time,dt,MeshBoundaryCoordinates]=Ua2d_InitialUserInput(CtrlVar)
    
	
    Experiment='Test1dIceShelf'; CtrlVar.CompareWithAnalyticalSolutions=1;
    CtrlVar.doplots=1;  CtrlVar.FE2dPlots=0;
    
	xd=100e3; xu=-100e3 ; yl=100e3 ; yr=-100e3;
	MeshBoundaryCoordinates=[xu yr ; xd yr ; xd yl ; xu yl];
    
    %% Types of runs
    CtrlVar.doPrognostic=0 ; 
    CtrlVar.doDiagnostic=1 ;
    CtrlVar.doInverseStep=0;
    CtrlVar.Implicituvh=1;  CtrlVar.TG3=0 ; CtrlVar.Gamma=1;
    
    CtrlVar.kH=1;
    time=0 ; dt=0.1; CtrlVar.TotalNumberOfForwardRunSteps=1;
    
    
    %% Solver
    CtrlVar.NLtol=1e-15; % this is the square of the error, i.e. not root-mean-square error
    CtrlVar.InfoLevelNonLinIt=10;
    CtrlVar.LineSeachAllowedToUseExtrapolation=1;
    
    %% Restart
    CtrlVar.Restart=0;  CtrlVar.WriteRestartFile=1;
    CtrlVar.NameOfRestartFiletoRead='iA-Restart.mat';
    CtrlVar.NameOfRestartFiletoWrite='iA-Restart.mat';
    
    %% Adjoint
    CtrlVar.AdjointRestart=0 ; CtrlVar.AdjointWriteRestartFile=1; 
    CtrlVar.NameOfAdjointRestartFiletoRead='iA-AdjointRestart.mat';
    CtrlVar.NameOfAdjointRestartFiletoWrite='iA-AdjointRestart.mat';
    CtrlVar.MaxAdjointIterations=1 ;
    CtrlVar.InfoLevelAdjoint=100;
    CtrlVar.AdjointxScale=1.2e-5; % m=3
    %CtrlVar.AdjointxScale=1e-3; % m=2
    %CtrlVar.AdjointxScale=0.08; % m=1; 
    
    %CtrlVar.AdjointMinimisationMethod='DecentProjectedGradient';  CtrlVar.AdjointInitialStep=1e-10;
    CtrlVar.AdjointMinimisationMethod='ProjectedBFGS'; CtrlVar.AdjointInitialStep=1; 
    CtrlVar.AdjointMinimisationMethod='Silly'; CtrlVar.AdjointInitialStep=1; 
     
	CtrlVar.MisfitFunction='uvintegral'; 
    %CtrlVar.MisfitFunction='uvdiscrete';
    CtrlVar.NormalizeWithAreas=0 ;  CtrlVar.AdjointEleAverage=0;
    
    CtrlVar.AGlenmin=eps; CtrlVar.AGlenmax=1e10;
    CtrlVar.Cmin=100*eps;  CtrlVar.Cmax=1e10;
    
    CtrlVar.AdjointGrad='A';
    
    CtrlVar.AdjointConjugatedGradients=1;
    CtrlVar.AdjointGradientEleAverage=1;
    
    CtrlVar.AdjointEleConst=1 ;
    CtrlVar.CAdjointZero=1e-8; % used as a regularisation parameter when calculating dIdCq
    CtrlVar.AdjointLineSearch=1;CtrlVar.AdjointMinStep=1e-15; 
    
    CtrlVar.fminbndMaxIterations=20; CtrlVar.fminbndTol=1e-30;
    CtrlVar.AdjointExtrapolateStepFactor=2; CtrlVar.AdjointMaxFuncEvalinExtrapolateStep=40 ;
    
    
    CtrlVar.Cbarrier=1e50; CtrlVar.isBarrier=0;
    CtrlVar.isRegC=0; CtrlVar.isRegAGlen=1;
    
    
    
    %% Mesh generation and remeshing parameters
    
    CtrlVar.meshgeneration=1; CtrlVar.TriNodes=6 ; CtrlVar.sweep=1;
    CtrlVar.MeshSize=5e3;
    CtrlVar.MaxNumberOfElements=10e3;
    CtrlVar.AdaptMesh=0;
    CtrlVar.AdaptMeshInitial=1  ; 
    CtrlVar.AdaptMeshInterval=27;
    CtrlVar.nDiagnosticRemeshSteps=1;  % number of global remesh operations during a diagnostic step
	CtrlVar.nInitialRemeshSteps=0;
    
    CtrlVar.MeshSizeMin=0.05*CtrlVar.MeshSize;
    CtrlVar.MeshSizeMax=CtrlVar.MeshSize;
    CtrlVar.hpower=1;
    
    CtrlVar.RefineCriteria='effective strain rates';
    %CtrlVar.RefineCriteria='thickness gradient';
    %CtrlVar.RefineCriteria={'flotation','thickness gradient'};
    %CtrlVar.RefineCriteria={'f factor'};
	%CtrlVar.RefineCriteria={'flotation'};
    % CtrlVar.RefineCriteria='gradient of effective strain rates';
    CtrlVar.RefineDiracDeltaInvWidth=1000;
    
    
    
    
    CtrlVar.iJob=91;
    CtrlVar.UseSyntheticData=0;

    
    
    
    %% plotting
    CtrlVar.doTransientPlots=10000; CtrlVar.PlotGLmask=0;  CtrlVar.PlotStrains=0;
    CtrlVar.meshgeneration=1; CtrlVar.CuthillMcKee=0;
    CtrlVar.PlotLabels=0 ; CtrlVar.PlotMesh=1; CtrlVar.PlotBCs=1;
    
    
    CtrlVar.InitializeVelocityUsingPreviousModelOutput=0;
    
    
    
  
    
    
    
    
    
    
end
