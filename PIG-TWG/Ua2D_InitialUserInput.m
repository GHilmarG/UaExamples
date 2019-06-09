<<<<<<< HEAD
function [UserVar,CtrlVar,MeshBoundaryCoordinates]=Ua2D_InitialUserInput(UserVar,CtrlVar)


%% Select the type of run by uncommenting one of the following options:
UserVar.RunType='Inverse-MatOpt';
% UserVar.RunType='Inverse-ConjGrad';
% UserVar.RunType='Inverse-SteepestDesent';
% UserVar.RunType='Inverse-ConjGrad-FixPoint';
% UserVar.RunType='Forward-Diagnostic';
% UserVar.RunType='Forward-Transient';
% UserVar.RunType='TestingMeshOptions';
%%

%%
% This run requires some additional input files. They are too big to be kept on Github so you
% will have to get those separately. 
%
% You can get these files on OneDrive using the link: https://1drv.ms/f/s!Anaw0Iv-oEHTloRzWreBMDBFCJ0R4Q
% 
% Put the OneDrive folder `Interpolants' into you directory so that it can be reaced as ../Interpolants with respect to you rundirectory. 
%
%
UserVar.GeometryInterpolant='../Interpolants/Bedmap2GriddedInterpolantModifiedBathymetry.mat'; % this assumes you have downloaded the OneDrive folder `Interpolants'.
UserVar.DensityInterpolant='../Interpolants/DepthAveragedDensityGriddedInterpolant.mat';
UserVar.SurfaceVelocityInterpolant='../Interpolants/SurfVelMeasures990mInterpolants.mat';

UserVar.CFile='FC5kGrid_m3.mat'; UserVar.AFile='FA5kGrid_n3.mat';
UserVar.CFile='FC.mat'; UserVar.AFile='FA.mat';

if ~isfile(UserVar.GeometryInterpolant) || ~isfile(UserVar.DensityInterpolant) || ~isfile(UserVar.SurfaceVelocityInterpolant)
     
     fprintf('\n This run requires the additional input files: \n %s \n %s \n %s  \n \n',UserVar.GeometryInterpolant,UserVar.DensityInterpolant,UserVar.SurfaceVelocityInterpolant)
     fprintf('You can download these file from : https://1drv.ms/f/s!Anaw0Iv-oEHTloRzWreBMDBFCJ0R4Q \n')
     
end

%%

CtrlVar.Experiment=UserVar.RunType;

