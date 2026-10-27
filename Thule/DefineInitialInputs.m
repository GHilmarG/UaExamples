
function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)

%% Thule is a synthetic geometry 
%
% Note: By running Bedgeometry.m without any arguments, the Thule geometry will be created and plotted.
% 
% Thule geometry is defined as:
%
%   r=sqrt(x.*x+y.*y) ;
%   theta=atan2(y,x);
%   rc=0;
%   l=R -  cos(2*theta).*R/2 ;            % theta-dependent wavelength
%   a=Bc - (Bc-Bl)*(r-rc).^2./(R-rc).^2;  % quadratic term in r
%   B=Ba*cos(3*pi*r./l)+a ;               %
% 
%% UserVar : This variable is never used by Ua, but is defined and used by the user alone.
% 
%
% Here a RunType field is defined as part of UserVar. This is then used in
% some of the other Define*.m files to select various options related to
% the run.
%
% For example:
% 
%  "-Thule-" implies the use of the Thule geometry. This is used in  DefineGeometryAndDensities.m
%  "-Cxy-" implies that the slipperiness is a function of B. This is used in DefineSlipperiness.m
%  "-SSmin-"  and "-SSmax-" set initial ice thickness at the beginning of a transient run to some small/large value. This is used in DefineGeometryAndDensities.m
%  "-Tmax-" and "-Tmin-" are used in DefineGeometryAndDensities.m to specify initial geometries based on steady-state
%  geometries achieved by running the -SSmin-" and the "-SSmax-" geometries to steady-state
%
%% The user always defines the UserVar. 
%
% Here the user has decided to define a string variable which is then used later to control some of the run options
%
% Within the string UserVar.RunType: 
%
% -ES*km-  : indicates the overall mesh resolution
% -SSmax-  implies that the run is started from a previous steady-state geometry which in turn was started using large initial thickness. 
% 
%  Note: The Thule geometry can produce different steady states for the same mass balance forcing, depending on
% conditions at the beginning of the run. 
%
%  -Cxy- implies that the basal slipperiness is a function of x and y. Here this is used by the user in DefineSlipperines.m
%
%


UserVar.RunType="-Thule-C-Tmax-C-NV2.0-ES10km-" ; 
UserVar.RunType="-Thule-C-Tmin-C-NV2.0-ES10km-" ; 

UserVar.RunType="-Thule-P-SSmin-ES10km-Cxy-" ;  
UserVar.RunType="-Thule-P-SSmax-ES10km-Cxy-" ;  

UserVar.RunType="-Thule-P-SSmax-ES50km-Cxy-" ;  % This is a very coarse mesh resolution, but OK for testing
UserVar.RunType="-Thule-C-SSmax-ES50km-Cxy-" ;  % This is a very coarse mesh resolution, but OK for testing


UserVar.Region="-Thule-" ;
R=750e3 ;
theta=linspace(0,2*pi,400);
Xc=R*cos(theta); Yc=R*sin(theta) ; Xc(end)=[] ; Yc(end)=[];
UserVar.CalvingFront0.Xc=Xc(:);
UserVar.CalvingFront0.Yc=Yc(:);

%% Used in DefineOutputs.m
UserVar.DefineOutputs="-ubvb-LSF-h-sbB-s-B-dhdt-speed-EastWestProfile-NorthSouthProfile-";


clear DefineOutputs % clear persistent variables 





%% Sliding law

CtrlVar.SlidingLaw="Weertman" ; % "Umbi" ; % "Weertman" ; % "Tsai" ; % "Cornford" ;  "Umbi" ; "Cornford" ; % "Tsai" , "Budd"



%% Run type: time stepping and duration, time-integration  
CtrlVar.ForwardTimeIntegration="-uvh-" ; % "-uvh-" , "-uv-h-" , "-uv-" , "-h-" ; 
CtrlVar.Restart=0;


CtrlVar.TotalNumberOfForwardRunSteps=inf; 

CtrlVar.dt=0.001;   
CtrlVar.StartTime=0; 
CtrlVar.EndTime=10; 



%% Info levels
CtrlVar.InfoLevelNonLinIt=1;  % info provided on solution procedure, 1 is basic information, 5 provides more info and various plots, see more in Ua2D_DefaultParameters.m
CtrlVar.InfoLevelThickMin=0; % This provides information on whether the ice thickness drops below min ice thickness. Set to zero to suppress.


%% Plots and outputs
CtrlVar.DefineOutputsDt=0.1;  % controls time interval between calls do DefineOutPuts.m
CtrlVar.doplots=1;
UserVar.CreateVideo=false;
CtrlVar.PlotMesh=0;
CtrlVar.PlotBCs=0 ;
CtrlVar.PlotXYscale=1000;
CtrlVar.doAdaptMeshPlots=0;

