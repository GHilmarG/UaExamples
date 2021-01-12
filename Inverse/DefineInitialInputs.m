function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)



if ~isfield(UserVar,'RunType')
    UserVar.RunType='IceShelf';   %  A pertubation only
    UserVar.RunType='IceStream';  %  C pertubation only
end

UserVar.AddDataErrors=0;

%%
CtrlVar.doplots=1;

xd=200e3; xu=-200e3 ; yl=200e3 ; yr=-200e3;
MeshBoundaryCoordinates=[xu yr ; xd yr ; xd yl ; xu yl];
MeshBoundaryCoordinates=flipud(MeshBoundaryCoordinates);
%% Types of runs
CtrlVar.InverseRun=1;



%% Restart
CtrlVar.Restart=0;  CtrlVar.WriteRestartFile=1;
CtrlVar.NameOfRestartFiletoRead=['Nod',num2str(CtrlVar.TriNodes),'-iC-Restart.mat'];
CtrlVar.NameOfRestartFiletoWrite=CtrlVar.NameOfRestartFiletoRead;


%% Inverse   -inverse
CtrlVar.Inverse.MinimisationMethod='MatlabOptimization'; % {'MatlabOptimization','UaOptimization'}

CtrlVar.Inverse.MinimisationMethod='UaOptimization'; % {'MatlabOptimization','UaOptimization'}
CtrlVar.Inverse.GradientUpgradeMethod='SteepestDecent' ; %{'SteepestDecent','ConjGrad'}
CtrlVar.Inverse.InfoLevelBackTrack=1000;  % info on backtracking within inverse step

CtrlVar.Inverse.AdjointGradientPreMultiplier="Hanalytical" ; 
CtrlVar.Inverse.InvertFor='-C-';
CtrlVar.Inverse.Regularize.Field=CtrlVar.Inverse.InvertFor; 
CtrlVar.Inverse.Iterations=200;

if CtrlVar.Inverse.AdjointGradientPreMultiplier=="Hanalytical"
    CtrlVar.Inverse.InitialLineSearchStepSize=1;
end

CtrlVar.Inverse.InfoLevel=1;  % Set to 1 to get some basic information, >=2 for additional info on backtrackgin,
% >=100 for further info and plots

CtrlVar.InfoLevelNonLinIt=0; CtrlVar.InfoLevel=0;

CtrlVar.Inverse.DataMisfit.Multiplier=1;
CtrlVar.Inverse.Regularize.Multiplier=0;
% regularisation parameters
CtrlVar.Inverse.Regularize.C.gs=1;
CtrlVar.Inverse.Regularize.C.ga=1;
CtrlVar.Inverse.Regularize.logC.ga=0;
CtrlVar.Inverse.Regularize.logC.gs=1000 ; % 1e6  works well with I

CtrlVar.Inverse.Regularize.AGlen.gs=1000;
CtrlVar.Inverse.Regularize.AGlen.ga=0;
CtrlVar.Inverse.Regularize.logAGlen.ga=0;
CtrlVar.Inverse.Regularize.logAGlen.gs=1000 ;


%% Mesh generation and remeshing parameters

CtrlVar.TriNodes=6;
CtrlVar.meshgeneration=1;
CtrlVar.GmshMeshingAlgorithm=8;    % see gmsh manual
% 1=MeshAdapt
% 2=Automatic
% 5=Delaunay
% 6=Frontal
% 7=bamg
% 8=DelQuad (experimental)

CtrlVar.ReadInitialMesh=1;    % if true then read FE mesh (i.e the MUA variable) directly from a .mat file
% unless the adaptive meshing option is used, no further meshing is done.
CtrlVar.ReadInitialMeshFileName='AdaptMeshFile10k';
%CtrlVar.ReadInitialMeshFileName='UniformMesh';
CtrlVar.SaveInitialMeshFileName='NewMeshFile.mat';



CtrlVar.MeshSize=10e3;
CtrlVar.MeshSize=50e3;
CtrlVar.MeshSize=20e3;
%CtrlVar.MeshSize=2.5e3;   % used in forward model
CtrlVar.MeshSizeMin=0.1*CtrlVar.MeshSize;    % min element size
CtrlVar.MeshSizeMax=CtrlVar.MeshSize;

CtrlVar.GmshGeoFileAdditionalInputLines{1}='Periodic Line {1,2} = {3,4};';
CtrlVar.AdaptMesh=0;
CtrlVar.SaveAdaptMeshFileName='AdaptMeshFile';



%% plotting
CtrlVar.PlotXYscale=1000;
CtrlVar.PlotLabels=0 ; CtrlVar.PlotMesh=1; CtrlVar.PlotBCs=0;


%%
filename=sprintf('IR-%s-%s-Nod%i-%s-Cga%f-Cgs%f-Aga%f-Ags%f-%i-%i-%s',...
    UserVar.RunType,...
    CtrlVar.Inverse.MinimisationMethod,...
    CtrlVar.TriNodes,...
    CtrlVar.Inverse.AdjointGradientPreMultiplier,...
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
%%

CtrlVar.Experiment=['I-',num2str(CtrlVar.TriNodes)];

end