switch UserVar.RunType
    
    case {'Inverse-MatOpt','Inverse-ConjGrad','Inverse-MatOpt-FixPoint','Inverse-ConjGrad-FixPoint','Inverse-SteepestDesent'}
        
        CtrlVar.InverseRun=1;
        CtrlVar.Restart=0;
        CtrlVar.Inverse.InfoLevel=1;
        CtrlVar.InfoLevelNonLinIt=0;
        CtrlVar.InfoLevel=0;
        UserVar.Slipperiness.ReadFromFile=0;
        UserVar.AGlen.ReadFromFile=0;
        CtrlVar.ReadInitialMesh=1;
        CtrlVar.AdaptMesh=0;
        
        CtrlVar.Inverse.Iterations=5;
        CtrlVar.Inverse.InvertFor='logAGlenlogC' ; % {'C','logC','AGlen','logAGlen'}
        CtrlVar.Inverse.Regularize.Field=CtrlVar.Inverse.InvertFor;
        
        if contains(UserVar.RunType,'FixPoint')
            
            % FixPoint inversion is an ad-hoc method of estimating the gradient of the cost function with respect to C.
            % It can produce quite good estimates for C using just one or two inversion iterations, but then typically stagnates.
            % The FixPoint method can often be used right at the start of an inversion to get a reasonably good C estimate,
            % after which in a restart step one can switch to gradient calculation using adjoint 
            CtrlVar.Inverse.DataMisfit.GradientCalculation='FixPoint' ;
            CtrlVar.Inverse.InvertFor='logC' ;
            CtrlVar.Inverse.Iterations=1;
            CtrlVar.Inverse.Regularize.Field=CtrlVar.Inverse.InvertFor;
          
        end
        
        
    case 'Forward-Transient'
        
        CtrlVar.InverseRun=0;
        CtrlVar.TimeDependentRun=1;
        CtrlVar.Restart=1;
        CtrlVar.InfoLevelNonLinIt=1;
        UserVar.Slipperiness.ReadFromFile=1;
        UserVar.AGlen.ReadFromFile=0;
        CtrlVar.ReadInitialMesh=1;
        CtrlVar.AdaptMesh=0;
        
    case 'Forward-Diagnostic'
               
        CtrlVar.InverseRun=0;
        CtrlVar.TimeDependentRun=0;
        CtrlVar.Restart=1;
        CtrlVar.InfoLevelNonLinIt=1;
        UserVar.Slipperiness.ReadFromFile=1;
        UserVar.AGlen.ReadFromFile=0;
        CtrlVar.ReadInitialMesh=1;
        CtrlVar.AdaptMesh=0;
        
    case 'TestingMeshOptions'
        
        CtrlVar.TimeDependentRun=0;  % {0|1} if true (i.e. set to 1) then the run is a forward transient one, if not
        CtrlVar.InverseRun=0;
        CtrlVar.Restart=0;
        CtrlVar.ReadInitialMesh=0;
        CtrlVar.AdaptMesh=1;
        UserVar.Slipperiness.ReadFromFile=1;
        UserVar.AGlen.ReadFromFile=1;
        CtrlVar.AdaptMesh=1;
        CtrlVar.AdaptMeshInitial=1  ;       % remesh in first iteration (Itime=1)  even if mod(Itime,CtrlVar.AdaptMeshInterval)~=0.
        CtrlVar.AdaptMeshAndThenStop=1;    % if true, then mesh will be adapted but no further calculations performed
        % useful, for example, when trying out different remeshing options (then use CtrlVar.doAdaptMeshPlots=1 to get plots)
        CtrlVar.InfoLevelAdaptiveMeshing=10;
end


CtrlVar.dt=0.01;
CtrlVar.time=0;
CtrlVar.TotalNumberOfForwardRunSteps=1; 
CtrlVar.TotalTime=10;

% Element type
CtrlVar.TriNodes=3 ;


%%
CtrlVar.doplots=1;
CtrlVar.PlotMesh=0;  
CtrlVar.PlotBCs=1 ;
CtrlVar.PlotXYscale=1000;
CtrlVar.doAdaptMeshPlots=5; 
%%

CtrlVar.ReadInitialMeshFileName='PIG-TWG-Mesh.mat';
CtrlVar.SaveInitialMeshFileName='MeshFile.mat';
CtrlVar.MaxNumberOfElements=70e3;




%% Meshing 


CtrlVar.MeshRefinementMethod='explicit:local:newest vertex bisection';   
%CtrlVar.MeshRefinementMethod='explicit:local:red-green';
%CtrlVar.MeshRefinementMethod='explicit:global';   

CtrlVar.MeshGenerator='gmsh' ; % 'mesh2d';
CtrlVar.MeshGenerator='mesh2d' ; % 'mesh2d';
CtrlVar.GmshMeshingAlgorithm=8; 
CtrlVar.MeshSizeMax=20e3;
CtrlVar.MeshSize=CtrlVar.MeshSizeMax/2;
CtrlVar.MeshSizeMin=CtrlVar.MeshSizeMax/20;
UserVar.MeshSizeIceShelves=CtrlVar.MeshSizeMax/5;
MeshBoundaryCoordinates=CreateMeshBoundaryCoordinatesForPIGandTWG(CtrlVar);
                                         
CtrlVar.AdaptMeshInitial=1  ;       % remesh in first iteration (Itime=1)  even if mod(Itime,CtrlVar.AdaptMeshInterval)~=0.
CtrlVar.AdaptMeshAndThenStop=1;    % if true, then mesh will be adapted but no further calculations performed
                                   % useful, for example, when trying out different remeshing options (then use CtrlVar.doAdaptMeshPlots=1 to get plots)
CtrlVar.AdaptMeshMaxIterations=5;
CtrlVar.SaveAdaptMeshFileName='MeshFileAdapt';    %  file name for saving adapt mesh. If left empty, no file is written
CtrlVar.AdaptMeshInterval=1 ; % remesh whenever mod(Itime,CtrlVar.AdaptMeshInterval)==0



