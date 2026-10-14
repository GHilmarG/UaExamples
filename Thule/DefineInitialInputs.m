
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

UserVar.RunType="-Thule-P-SSmax-ES50km-Cxy-SUPGtaus-" ;  % This is a very coarse mesh resolution, but OK for testing


UserVar.Region="-Thule-" ;
R=750e3 ;
theta=linspace(0,2*pi,400);
Xc=R*cos(theta); Yc=R*sin(theta) ; Xc(end)=[] ; Yc(end)=[];
UserVar.CalvingFront0.Xc=Xc(:);
UserVar.CalvingFront0.Yc=Yc(:);

%% Used in DefineOutputs.m
UserVar.DefineOutputs="-ubvb-LSF-h-sbB-s-B-dhdt-save-log10speed-";
UserVar.DefineOutputs="-ubvb-LSF-h-sbB-s-B-dhdt-log10speed-";
%UserVar.DefineOutputs="-EastWestProfile-dhdt-ubvb-s-";



%% Sliding law

CtrlVar.SlidingLaw="Weertman" ; % "Umbi" ; % "Weertman" ; % "Tsai" ; % "Cornford" ;  "Umbi" ; "Cornford" ; % "Tsai" , "Budd"



%% Run type: time stepping and duration, time-integration  
CtrlVar.ForwardTimeIntegration="-uvh-" ; % "-uvh-" , "-uv-h-" , "-uv-" , "-h-" ; 
CtrlVar.Restart=0;


CtrlVar.TotalNumberOfForwardRunSteps=1000; 

CtrlVar.dt=0.001;   
CtrlVar.StartTime=0; 
CtrlVar.EndTime=1; 



%% Info levels
CtrlVar.InfoLevelNonLinIt=1;  % info provided on solution procedure, 1 is basic information, 5 provides more info and various plots, see more in Ua2D_DefaultParameters.m
CtrlVar.InfoLevelThickMin=0; % This provides information on whether the ice thickness drops below min ice thickness. Set to zero to suppress.


%% Plots and outputs
CtrlVar.DefineOutputsDt=0.1;  % controls time interval between calls do DefineOutPuts.m
CtrlVar.doplots=1;
CtrlVar.PlotMesh=0;
CtrlVar.PlotBCs=1 ;
CtrlVar.PlotXYscale=1000;
CtrlVar.doAdaptMeshPlots=5;

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
    CtrlVar.OnlyMeshDomainAndThenStop=0;
else
    CtrlVar.ReadInitialMesh=0;  
    CtrlVar.OnlyMeshDomainAndThenStop=1;
end


R=1000e3 ;
theta=linspace(0,2*pi,100);
x=R*cos(theta); y=R*sin(theta) ; x(end)=[] ; y(end )=[];
MeshBoundaryCoordinates=[x(:) y(:)];

%% Adaptive meshing

CtrlVar.AdaptMesh=1;
CtrlVar.AdaptMeshTimeInterval=0.05;   
CtrlVar.AdaptMeshMaxIterations=10;  
CtrlVar.MeshRefinementMethod="explicit:local:newest vertex bisection";
CtrlVar.MeshAdapt.CFrange=[CtrlVar.MeshSize*2 CtrlVar.MeshSize/2 ; CtrlVar.MeshSize CtrlVar.MeshSize/5];            


%% Min thickness:

CtrlVar.ThickMin=1;   % This is the minimum thickness allowed. This should always be "small" thickness, i.e. small compared to any thicknesses of interest,



CtrlVar.ThicknessConstraints=1;            % use thickness constraints. Here minimum thickness is enforced using Lagrange multipliers.
                                           % This is the recommended approach, but it does lead to additional solves and this will increase computational time.
CtrlVar.ThicknessConstraintsItMax=10  ;



                                                                    %% Calving

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
    CtrlVar.LevelSetEvolution="-By solving the level set equation-" ;

    CtrlVar.LevelSetMethodAutomaticallyApplyMassBalanceFeedback=0;
    % abLSF =LM.* ( a1*(hint-hmin)+a3*(hint-hmin).^3) ;      % The additional mass-balance term applied where the level-set
    % function (phi) is negative, i.e. LM = \phi < 0  ;
    CtrlVar.LevelSetMethodMassBalanceFeedbackCoeffLin=1000;  % a1=-abs(CtrlVar.LevelSetMethodMassBalanceFeedbackCoeffLin;
    CtrlVar.LevelSetMethodMassBalanceFeedbackCoeffCubic=0;   % a3=-abs(CtrlVar.LevelSetMethodMassBalanceFeedbackCoeffCubic;

end

%% This is for testing different SUPG options

if contains(UserVar.RunType,"-SUPG")
    CtrlVar.uvh.SUPG.tau=extractBetween(UserVar.RunType,"-SUPG","-");
    CtrlVar.h.SUPG.tau=extractBetween(UserVar.RunType,"-SUPG","-") ;
    CtrlVar.Tracer.SUPG.tau=extractBetween(UserVar.RunType,"-SUPG","-");
end
switch CtrlVar.uvh.SUPG.tau
    case "taus"
        CtrlVar.FigTitleText=", $\tau_{\mathrm{SUPG}}=\tau_s$";
    case "taut"
        CtrlVar.FigTitleText=", $\tau_{\mathrm{SUPG}}=\tau_t$";
    case "tau1"
        CtrlVar.FigTitleText=", $\tau_{\mathrm{SUPG}}=\tau_1$";
    case "tau2"
        CtrlVar.FigTitleText=", $\tau_{\mathrm{SUPG}}=\tau_2$";
    otherwise
        error("case not found")
end

%%
CtrlVar.Experiment=UserVar.RunType;


CtrlVar.NameOfRestartFiletoRead="Restart"+UserVar.RunType;
CtrlVar.NameOfRestartFiletoRead=replace(CtrlVar.NameOfRestartFiletoRead,".","k")+".mat";
CtrlVar.NameOfRestartFiletoWrite=CtrlVar.NameOfRestartFiletoRead;

%% Testing options



end
