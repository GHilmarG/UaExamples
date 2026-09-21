
function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)




%% Select the type of run by uncommenting one of the following options:

if isempty(UserVar) || ~isfield(UserVar,'RunType')
    
    UserVar.RunType='Inverse-MatOpt';
    UserVar.RunType='Forward-Diagnostic';
    UserVar.RunType='Forward-Transient';
    % UserVar.RunType='TestingMeshOptions';

end

if isempty(UserVar) || ~isfield(UserVar,'m')
    UserVar.m=3;
end



%%
% This run requires some additional input files. They are too big to be kept on Github so you
% will have to get those separately. 
%
% You can find those at: https://livenorthumbriaac-my.sharepoint.com/:f:/g/personal/hilmar_gudmundsson_northumbria_ac_uk/EgrEImnkQuJNmf1GEB80VbwB1hgKNnRMscUitVpBrghjRg?e=yMZEOs
% 
% Put the OneDrive folder `Interpolants' into you directory so that it can be reached as ../Interpolants with respect to you rundirectory. 
%
%


% Interpolant paths: this assumes you have downloaded the OneDrive folder `Interpolants'.
% UserVar.GeometryInterpolant='../../Interpolants/Bedmap2GriddedInterpolantModifiedBathymetry.mat';
UserVar.GeometryInterpolant='../../Interpolants/BedMachineGriddedInterpolants.mat';                       
UserVar.SurfaceVelocityInterpolant='../../Interpolants/SurfVelMeasures990mInterpolants.mat';
UserVar.MeshBoundaryCoordinatesFile='../../Interpolants/MeshBoundaryCoordinatesForAntarcticaBasedOnBedmachine'; 
UserVar.DistanceBetweenPointsAlongBoundary=5e3 ; 

CtrlVar.SlidingLaw="Weertman" ; % "Umbi" ; % "Weertman" ; % "Tsai" ; % "Cornford" ;  "Umbi" ; "Cornford" ; % "Tsai" , "Budd"

switch CtrlVar.SlidingLaw
    
    case "Weertman"
        UserVar.CFile='FC-Weertman.mat'; UserVar.AFile='FA-Weertman.mat';
    case "Umbi"
        UserVar.CFile='FC-Umbi.mat'; UserVar.AFile='FA-Umbi.mat';
    otherwise
        error('A and C fields not available')
end


if ~isfile(UserVar.GeometryInterpolant) || ~isfile(UserVar.SurfaceVelocityInterpolant)
     
     fprintf('\n This run requires the additional input files: \n %s \n %s \n %s  \n \n',UserVar.GeometryInterpolant,UserVar.DensityInterpolant,UserVar.SurfaceVelocityInterpolant)
     fprintf('You can download these file from : https://1drv.ms/f/s!Anaw0Iv-oEHTloRzWreBMDBFCJ0R4Q \n')
     
end

%%

CtrlVar.Experiment=UserVar.RunType;

