

function   [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)


%% Provides a simple example of a Greenland set up
%
% The mesh here is a square with uniform mesh created using the UaSquareMesh generator. This could easily be improved by
% using the mesh2d generator instead and providing a more suitable mesh boundary.
%
% Files with interpolants for geometry and velocity are provided as part of the example. These are based on bedmachine and
% ITS_LIVE, but are heavily subsampled to make them small for the github distribution. These interpolants will need to be
% replaced for any realistic modelling of Greenland. 
%
% Also provided as part of the example are some A and C interpolants done using Glen's flow law with n=3 and Weertman sliding
% law with m=3. These are also simply provided as an example. 
%
% Further interpolants can be found at:
%
% https://livenorthumbriaac-my.sharepoint.com/:f:/g/personal/hilmar_gudmundsson_northumbria_ac_uk/EgrEImnkQuJNmf1GEB80VbwB1hgKNnRMscUitVpBrghjRg?e=yMZEOs
%
% However, it is STRONGLY recommended to create new interpolants based on original and latest data sets, and only use these
% interpolants for initial experimentation. 
%
%
%
%%


%% UserVar
%

UserVar.Experiment="GreenlandExample-TDR0-IR0-";

% These are files with Bedmachine geometry and ITS_LIVE velocities. Note that these are heavily downsampled (stride=10 in both x and y
% dimensions) and for any realistic modeling of Greenland these need to be replaced. 
%
UserVar.Files.VelocityInterpolants="ITS-LIVE-ITS-LIVE-velocity-120m-RGI05A-0000-v02-VelocityGriddedInterpolants-nStride10.mat";
UserVar.Files.GeometryInterpolants="BedMachineGreenland-v5-Stride10-GriddedInterpolants.mat";


UserVar.Files.AInterpolant="AGlen-Estimate-Example.mat";
UserVar.Files.CInterpolant="C-Estimate-Weertman-Example.mat";
UserVar.Files.FasInterpolant="Fas-Fmask-MARv3k14-ERA5-2023-Greenland-GriddedInterpolant.mat"; 

% copyfile C-Estimate.mat C-Estimate-Weertman-Example.mat  ; copyfile AGlen-Estimate.mat AGlen-Estimate-Example.mat ;
%% Type of run
CtrlVar.TimeDependentRun=logical(str2double(extractBetween(UserVar.Experiment,"-TDR","-")));


CtrlVar.InverseRun=logical(str2double(extractBetween(UserVar.Experiment,"-IR","-")));

CtrlVar.Restart=0;
%% time stepping

CtrlVar.StartTime=0; 
CtrlVar.EndTime=100;
CtrlVar.dt=1e-3;
CtrlVar.AdaptiveTimeStepping=1 ;  

if CtrlVar.TimeDependentRun
    CtrlVar.TotalNumberOfForwardRunSteps=inf;
    CtrlVar.DefineOutputsDt=0.1;           
else 
    CtrlVar.TotalNumberOfForwardRunSteps=1;
    CtrlVar.DefineOutputsDt=0;             
end


%% non-linear solver
CtrlVar.NRitmax=150;       % maximum number of NR iteration
%% Inverse run parameters
CtrlVar.Inverse.Iterations=1000;

CtrlVar.Inverse.Regularize.logAGlen.ga=1;
CtrlVar.Inverse.Regularize.logAGlen.gs=1e4 ;
CtrlVar.Inverse.Regularize.logC.ga=1;
CtrlVar.Inverse.Regularize.logC.gs=1e4 ; 

CtrlVar.Inverse.MinimisationMethod="MatlabOptimization-GradientBased";  
CtrlVar.Inverse.AdjointGradientPreMultiplier="M" ; 
%% Meshing
%
% Here the UaSquareMesh generator is used. This creates an initial simple square mesh with uniform resolution. Afterwards all
% elements outside of the MeshBoundaryCoordinates are deactivated.
%
% As always, further mesh refinements and deactivations, etc., are then possible based on user inputs.
%
load("GreenlandComputationalBoundary.mat","xp","yp") ;
MeshBoundaryCoordinates=[xp,yp];
CtrlVar.TriNodes=3 ;
CtrlVar.MeshGenerator="UaSquareMesh";
CtrlVar.UaSquareMesh.xmin=-650e3;
CtrlVar.UaSquareMesh.xmax=900e3;
CtrlVar.UaSquareMesh.ymin=-3400e3;
CtrlVar.UaSquareMesh.ymax=-600e3;

CtrlVar.UaSquareMesh.nx=100;
CtrlVar.MaxNumberOfElements=1e6;

CtrlVar.AdaptMesh=0;

CtrlVar.ReadInitialMesh=0;
CtrlVar.ReadInitialMeshFileName='OldMeshFile.mat';
CtrlVar.SaveInitialMeshFileName='NewMeshfile.mat';


%%

CtrlVar.Experiment=UserVar.Experiment;
CtrlVar.NameOfRestartFiletoWrite=CtrlVar.Experiment+"RestartFile.mat";
CtrlVar.NameOfRestartFiletoRead=CtrlVar.NameOfRestartFiletoWrite;



%% plotting
CtrlVar.PlotXYscale=1000;






%%
CtrlVar.ThicknessConstraints=1;
CtrlVar.ThickMin=1;
end
