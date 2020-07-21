
function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)
    
    %%
    %
    % Calving using the level-set method is (currenlty) not implemented.
    %
    % To describe/prescribe calving various other options are available.
    %
    % For example elements can be deactivated and then reactivated to simulate a calving
    % event.
    %
    % Also, calving can be prescribed using a melt pertubation with a thickness feedback. 
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
    %  https://livenorthumbriaac-my.sharepoint.com/:f:/g/personal/hilmar_gudmundsson_northumbria_ac_uk/EgrEImnkQuJNmf1GEB80VbwB1hgKNnRMscUitVpBrghjRg
    %%
    
    if isempty(UserVar)
        
        UserVar.RunType="Test-1dAnalyticalIceShelf-";           % numerical solution of a 1d unconfined ice shelf with automated remeshing
        
        % UserVar.RunType="Test-ManuallyDeactivateElements-" ;  % Example of prescribed
        % calving using element deactivation.
        
        % UserVar.RunType="Test-CalvingThroughMassBalanceFeedback-"; % Calving implemented as a melt pertubation 
        
    end
    
    
    CtrlVar.AdaptMesh=1;
    CtrlVar.dt=0.01;
    CtrlVar.TriNodes=3;
    UserVar.InitialGeometry="-MismipPlus-" ;  % default)
    UserVar.Plots="-plot-mapplane-" ;
    CtrlVar.TotalTime=5000;
    CtrlVar.TotalNumberOfForwardRunSteps=inf;
    CtrlVar.AdaptMeshMaxIterations=1;  % Number of adapt mesh iterations within each run-step.
    
    
    switch UserVar.RunType
        
        case {"-1dAnalyticalIceShelf-","Test-1dAnalyticalIceShelf-"}
            
            UserVar.InitialGeometry="-Constant-" ;
            CtrlVar.doplots=0;
            CtrlVar.LevelSetMethod=0;
            CtrlVar.TotalNumberOfForwardRunSteps=inf;
            CtrlVar.TotalTime=500;
            UserVar.Plots="-plot-flowline-";
            if contains(UserVar.RunType,"Test-")
                CtrlVar.TotalTime=100;
            end
            CtrlVar.DefineOutputsDt=1;
            
        case "Test-ManuallyDeactivateElements-"
            % This is an example of how manual deactivation of elements can be used to simulate a
            % calving event.
            
            UserVar.InitialGeometry="-MismipPlus-" ;
            CtrlVar.ManuallyDeactivateElements=1 ;
            CtrlVar.doplots=1;
            CtrlVar.LevelSetMethod=0;
            CtrlVar.TotalNumberOfForwardRunSteps=inf;
            CtrlVar.TotalTime=10;
            UserVar.Plots="-plot-mapplane-" ;
            CtrlVar.DefineOutputsDt=0;
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
            
            UserVar.InitialGeometry="-MismipPlus-" ;
            CtrlVar.MassBalanceGeometryFeedback=3;
            
            CtrlVar.doplots=1;
            CtrlVar.LevelSetMethod=0;
            CtrlVar.TotalNumberOfForwardRunSteps=inf;
            CtrlVar.TotalTime=10;
            UserVar.Plots="-plot-mapplane-" ;
            CtrlVar.DefineOutputsDt=0;
            
    end
    
    
    
    CtrlVar.InfoLevelNonLinIt=1; CtrlVar.uvhMinimisationQuantity="Force Residuals";
    %%
    
    UserVar.Outputsdirectory='ResultsFiles'; % This I use in DefineOutputs
    UserVar.MassBalanceCase='ice0';
    
    %%
    
    
    
    %% Types of run
    %
    CtrlVar.TimeDependentRun=1;
    CtrlVar.time=0;
    CtrlVar.ATSdtMax=1;
    CtrlVar.ATSdtMin=0.01;
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
    CtrlVar.ThicknessConstraintsItMax=5  ;
    
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