I=1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Name='effective strain rates';
CtrlVar.ExplicitMeshRefinementCriteria(I).Scale=0.001;
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMin=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMax=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).p=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).InfoLevel=1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Use=true;


I=I+1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Name='flotation';
CtrlVar.ExplicitMeshRefinementCriteria(I).Scale=0.0001;
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMin=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMax=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).p=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).InfoLevel=1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Use=false;

I=I+1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Name='thickness gradient';
CtrlVar.ExplicitMeshRefinementCriteria(I).Scale=0.01;
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMin=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMax=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).p=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).InfoLevel=1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Use=false;


I=I+1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Name='upper surface gradient';
CtrlVar.ExplicitMeshRefinementCriteria(I).Scale=0.01;
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMin=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMax=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).p=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).InfoLevel=1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Use=false;

%%
                                                        
%%  Bounds on C and AGlen
%CtrlVar.AGlenmin=1e-10; CtrlVar.AGlenmax=1e-5;
%CtrlVar.Cmin=1e-6;  CtrlVar.Cmax=1e20;        
%CtrlVar.CisElementBased=0;   
%CtrlVar.AGlenisElementBased=0;   


%% Testing adjoint parameters, start:
CtrlVar.Inverse.TestAdjoint.isTrue=0; % If true then perform a brute force calculation 
                                      % of the directional derivative of the objective function.  
CtrlVar.Inverse.TestAdjoint.FiniteDifferenceType='second-order' ; % {'central','forward'}
CtrlVar.Inverse.TestAdjoint.FiniteDifferenceStepSize=1e-8 ;
CtrlVar.Inverse.TestAdjoint.iRange=[100,121] ;  % range of nodes/elements over which brute force gradient is to be calculated.
                                         % if left empty, values are calulated for every node/element within the mesh. 
                                         % If set to for example [1,10,45] values are calculated for these three
                                         % nodes/elements.
% end, testing adjoint parameters. 


if contains(UserVar.RunType,'MatOpt')
    CtrlVar.Inverse.MinimisationMethod='MatlabOptimization';
else
    CtrlVar.Inverse.MinimisationMethod='UaOptimization';
    if contains(UserVar.RunType,'ConjGrad')
        CtrlVar.Inverse.GradientUpgradeMethod='ConjGrad' ; %{'SteepestDecent','ConjGrad'}
    else
        CtrlVar.Inverse.GradientUpgradeMethod='SteepestDecent' ; %{'SteepestDecent','ConjGrad'}
    end
    
end




CtrlVar.Inverse.AdjointGradientPreMultiplier='I'; % {'I','M'}


                                                    
UserVar.AddDataErrors=0;


CtrlVar.Inverse.Regularize.C.gs=1;
CtrlVar.Inverse.Regularize.C.ga=1;
CtrlVar.Inverse.Regularize.logC.ga=1;
CtrlVar.Inverse.Regularize.logC.gs=1e3 ;

CtrlVar.Inverse.Regularize.AGlen.gs=1;
CtrlVar.Inverse.Regularize.AGlen.ga=1;
CtrlVar.Inverse.Regularize.logAGlen.ga=1;
CtrlVar.Inverse.Regularize.logAGlen.gs=1e3 ;


%%
CtrlVar.ThicknessConstraints=0;
CtrlVar.ResetThicknessToMinThickness=1;  % change this later on
CtrlVar.ThickMin=50;

%%
filename=sprintf('IR-%s-%s-Nod%i-%s-%s-Cga%f-Cgs%f-Aga%f-Ags%f-%i-%i-%s',...
    UserVar.RunType,...
    CtrlVar.Inverse.MinimisationMethod,...
    CtrlVar.TriNodes,...
    CtrlVar.Inverse.AdjointGradientPreMultiplier,...
    CtrlVar.Inverse.DataMisfit.GradientCalculation,...
    CtrlVar.Inverse.Regularize.logC.ga,...
    CtrlVar.Inverse.Regularize.logC.gs,...
    CtrlVar.Inverse.Regularize.logAGlen.ga,...
    CtrlVar.Inverse.Regularize.logAGlen.gs,...
    CtrlVar.CisElementBased,...
    CtrlVar.AGlenisElementBased,...
    CtrlVar.Inverse.InvertFor);