if contains(UserVar.RunType,"Inverse")

   % case {'Inverse-MatOpt','Inverse-ConjGrad','Inverse-MatOpt-FixPoint','Inverse-ConjGrad-FixPoint','Inverse-SteepestDesent','Inverse-UaOpt','Inverse-UaOptConjGrad'}
        
        CtrlVar.InverseRun=1;
        CtrlVar.Restart=0;
        
        CtrlVar.InfoLevelNonLinIt=0;
        CtrlVar.Inverse.InfoLevel=1;
        CtrlVar.InfoLevel=0;

        UserVar.Slipperiness.ReadFromFile=0;
        UserVar.AGlen.ReadFromFile=0;
        CtrlVar.ReadInitialMesh=1;
        CtrlVar.AdaptMesh=0;

        CtrlVar.Inverse.Iterations=10;
        CtrlVar.Inverse.InvertFor='logA-logC' ; %
        CtrlVar.Inverse.Regularize.Field=CtrlVar.Inverse.InvertFor;

        CtrlVar.Inverse.Measurements='-uv-' ;  % {'-uv-,'-uv-dhdt-','-dhdt-'}


        if contains(UserVar.RunType,"-UaOptimisation-GradientBased-")

            CtrlVar.Inverse.MinimisationMethod="-UaOptimisation-GradientBased-";

        elseif contains(UserVar.RunType,"MatlabOptimisation-GradientBased-")

            CtrlVar.Inverse.MinimisationMethod="-MatlabOptimisation-GradientBased-";

        elseif contains(UserVar.RunType,"-MatlabOptimisation-HessianBased-")

            CtrlVar.Inverse.MinimisationMethod="-MatlabOptimisation-HessianBased-";
            CtrlVar.Inverse.Hessian="-Jpp-Fpp-";

        elseif contains(UserVar.RunType,"-UaOptimisation-HessianBased-")

            CtrlVar.Inverse.MinimisationMethod="-UaOptimisation-HessianBased-";
            CtrlVar.Inverse.Hessian="-Jpp-Fpp-";

        else
            error("CaseNotFound")

        end


elseif contains(UserVar.RunType,"Forward-Transient")

        
        CtrlVar.InverseRun=0;
        CtrlVar.TimeDependentRun=1;
        CtrlVar.Restart=0;
        CtrlVar.InfoLevelNonLinIt=1;
        UserVar.Slipperiness.ReadFromFile=1;
        UserVar.AGlen.ReadFromFile=1;
        CtrlVar.ReadInitialMesh=1;
        CtrlVar.AdaptMesh=0;

elseif contains(UserVar.RunType,"Forward-Diagnostic") 

        CtrlVar.InverseRun=0;
        CtrlVar.TimeDependentRun=0;
        CtrlVar.Restart=0;
        CtrlVar.InfoLevelNonLinIt=1;
        UserVar.Slipperiness.ReadFromFile=1;
        UserVar.AGlen.ReadFromFile=1;
        CtrlVar.ReadInitialMesh=1;
        CtrlVar.AdaptMesh=0;

elseif contains(UserVar.RunType,"TestingMeshOptions")

       
        CtrlVar.TimeDependentRun=0;  % {0|1} if true (i.e. set to 1) then the run is a forward transient one, if not
        CtrlVar.InverseRun=0;
        CtrlVar.Restart=0;
        CtrlVar.ReadInitialMesh=0;
        CtrlVar.AdaptMesh=1;        UserVar.Slipperiness.ReadFromFile=1;
        UserVar.Slipperiness.ReadFromFile=1;
        UserVar.AGlen.ReadFromFile=1;
        CtrlVar.AdaptMesh=1;
        CtrlVar.AdaptMeshInitial=1  ;      
        CtrlVar.AdaptMeshRunStepInterval=1 ; 
        CtrlVar.AdaptMeshAndThenStop=1;    % if true, then mesh will be adapted but no further calculations performed
        % useful, for example, when trying out different remeshing options (then use CtrlVar.doAdaptMeshPlots=1 to get plots)
        CtrlVar.InfoLevelAdaptiveMeshing=10;

else
    error("CaseNotFound")
end


CtrlVar.dt=1e-5; CtrlVar.dtmin=1e-7;  
CtrlVar.StartTime=0;
CtrlVar.EndTime=500;
CtrlVar.TotalNumberOfForwardRunSteps=inf; 


% time interval between calls to DefineOutputs.m
CtrlVar.DefineOutputsDt=50; 
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
CtrlVar.ReadInitialMeshFileName='PIG-TWG-Mesh-withThwaitesIceshelfWestDeleted.mat';
CtrlVar.SaveInitialMeshFileName='MeshFile.mat';
CtrlVar.MaxNumberOfElements=70e3;




%% Meshing 


CtrlVar.MeshRefinementMethod='explicit:local:newest vertex bisection';   
%CtrlVar.MeshRefinementMethod='explicit:local:red-green';
% CtrlVar.MeshRefinementMethod='explicit:global';   
CtrlVar.MeshGenerator='mesh2d' ; % 'mesh2d';
CtrlVar.MeshSizeMax=20e3;
CtrlVar.MeshSize=CtrlVar.MeshSizeMax/2;
CtrlVar.MeshSizeMin=CtrlVar.MeshSizeMax/20;
UserVar.MeshSizeIceShelves=CtrlVar.MeshSizeMax/5;
MeshBoundaryCoordinates=CreateMeshBoundaryCoordinatesForPIGandTWG(UserVar,CtrlVar);
                                         
CtrlVar.AdaptMeshInitial=1  ;   
CtrlVar.AdaptMeshMaxIterations=5;
CtrlVar.SaveAdaptMeshFileName='MeshFileAdapt';    %  file name for saving adapt mesh. If left empty, no file is written


I=1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Name='effective strain rates';
CtrlVar.ExplicitMeshRefinementCriteria(I).Scale=0.001;
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMin=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMax=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).p=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).InfoLevel=1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Use=true;