%% Meshing

CtrlVar.TriNodes=3 ;
CtrlVar.MeshSizeMax=NaN;
CtrlVar.MeshSize=str2double(extractBetween(UserVar.RunType,"-ES","km-"))*1000; 
CtrlVar.MeshSizeMin=CtrlVar.MeshSizeMax/20;


CtrlVar.SaveInitialMeshFileName="MeshFile"+num2str(CtrlVar.MeshSize/1000)+"km.mat"; 
CtrlVar.ReadInitialMeshFileName="MeshFile"+num2str(CtrlVar.MeshSize/1000)+"km.mat" ; 
CtrlVar.MaxNumberOfElements=70e3;

if isfile(CtrlVar.ReadInitialMeshFileName)
    CtrlVar.ReadInitialMesh=1;  
else
    CtrlVar.ReadInitialMesh=0;  
end


R=1000e3 ;
theta=linspace(0,2*pi,100);
x=R*cos(theta); y=R*sin(theta) ; x(end)=[] ; y(end )=[];
MeshBoundaryCoordinates=[x(:) y(:)];

%% Adaptive meshing

CtrlVar.AdaptMesh=1;
CtrlVar.AdaptMeshRunStepInterval=0 ;
CtrlVar.AdaptMeshTimeInterval=0.05;   
CtrlVar.AdaptMeshMaxIterations=10;  
CtrlVar.MeshRefinementMethod="explicit:local:newest vertex bisection";
CtrlVar.MeshAdapt.CFrange=[CtrlVar.MeshSize*2 CtrlVar.MeshSize/2 ; CtrlVar.MeshSize CtrlVar.MeshSize/5];            
CtrlVar.MeshAdapt.GLrange=CtrlVar.MeshAdapt.CFrange;

%% Min thickness:

CtrlVar.ThickMin=1;   % This is the minimum thickness allowed. This should always be "small" thickness, i.e. small compared to any thicknesses of interest,
CtrlVar.ThicknessConstraints=1;            % use thickness constraints. Here minimum thickness is enforced using Lagrange multipliers.
CtrlVar.ThicknessConstraintsItMax=10  ;



%% Calving
CtrlVar.LevelSetMethodAutomaticallyApplyMassBalanceFeedback=0;
if contains(UserVar.RunType,"-P-")  % This indicates that calving fronts positions are prescribed and that the level-set methods is used.

    % Here the calving front positions are prescribed by the user. This is done in DefineCalving.m
    % The level set method is used, but the level set equation is not solved since the calving front positions, and here the
    % level-set function itself, is defined directly by the user (done in DefineCalving.m)
    %
    % The level-set functionality of Ua is here only used to ensure that the ice downstream of calving fronts is set to some
    % small value.
    %
    CtrlVar.LevelSetMethod=1;
    CtrlVar.LevelSetEvolution="-Prescribed-"  ;
    fprintf("The level set is not evolved (ie the level-set is prescribed directly by user) \n")

elseif contains(UserVar.RunType,"-C-")  % This indicates that calving fronts positions are prescribed and that the level-set methods is used.

    CtrlVar.LevelSetMethod=1;
    CtrlVar.LevelSetEvolution="-By solving the level set equation-" ;
    fprintf("The level set is evolved (ie by solving the level-set equation) \n")

end



%% FileNames
CtrlVar.Experiment=UserVar.RunType;
CtrlVar.NameOfRestartFiletoRead="Restart"+UserVar.RunType;
CtrlVar.NameOfRestartFiletoRead=replace(CtrlVar.NameOfRestartFiletoRead,".","k")+".mat";
CtrlVar.NameOfRestartFiletoWrite=CtrlVar.NameOfRestartFiletoRead;


%% PARDISO/MATLAB linear solvers

CtrlVar.LinearSolver.Type="PARDISO" ;

%% Parallel
CtrlVar.Parallel.uvhAssembly.spmd.isOn=true;
CtrlVar.Parallel.uvAssembly.spmd.isOn=true;

% Parpool, open a pool, provided none is already open
if isempty(gcp('nocreate'))
    parpool("Threads",4)
end

%% Active set

CtrlVar.ActiveSet.DeferReleases=true;             % (25 Oct 2026) active-set test: defer release-only updates to the next time step
CtrlVar.ActiveSet.DeferReleasesMaxThickening=1;   % (25 Oct 2026) active-set test: defer only if all released nodes thicken by less than ThickMin

%%

end
