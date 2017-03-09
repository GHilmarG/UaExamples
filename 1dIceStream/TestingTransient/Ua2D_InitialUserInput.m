
function [UserVar,CtrlVar,time,dt,MeshBoundaryCoordinates]=Ua2D_InitialUserInput(CtrlVar)

Experiment='TransientTestGL1d';


xd=1800e3; xu=0e3 ; yl=100e3 ; yr=-100e3;
MeshBoundaryCoordinates=[xu yr ; xu yl ; xd yl ; xd yr];
CtrlVar.GmshMeshingAlgorithm=8;
                                    % 1=MeshAdapt
                                    % 2=Automatic
                                    % 5=Delaunay
                                    % 6=Frontal
                                    % 7=bamg
                                    % 8=DelQuad (experimental)




CtrlVar.OnlyMeshDomainAndThenStop=0;
CtrlVar.doPrognostic=1 ; CtrlVar.doDiagnostic=0  ;CtrlVar.doInverseStep=0;
CtrlVar.InitialDiagnosticStep=0; 

dt=1e-1; time=0; CtrlVar.TotalNumberOfForwardRunSteps=50; CtrlVar.TotalTime=1200; 
CtrlVar.doplots=1;  CtrlVar.PlotXYscale=1000; CtrlVar.PlotMesh=1; CtrlVar.FE2dPlots=0;       
CtrlVar.doTransientPlots=1;
CtrlVar.TransientPlotDt=10;  % if true and if CtrlVar.doplots true also, then call to `FE2dTransientPlots.m' is made 
   
%% numerical variables related to transient runs
    % in general no need to ever change these values  
    CtrlVar.Implicituvh=1;  
    CtrlVar.TG3=1 ; % if true, the prognostic steps uses a third-order Taylor-Galerkin method
                    % currently only implemented for periodic boundary conditions
    CtrlVar.Test1=1;  
    CtrlVar.Test0=0;  
    
    CtrlVar.theta=0.5;    % theta=0 is forward Euler, 1 backward Euler, 1/2 is most accurate
    CtrlVar.IncludeTG3uvhBoundaryTerm=0;                     % keep zero (only used for testing)
    CtrlVar.IncludeDirichletBoundaryIntegralDiagnostic=0;    % keep zero (only used for testing)
    
%%


CtrlVar.Restart=1;  
CtrlVar.WriteRestartFile=1;
CtrlVar.NameOfRestartFiletoRead=['Test-TG3',num2str(CtrlVar.TG3),'-Implicit',num2str(CtrlVar.Implicituvh),'-theta',num2str(CtrlVar.theta),'.mat'];
CtrlVar.NameOfRestartFiletoWrite=['Test-TG3',num2str(CtrlVar.TG3),'-Implicit',num2str(CtrlVar.Implicituvh),'-theta',num2str(CtrlVar.theta),'.mat'];

% remesh variables
CtrlVar.AdaptMesh=1; CtrlVar.doRemeshPlots=1;
CtrlVar.MeshRefinement=0;
CtrlVar.AdaptMeshInterval=25;
%CtrlVar.MeshRefinementMethod='implicit'; CtrlVar.RefineCriteria='effective strain rates';
CtrlVar.MeshRefinementMethod='explicit'; 
CtrlVar.RefineCriteria='flotation';
%CtrlVar.RefineCriteria='|dhdt|';
%CtrlVar.RefineCriteria='||grad(dhdt)||';
CtrlVar.RefineCriteria={'flotation','||grad(dhdt)||','dhdt curvature','thickness curvature'}; 
CtrlVar.RefineCriteriaWeights=[0.2,1,1,1];
CtrlVar.RefineCriteria={'||grad(dhdt)||','dhdt curvature'}; 
CtrlVar.RefineCriteriaWeights=[1,1];
CtrlVar.RefineDiracDeltaWidth=250;

%CtrlVar.RefineCriteria='effective strain rates';



CtrlVar.MeshSize=25e3;
CtrlVar.TriNodes=3;
CtrlVar.MeshSizeMin=CtrlVar.MeshSize/50;
CtrlVar.MeshSizeMax=CtrlVar.MeshSize;

CtrlVar.MaxNumberOfElements=10000;
CtrlVar.hpower=1;




%CtrlVar.RefineCriteria='thickness gradient';
%CtrlVar.RefineCriteria='flotation';
% CtrlVar.RefineCriteria='gradient of effective strain rates';

CtrlVar.iJob=11;
CtrlVar.kH=1;

CtrlVar.NLtol=1e-15; % this is the square of the error, i.e. not root-mean-square error
CtrlVar.InfoLevelNonLinIt=1;
CtrlVar.NRitmax=100;
    
CtrlVar.ThickMin=0.01; % minimum allowed thickness without doing something about it
CtrlVar.AdaptiveTimeStepping=1 ;   % true if time step should potentially be modified
CtrlVar.ATStimeStepTarget=1.0  ;   % maximum time step allowed
CtrlVar.ATSTargetIterations=4;      % if number of non-lin iterations has been less than ATSTargetIterations for
end