%%
                                                        
%%  Bounds on C and AGlen
%CtrlVar.AGlenmin=1e-10; CtrlVar.AGlenmax=1e-5;

CtrlVar.Cmin=1e-20;  CtrlVar.Cmax=1e20;        

%CtrlVar.CisElementBased=0;   
%CtrlVar.AGlenisElementBased=0;   


%% Testing adjoint parameters, start:
 % If true then perform a brute force calculation 
                                      % of the directional derivative of the objective function.  
CtrlVar.Inverse.TestAdjointFiniteDifferenceType='second-order' ; % {'central','forward'}
CtrlVar.Inverse.TestAdjointFiniteDifferenceStepSize=1e-8 ;
CtrlVar.Inverse.TestAdjoint.iRange=[] ;  % range of nodes/elements over which brute force gradient is to be calculated.
                                         % if left empty, values are calculated fro 20 random nodes
                                         % If set to for example [1,10,45] values are calculated for these three
                                         % nodes/elements.
% end, testing adjoint parameters. 


CtrlVar.Inverse.Methodology="-Matern-" ; % either "-Tikhonov-" or "-Matern-"

alphaMatern=2;  rhoMatern=10e3; sigmaMatern=1;
[kappaMatern,tauMatern,nuMatern]=Matern_rho_sigma(alphaMatern,rhoMatern,sigmaMatern) ;

CtrlVar.Inverse.Matern.logC.alpha=alphaMatern;
CtrlVar.Inverse.Matern.logC.kappa=kappaMatern;
CtrlVar.Inverse.Matern.logC.tau=tauMatern;

CtrlVar.Inverse.Matern.logAGlen.alpha=alphaMatern;
CtrlVar.Inverse.Matern.logAGlen.kappa=kappaMatern;
CtrlVar.Inverse.Matern.logAGlen.tau=tauMatern;  


%%
CtrlVar.ThicknessConstraints=0;
CtrlVar.ResetThicknessToMinThickness=1;  % change this later on
CtrlVar.ThickMin=1;

%% Filenames

CtrlVar.NameOfFileForSavingSlipperinessEstimate="C-Estimate"+CtrlVar.SlidingLaw+".mat";
CtrlVar.NameOfFileForSavingAGlenEstimate=   "AGlen-Estimate"+CtrlVar.SlidingLaw+".mat";

if CtrlVar.InverseRun
    CtrlVar.Experiment="PIG-TWG-Inverse-"...
        +CtrlVar.ReadInitialMeshFileName...
        +CtrlVar.Inverse.InvertFor...
        +CtrlVar.Inverse.MinimisationMethod...
        +CtrlVar.Inverse.DataMisfit.GradientCalculation...
        +CtrlVar.Inverse.Hessian...
        +"-"+CtrlVar.SlidingLaw...
        +"-"+num2str(CtrlVar.DevelopmentVersion);
else
    CtrlVar.Experiment="PIG-TWG-Forward"...
        +CtrlVar.ReadInitialMeshFileName;
end


filename=sprintf('IR-%s-%s-Nod%i-%s-Cga%f-Cgs%f-Aga%f-Ags%f-m%i-%s',...
    UserVar.RunType,...
    CtrlVar.Inverse.MinimisationMethod,...
    CtrlVar.TriNodes,...
    CtrlVar.Inverse.DataMisfit.GradientCalculation,...
    CtrlVar.Inverse.Regularize.logC.ga,...
    CtrlVar.Inverse.Regularize.logC.gs,...
    CtrlVar.Inverse.Regularize.logAGlen.ga,...
    CtrlVar.Inverse.Regularize.logAGlen.gs,...
    UserVar.m,...
    CtrlVar.Inverse.InvertFor);

filename=replace(filename,"---","-");
filename=replace(filename,"--","-");

CtrlVar.Experiment=replace(CtrlVar.Experiment," ","-");
filename=replace(filename,'.','k');

CtrlVar.Inverse.NameOfRestartOutputFile=filename;
CtrlVar.Inverse.NameOfRestartInputFile=CtrlVar.Inverse.NameOfRestartOutputFile;



end
