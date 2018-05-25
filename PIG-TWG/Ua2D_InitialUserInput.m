function [UserVar,CtrlVar,MeshBoundaryCoordinates]=Ua2D_InitialUserInput(UserVar,CtrlVar)


UserVar.RunType='Inverse-MatOpt';
%UserVar.RunType='Inverse-ConjGrad';
%UserVar.RunType='Forward-Diagnostic';
%UserVar.RunType='Forward-Transient';


UserVar.GeometryInterpolant='../Interpolants/Bedmap2GriddedInterpolantModifiedBathymetry';
UserVar.DensityInterpolant='../Interpolants/DepthAveragedDensityGriddedInterpolant.mat';
UserVar.SurfaceVelocityInterpolant='../Interpolants/SurfVelMeasures990mInterpolants';

UserVar.CFile='FC5kGrid_m3.mat'; UserVar.AFile='FA5kGrid_n3.mat';
UserVar.CFile='FC.mat'; UserVar.AFile='FA.mat';



%%

CtrlVar.Experiment=UserVar.RunType;




if contains(UserVar.RunType,'Inverse')
    CtrlVar.InverseRun=1;
    CtrlVar.Restart=0;
    CtrlVar.Inverse.InfoLevel=1;
    CtrlVar.InfoLevelNonLinIt=0;
    CtrlVar.InfoLevel=0;
    UserVar.Slipperiness.ReadFromFile=0;
    UserVar.AGlen.ReadFromFile=0;
    
else
    
    CtrlVar.InverseRun=0;
    if contains(UserVar.RunType,'Transient')
        CtrlVar.TimeDependentRun=1;
    else
        CtrlVar.TimeDependentRun=0;
    end
    
    CtrlVar.Restart=1;
    CtrlVar.InfoLevelNonLinIt=1;
    UserVar.Slipperiness.ReadFromFile=1;
    UserVar.AGlen.ReadFromFile=0;
    
end


CtrlVar.ReadInitialMesh=1;
CtrlVar.AdaptMesh=0;
CtrlVar.dt=0.01;
CtrlVar.time=0;
CtrlVar.ResetTimeStep=0; 
CtrlVar.TotalNumberOfForwardRunSteps=1; 
CtrlVar.TotalTime=10;

%
CtrlVar.TriNodes=3 ;
CtrlVar.ATStimeStepTarget=0.1; CtrlVar.ATSTargetIterations=4;


%%
CtrlVar.doplots=1;
CtrlVar.PlotMesh=0;  CtrlVar.PlotBCs=1 ;
%%


CtrlVar.MeshSizeMax=20e3;
CtrlVar.MeshSize=CtrlVar.MeshSizeMax/2;
CtrlVar.MeshSizeMin=CtrlVar.MeshSizeMax/10;
CtrlVar.MeshSizeFastFlow=CtrlVar.MeshSizeMax/5;
CtrlVar.MeshSizeIceShelves=CtrlVar.MeshSizeMax/10;
CtrlVar.MeshSizeBoundary=CtrlVar.MeshSize;


MeshBoundaryCoordinates=CreateMeshBoundaryCoordinatesForPIGandTWG(CtrlVar);

CtrlVar.ReadInitialMeshFileName='PIG-TWG-Mesh.mat';
CtrlVar.SaveInitialMeshFileName='MeshFile.mat';

CtrlVar.OnlyMeshDomainAndThenStop=0; % if true then only meshing is done and no further calculations. Usefull for checking if mesh is reasonable
CtrlVar.MaxNumberOfElements=70e3;


%% plotting
CtrlVar.PlotXYscale=1000;



%% adapt mesh


CtrlVar.MeshRefinementMethod='explicit:global';    % can have any of these values:
                                                   % 'explicit:global'
                                                   % 'explicit:local'
                                                   % 'implicit:global'  (broken at the moment, do not use)
                                                   % 'implicit:local'   (broken at the moment, do not use)

CtrlVar.InfoLevelAdaptiveMeshing=10;                                            
CtrlVar.AdaptMeshInitial=1  ; % remesh in first iteration (Itime=1)  even if mod(Itime,CtrlVar.AdaptMeshInterval)~=0.
CtrlVar.AdaptMeshAndThenStop=0;    % if true, then mesh will be adapted but no further calculations performed
                                   % useful, for example, when trying out different remeshing options (then use CtrlVar.doAdaptMeshPlots=1 to get plots)
%CtrlVar.MeshRefinementMethod='explicit:local';
CtrlVar.AdaptMeshMaxIterations=1;
CtrlVar.SaveAdaptMeshFileName='MeshFileAdapt';    %  file name for saving adapt mesh. If left empty, no file is written
CtrlVar.AdaptMeshInterval=10 ; % remesh whenever mod(Itime,CtrlVar.AdaptMeshInterval)==0
CtrlVar.doAdaptMeshPlots=1; 


                                                        
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

CtrlVar.Inverse.Iterations=5;
CtrlVar.Inverse.InvertFor='logAGlenlogC' ; % {'C','logC','AGlen','logAGlen'}
CtrlVar.Inverse.Regularize.Field=CtrlVar.Inverse.InvertFor;

CtrlVar.Inverse.DataMisfit.GradientCalculation='Adjoint' ; % {'Adjoint','FixPointC'}
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
