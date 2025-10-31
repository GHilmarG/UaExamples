function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)



if ~isfield(UserVar,'RunType')
    UserVar.RunType="IceShelf";   %  A perturbation only
   % UserVar.RunType="IceStream";  %  C perturbation only
end


UserVar.n=3;
UserVar.m=3;
UserVar.C0=1/20^UserVar.m ; % C without perturbation applied, not a possible modification to this value below.
UserVar.V0=1000;

UserVar.AddDataErrors=0;

%%

switch     UserVar.RunType
    case "IceStream"
        CtrlVar.alpha=0.01;
    case "IceShelf"
        CtrlVar.alpha=0;
    otherwise
        error("case not found")
end

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

%% Sliding law
CtrlVar.SlidingLaw="Weertman" ;
% CtrlVar.SlidingLaw="Umbi" ;
% CtrlVar.SlidingLaw="Cornford" ;
% CtrlVar.SlidingLaw="Joughin" ;

pattern=["Joughin","rCW-V0"];
if contains(CtrlVar.SlidingLaw,pattern)
    UserVar.C0=UserVar.C0/UserVar.V0;
end



%% Inverse   -inverse
%CtrlVar.Inverse.MinimisationMethod='MatlabOptimization'; % {'MatlabOptimization','UaOptimization'}
% CtrlVar.Inverse.MinimisationMethod="MatlabOptimization-HessianBased"; % 
% CtrlVar.Inverse.AdjointGradientPreMultiplier="M" ; 

% CtrlVar.Inverse.MinimisationMethod='UaOptimization-Hessian'; % {'MatlabOptimization','UaOptimization'}


CtrlVar.Inverse.MinimisationMethod="MatlabOptimization-HessianBased";      % Hessian-based, Matlab toolbox, only use for CtrlVar.TriNodes=3;
% CtrlVar.Inverse.MinimisationMethod="MatlabOptimization-GradientBased";     % gradient-based, Matlab toolbox (not working with R2023a, fine with R2023b and later versions)
% CtrlVar.Inverse.MinimisationMethod="UaOptimization-GradientBased";       % gradient-based, Ua optimisation toolbox
% CtrlVar.Inverse.MinimisationMethod="UaOptimization-HessianBased";        % Hessian-based, Ua optimisation toolbox, seems to work fine for CtrlVar.TriNodes>3;





CtrlVar.Inverse.InvertFor='-logC-logA-';
CtrlVar.Inverse.Regularize.Field=CtrlVar.Inverse.InvertFor; 
CtrlVar.Inverse.Iterations=100000;


CtrlVar.Inverse.InfoLevel=1;  % Set to 1 to get some basic information, >=2 for additional info on backtracking,
% >=100 for further info and plots

CtrlVar.InfoLevelNonLinIt=0; CtrlVar.InfoLevel=0;
% CtrlVar.InfoLevelNonLinIt=1; CtrlVar.InfoLevel=1;

CtrlVar.Inverse.DataMisfit.Multiplier=1;
CtrlVar.Inverse.Regularize.Multiplier=1;
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

CtrlVar.TriNodes=3;
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

%

CtrlVar.Restart=1;  

end