filename=replace(filename,'.','k');
CtrlVar.Inverse.NameOfRestartOutputFile=filename;
CtrlVar.Inverse.NameOfRestartInputFile=CtrlVar.Inverse.NameOfRestartOutputFile;

end
=======
function [UserVar,CtrlVar,MeshBoundaryCoordinates]=Ua2D_InitialUserInput(UserVar,CtrlVar)


%% Select the type of run by uncommenting one of the following options:
if ~isfield(UserVar,'RunType')
    % UserVar.RunType='Inverse-MatOpt';
    % UserVar.RunType='Inverse-ConjGrad';
    % UserVar.RunType='Inverse-SteepestDesent';
    % UserVar.RunType='Inverse-ConjGrad-FixPoint';
    % UserVar.RunType='Forward-Diagnostic';
    % UserVar.RunType='Forward-Transient';
    % UserVar.RunType='TestingMeshOptions';
end
%%

%%
% This run requires some additional input files. They are too big to be kept on Github so you
% will have to get those separately. 
%
% You can get these files on OneDrive using the link: https://1drv.ms/f/s!Anaw0Iv-oEHTloRzWreBMDBFCJ0R4Q
% 
% Put the OneDrive folder `Interpolants' into you directory so that it can be reaced as ../Interpolants with respect to you rundirectory. 
%
UserVar.GeometryInterpolant='../Interpolants/Bedmap2GriddedInterpolantModifiedBathymetry'; % this assumes you have downloaded the OneDrive folder `Interpolants'.
UserVar.DensityInterpolant='../Interpolants/DepthAveragedDensityGriddedInterpolant.mat';
UserVar.SurfaceVelocityInterpolant='../Interpolants/SurfVelMeasures990mInterpolants';

UserVar.CFile='FC5kGrid_m3.mat'; UserVar.AFile='FA5kGrid_n3.mat';
UserVar.CFile='FC.mat'; UserVar.AFile='FA.mat';



%%

CtrlVar.Experiment=UserVar.RunType;

switch UserVar.RunType
    
    case {'Inverse-MatOpt','Inverse-ConjGrad','Inverse-MatOpt-FixPoint','Inverse-ConjGrad-FixPoint','Inverse-SteepestDesent'}
        
        CtrlVar.InverseRun=1;
        CtrlVar.Restart=0;
        CtrlVar.Inverse.InfoLevel=1;
        CtrlVar.InfoLevelNonLinIt=0;
        CtrlVar.InfoLevel=0;
        UserVar.Slipperiness.ReadFromFile=0;
        UserVar.AGlen.ReadFromFile=0;
        CtrlVar.ReadInitialMesh=1;
        CtrlVar.AdaptMesh=0;
        
        CtrlVar.Inverse.Iterations=5;
        CtrlVar.Inverse.InvertFor='logAGlenlogC' ; % {'C','logC','AGlen','logAGlen'}
        CtrlVar.Inverse.Regularize.Field=CtrlVar.Inverse.InvertFor;
        
        if contains(UserVar.RunType,'FixPoint')
            
            % FixPoint inversion is an ad-hoc method of estimating the gradient of the cost function with respect to C.
            % It can produce quite good estimates for C using just one or two inversion iterations, but then typically stagnates.
            % The FixPoint method can often be used right at the start of an inversion to get a reasonably good C estimate,
            % after which in a restart step one can switch to gradient calculation using adjoint 
            CtrlVar.Inverse.DataMisfit.GradientCalculation='FixPoint' ;
            CtrlVar.Inverse.InvertFor='logC' ;
            CtrlVar.Inverse.Iterations=1;
            CtrlVar.Inverse.Regularize.Field=CtrlVar.Inverse.InvertFor;
          
        end
        
        
    case 'Forward-Transient'
        
        CtrlVar.InverseRun=0;
        CtrlVar.TimeDependentRun=1;
        CtrlVar.Restart=1;
        CtrlVar.InfoLevelNonLinIt=1;
        UserVar.Slipperiness.ReadFromFile=1;
        UserVar.AGlen.ReadFromFile=0;
        CtrlVar.ReadInitialMesh=1;
        CtrlVar.AdaptMesh=0;
        
    case 'Forward-Diagnostic'
               
        CtrlVar.InverseRun=0;
        CtrlVar.TimeDependentRun=0;
        CtrlVar.Restart=1;
        CtrlVar.InfoLevelNonLinIt=1;
        UserVar.Slipperiness.ReadFromFile=1;
        UserVar.AGlen.ReadFromFile=0;
        CtrlVar.ReadInitialMesh=1;
        CtrlVar.AdaptMesh=0;
        
    case 'TestingMeshOptions'
        
        CtrlVar.TimeDependentRun=0;  % {0|1} if true (i.e. set to 1) then the run is a forward transient one, if not
        CtrlVar.InverseRun=0;
        CtrlVar.Restart=0;
        CtrlVar.ReadInitialMesh=0;
        CtrlVar.AdaptMesh=1;
        UserVar.Slipperiness.ReadFromFile=1;
        UserVar.AGlen.ReadFromFile=1;
        CtrlVar.AdaptMesh=1;
        CtrlVar.AdaptMeshInitial=1  ;       % remesh in first iteration (Itime=1)  even if mod(Itime,CtrlVar.AdaptMeshInterval)~=0.
        CtrlVar.AdaptMeshAndThenStop=1;    % if true, then mesh will be adapted but no further calculations performed
        % useful, for example, when trying out different remeshing options (then use CtrlVar.doAdaptMeshPlots=1 to get plots)
        CtrlVar.InfoLevelAdaptiveMeshing=10;
