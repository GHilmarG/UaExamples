
function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)
    
    %%
    %
    % 
    %
    % To describe/prescribe calving various other options are available.
    %
    % For example elements can be deactivated and then reactivated to simulate a calving event.
    %
    % Also, calving can be prescribed using a melt perturbation with a thickness feedback.
    %
    % Currently the best approach seems to be to use the level set method with the level set being prescribed by the user at each
    % time step using 'DefineCalving.m'.  (Dynamically updating the level set based on a calving law is in preparation but not
    % ready for general use)
    %
    %
    %
    % Note: 
    % Here some input files are needed that give the steady-state
    % (approximately) geometry for the MismipPlus experiment as obtained
    % in previous runs with Úa
    %
    % You can get these from:
    %
    % https://livenorthumbriaac-my.sharepoint.com/:f:/g/personal/hilmar_gudmundsson_northumbria_ac_uk/EgrEImnkQuJNmf1GEB80VbwB1hgKNnRMscUitVpBrghjRg
    %
    % Put these files in a folder and make sure that folder is in the
    % matlab path
    %
    %
    %%
    
    if isempty(UserVar)
        
       %% 1-d flow-line geometry, unconfined ice shelf 
       % UserVar.RunType="Test-1dAnalyticalIceShelf-";           % numerical solution of a 1d unconfined ice shelf with automated remeshing
       
       %UserVar.RunType="Test-1dAnalyticalIceShelf-CalvingThroughMassBalanceFeedback-" ; 
       % UserVar.RunType="Test-1dAnalyticalIceShelf-CalvingThroughPrescribedLevelSet-" ; 
        
       %% MismipPlus geometry.
       % UserVar.RunType="Test-CalvingThroughMassBalanceFeedback-"; % MismipPlus: Calving using additional user defined mass-balance term (done in DefineMassBalance.m)
       % UserVar.RunType="Test-CalvingThroughPrescribedLevelSet-" ; % MismipPlus: Calving using prescribed ice/ocean mask (done in DefineCalving.m)
       UserVar.RunType="Test-ManuallyDeactivateElements-"       ; % MismipPlus: Calving using element deactivation (done in DefineElementsToDeactivate.m)
       UserVar.RunType="-1dAnalyticalIceShelf-"       ; % MismipPlus: Calving using element deactivation (done in DefineElementsToDeactivate.m) 
    end
    
    
    
    UserVar.InitialGeometry="-MismipPlus-" ;  % default)
    UserVar.Plots="-plot-mapplane-" ;
    UserVar.MassBalanceCase='ice0';  % this is used in DefineMassBalance, 'ice0' implies, ocean-induced melt set to zero (ie no melt)
    
    CtrlVar.AdaptMesh=1;
    CtrlVar.dt=0.01;
    CtrlVar.TriNodes=3;
    CtrlVar.TotalTime=5000;
    CtrlVar.TotalNumberOfForwardRunSteps=inf;
    CtrlVar.AdaptMeshMaxIterations=1;  % Number of adapt mesh iterations within each run-step.
    
    
    switch UserVar.RunType
        
        case {"-1dAnalyticalIceShelf-","Test-1dAnalyticalIceShelf-CalvingThroughMassBalanceFeedback-","Test-1dAnalyticalIceShelf-CalvingThroughPrescribedLevelSet-"}
            
            UserVar.InitialGeometry="-Constant-" ;
            CtrlVar.doplots=0;
            
            CtrlVar.TotalNumberOfForwardRunSteps=100;
            CtrlVar.TotalTime=100;
            UserVar.Plots="-plot-flowline-";
            CtrlVar.DefineOutputsDt=1;
            CtrlVar.MassBalanceGeometryFeedback=3;
            
            if contains(UserVar.RunType,"LevelSet-")
                CtrlVar.LevelSetMethod=1;
            end
            
        case "Test-ManuallyDeactivateElements-"
            % This is an example of how manual deactivation of elements can be used to simulate a
            % calving event.

            CtrlVar.ManuallyDeactivateElements=1 ;
            UserVar.InitialGeometry="-MismipPlus-" ;


            CtrlVar.doplots=1;
            
            CtrlVar.TotalNumberOfForwardRunSteps=100;
            CtrlVar.TotalTime=10;
            UserVar.Plots="-plot-mapplane-" ;
            CtrlVar.DefineOutputsDt=0.1;
            
        case "Test-CalvingThroughMassBalanceFeedback-"
            
            % Here a fictitious basal melt distribution is applied over the ice shelf downstream
            % of x=400km for the first few years to melt away all/most floating ice.
            %
            % The melt is prescribed as a function of ice thickness and to speed things up
            % the mass-balance feedback is provided here as well. This requires setting
            %
            %   CtrlVar.MassBalanceGeometryFeedback=3;
            %
            % The mass-balance is defined in DefineMassBalance.m
            
            CtrlVar.MassBalanceGeometryFeedback=3;


            UserVar.InitialGeometry="-MismipPlus-" ;
            CtrlVar.doplots=1;
            CtrlVar.TotalNumberOfForwardRunSteps=inf;
            CtrlVar.TotalTime=100;
            UserVar.Plots="-plot-mapplane-" ;
            CtrlVar.DefineOutputsDt=1;
            
         case "Test-CalvingThroughPrescribedLevelSet-"    
             
            % Here the MismipPlus geometry is used again, but now with the calving realized by prescribing a level-set function, done in
            % DefineCalving.m
            CtrlVar.LevelSetMethod=1;

            UserVar.InitialGeometry="-MismipPlus-" ;
            
            CtrlVar.doplots=1;
            CtrlVar.TotalNumberOfForwardRunSteps=100;
            CtrlVar.TotalTime=100;
            UserVar.Plots="-plot-mapplane-" ;
            CtrlVar.DefineOutputsDt=1;
            
            CtrlVar.MeshAdapt.CFrange=[10e3 1e3 ] ; % This refines the mesh around the
            % calving front. This kind or calving front remeshing is only possible when
            % using the LevelSetMethod.
           
    end
    
    
    % if CtrlVar.LevelSetMethod=, then these level-set parameters are relevant and need to be defined.
                                                           % When using the LSF option the ice is removed/calved through melting.
                                                           % The melt is decribed as a= a_1 (h-hmin)
    CtrlVar.LevelSetMethodMassBalanceFeedbackCoeffLin=-1;  % This is the constant a1, it has units 1/time.  
                                                           % Default value is -1
    
    CtrlVar.LevelSetMinIceThickness=CtrlVar.ThickMin;    % this is the hmin constant, i.e. the accepted min ice thickness 
                                                           % over the 'ice-free' areas. 
                                                           % Default value is CtrlVar.ThickMin
    
                                                           
                                                           
                                                           
    CtrlVar.InfoLevelNonLinIt=1; CtrlVar.uvhMinimisationQuantity="Force Residuals";
    %%
    
    UserVar.Outputsdirectory='ResultsFiles'; % This I use in DefineOutputs
    
    
    %%
    
    
    
    %% Types of run
    %
    CtrlVar.TimeDependentRun=1;
    CtrlVar.time=0;
    
    CtrlVar.ATSdtMax=10;
    CtrlVar.ATSdtMin=0.001;
    
    CtrlVar.WriteRestartFile=1;
    
    %% Reading in mesh
    CtrlVar.ReadInitialMesh=0;    % if true then read FE mesh (i.e the MUA variable) directly from a .mat file
    % unless the adaptive meshing option is used, no further meshing is done.
    % CtrlVar.ReadInitialMeshFileName='AdaptMesh.mat';
    % CtrlVar.SaveInitialMeshFileName='NewMeshFile.mat';
    %% Plotting options
    CtrlVar.PlotMesh=1;
    CtrlVar.PlotBCs=1;
    CtrlVar.WhenPlottingMesh_PlotMeshBoundaryCoordinatesToo=0;
    
    CtrlVar.PlotXYscale=1000;
    %%
    
    
    
    
    %% adapt mesh
    
    
    CtrlVar.MeshGenerator='mesh2d'   ;   % 'gmsh';  % possible values: {mesh2d|gmsh}
    CtrlVar.MeshSize=10e3;       % over-all desired element size
    CtrlVar.MeshSizeMax=10e3;    % max element size
    CtrlVar.MeshSizeMin=0.01*CtrlVar.MeshSize;     % min element size
    
    CtrlVar.MaxNumberOfElements=250e3;           % max number of elements. If #elements larger then CtrlMeshSize/min/max are changed
    
    CtrlVar.AdaptMeshRunStepInterval=1;  % number of run-steps between mesh adaptation
    CtrlVar.AdaptMeshUntilChangeInNumberOfElementsLessThan=5;
    CtrlVar.MeshRefinementMethod='explicit:local:newest vertex bisection';    % can have any of these values:
    % 'explicit:global'
    % 'explicit:local'
    % 'explicit:local:red-green'
    % 'explicit:local:newest vertex bisection';
    %
    CtrlVar.SaveAdaptMeshFileName=[] ; % no file written if left empty "AdaptMesh"+CtrlVar.Experiment+".mat";
    CtrlVar.AdaptMeshAndThenStop=0;    % if true, then mesh will be adapted but no further calculations performed
    % usefull, for example, when trying out different remeshing options (then use CtrlVar.doRemeshPlots=1 to get plots)
    
    
    CtrlVar.MeshAdapt.GLrange=[20000 5000 ; 5000 2000];
    
    
    if contains(UserVar.RunType,"-1dIceShelf-") || contains(UserVar.RunType,"-1dAnalyticalIceShelf-")
        I=1;
        CtrlVar.ExplicitMeshRefinementCriteria(I).Name='effective strain rates gradient';
        CtrlVar.ExplicitMeshRefinementCriteria(I).Scale=0.001/1000;
        CtrlVar.ExplicitMeshRefinementCriteria(I).EleMin=[];
        CtrlVar.ExplicitMeshRefinementCriteria(I).EleMax=[];
        CtrlVar.ExplicitMeshRefinementCriteria(I).p=1;
        CtrlVar.ExplicitMeshRefinementCriteria(I).InfoLevel=1;
        CtrlVar.ExplicitMeshRefinementCriteria(I).Use=true;
    end
    %% Pos. thickness constr
    
    
    CtrlVar.ThickMin=1; % minimum allowed thickness without (potentially) doing something about it
    CtrlVar.ResetThicknessToMinThickness=0;  % if true, thickness values less than ThickMin will be set to ThickMin
    CtrlVar.ThicknessConstraints=1  ;        % if true, min thickness is enforced using active set method
    CtrlVar.ThicknessConstraintsItMax=0  ;
    
    %% MeshBoundaryCoordinates
    
    if contains(UserVar.RunType,"-1dAnalyticalIceShelf-")
        xd=640e3; xu=0e3 ; yr=-10e3 ; yl=10e3 ;
    else
        xd=640e3; xu=0e3 ; yr=0 ; yl=80e3 ;
    end
    
    MeshBoundaryCoordinates=[xu yr ; xu yl ; xd yl ; xd yr];
    
    
    
    
    %% Experiment and file name
    
    CtrlVar.Experiment="Ex"+UserVar.RunType+"-MB"+UserVar.MassBalanceCase+"-Adapt"+num2str(CtrlVar.AdaptMesh);
    CtrlVar.Experiment=replace(CtrlVar.Experiment,"--","-");
    CtrlVar.NameOfRestartFiletoWrite="Restart"+CtrlVar.Experiment+".mat";
    CtrlVar.NameOfRestartFiletoRead=CtrlVar.NameOfRestartFiletoWrite;
    
    
    
end