end


CtrlVar.dt=0.01;
CtrlVar.time=0;
CtrlVar.TotalNumberOfForwardRunSteps=1; 
CtrlVar.TotalTime=10;

% Element type
CtrlVar.TriNodes=3 ;


%%
CtrlVar.doplots=1;
CtrlVar.PlotMesh=0;  
CtrlVar.PlotBCs=1 ;
CtrlVar.PlotXYscale=1000;
CtrlVar.doAdaptMeshPlots=5; 
%%

CtrlVar.ReadInitialMeshFileName='PIG-TWG-Mesh.mat';
CtrlVar.SaveInitialMeshFileName='MeshFile.mat';
CtrlVar.MaxNumberOfElements=70e3;




%% Meshing 


CtrlVar.MeshRefinementMethod='explicit:local:newest vertex bisection';   
%CtrlVar.MeshRefinementMethod='explicit:local:red-green';
%CtrlVar.MeshRefinementMethod='explicit:global';   

CtrlVar.MeshGenerator='gmsh' ; % 'mesh2d';
CtrlVar.MeshGenerator='mesh2d' ; % 'mesh2d';
CtrlVar.GmshMeshingAlgorithm=8; 
CtrlVar.MeshSizeMax=20e3;
CtrlVar.MeshSize=CtrlVar.MeshSizeMax/2;
CtrlVar.MeshSizeMin=CtrlVar.MeshSizeMax/20;
UserVar.MeshSizeIceShelves=CtrlVar.MeshSizeMax/5;
MeshBoundaryCoordinates=CreateMeshBoundaryCoordinatesForPIGandTWG(CtrlVar);
                                         
CtrlVar.AdaptMeshInitial=1  ;       % remesh in first iteration (Itime=1)  even if mod(Itime,CtrlVar.AdaptMeshInterval)~=0.
CtrlVar.AdaptMeshAndThenStop=1;    % if true, then mesh will be adapted but no further calculations performed
                                   % useful, for example, when trying out different remeshing options (then use CtrlVar.doAdaptMeshPlots=1 to get plots)
CtrlVar.AdaptMeshMaxIterations=5;
CtrlVar.SaveAdaptMeshFileName='MeshFileAdapt';    %  file name for saving adapt mesh. If left empty, no file is written
CtrlVar.AdaptMeshInterval=1 ; % remesh whenever mod(Itime,CtrlVar.AdaptMeshInterval)==0



I=1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Name='effective strain rates';
CtrlVar.ExplicitMeshRefinementCriteria(I).Scale=0.001;
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMin=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMax=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).p=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).InfoLevel=1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Use=true;


I=I+1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Name='flotation';
CtrlVar.ExplicitMeshRefinementCriteria(I).Scale=0.0001;
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMin=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMax=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).p=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).InfoLevel=1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Use=false;

I=I+1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Name='thickness gradient';
CtrlVar.ExplicitMeshRefinementCriteria(I).Scale=0.01;
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMin=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMax=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).p=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).InfoLevel=1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Use=false;


I=I+1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Name='upper surface gradient';
CtrlVar.ExplicitMeshRefinementCriteria(I).Scale=0.01;
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMin=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMax=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).p=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).InfoLevel=1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Use=false;

%%
                                                        
%%  Bounds on C and AGlen
%CtrlVar.AGlenmin=1e-10; CtrlVar.AGlenmax=1e-5;
%CtrlVar.Cmin=1e-6;  CtrlVar.Cmax=1e20;        
%CtrlVar.CisElementBased=0;   
%CtrlVar.AGlenisElementBased=0;   


%% Testing adjoint parameters, start:
CtrlVar.Inverse.TestAdjoint.isTrue=0; % If true then perform a brute force calculation 
                                      % of the directional derivative of the objective function.  
CtrlVar.Inverse.TestAdjoint.FiniteDifferenceType='second-order' ; % {'central','forward'}
CtrlVar.Inverse.TestAdjoint.FiniteDifferenceStepSize=1e-8 ;
CtrlVar.Inverse.TestAdjoint.iRange=[100,121] ;  % range of nodes/elements over which brute force gradient is to be calculated.
                                         % if left empty, values are calulated for every node/element within the mesh. 
                                         % If set to for example [1,10,45] values are calculated for these three
                                         % nodes/elements.
% end, testing adjoint parameters. 


if contains(UserVar.RunType,'MatOpt')
    CtrlVar.Inverse.MinimisationMethod='MatlabOptimization';
else
    CtrlVar.Inverse.MinimisationMethod='UaOptimization';
    if contains(UserVar.RunType,'ConjGrad')
        CtrlVar.Inverse.GradientUpgradeMethod='ConjGrad' ; %{'SteepestDecent','ConjGrad'}
    else
        CtrlVar.Inverse.GradientUpgradeMethod='SteepestDecent' ; %{'SteepestDecent','ConjGrad'}
    end
    
end




CtrlVar.Inverse.AdjointGradientPreMultiplier='I'; % {'I','M'}


                                                    
UserVar.AddDataErrors=0;


CtrlVar.Inverse.Regularize.C.gs=1;
CtrlVar.Inverse.Regularize.C.ga=1;
CtrlVar.Inverse.Regularize.logC.ga=1;
CtrlVar.Inverse.Regularize.logC.gs=1e3 ;

CtrlVar.Inverse.Regularize.AGlen.gs=1;
CtrlVar.Inverse.Regularize.AGlen.ga=1;
CtrlVar.Inverse.Regularize.logAGlen.ga=1;
CtrlVar.Inverse.Regularize.logAGlen.gs=1e3 ;


%%
CtrlVar.ThicknessConstraints=0;
CtrlVar.ResetThicknessToMinThickness=1;  % change this later on
CtrlVar.ThickMin=50;

%%
filename=sprintf('IR-%s-%s-Nod%i-%s-%s-Cga%f-Cgs%f-Aga%f-Ags%f-%i-%i-%s',...
    UserVar.RunType,...
    CtrlVar.Inverse.MinimisationMethod,...
    CtrlVar.TriNodes,...
    CtrlVar.Inverse.AdjointGradientPreMultiplier,...
    CtrlVar.Inverse.DataMisfit.GradientCalculation,...
    CtrlVar.Inverse.Regularize.logC.ga,...
    CtrlVar.Inverse.Regularize.logC.gs,...
    CtrlVar.Inverse.Regularize.logAGlen.ga,...
    CtrlVar.Inverse.Regularize.logAGlen.gs,...
    CtrlVar.CisElementBased,...
    CtrlVar.AGlenisElementBased,...
    CtrlVar.Inverse.InvertFor);
filename=replace(filename,'.','k');
CtrlVar.Inverse.NameOfRestartOutputFile=filename;
CtrlVar.Inverse.NameOfRestartInputFile=CtrlVar.Inverse.NameOfRestartOutputFile;

end
>>>>>>> development
