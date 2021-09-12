%%  Mismip example, loading data
Klear
load('RestartExTest-CalvingThroughMassBalanceFeedback-MBice0-Adapt1.mat','RunInfo')
RunInfoMB=RunInfo; % presribed mass balance term to simulate calving

load('RestartExTest-CalvingThroughPrescribedLevelSet-MBice0-Adapt1.mat','RunInfo')
RunInfoLSF=RunInfo;  % prescribed ice/ocean mask  (internally treated as mass-balance feedback)

load('RestartExTest-ManuallyDeactivateElements-MBice0-Adapt1.mat','RunInfo') 
RunInfoED=RunInfo;  % element deactivation

% save("CalvingOptionsRunInfos","RunInfoMB","RunInfoLSF","RunInfoED")

%% Mismip example, plots
load("CalvingOptionsRunInfos","RunInfoMB","RunInfoLSF","RunInfoED")

FindOrCreateFigure("RunInfo uvh: time step and iterations")

yyaxis left
plot(RunInfoMB.Forward.time,RunInfoMB.Forward.dt,'o-b') ; 
hold on
ylabel('time step') ; 
plot(RunInfoLSF.Forward.time,RunInfoLSF.Forward.dt,'*-b') ; 
plot(RunInfoED.Forward.time,RunInfoED.Forward.dt,'+-b') ; 


yyaxis right
stairs(RunInfoMB.Forward.time,RunInfoMB.Forward.uvhIterations,'r-') ;
hold on
stairs(RunInfoLSF.Forward.time,RunInfoLSF.Forward.uvhIterations,'r--') ;
stairs(RunInfoED.Forward.time,RunInfoED.Forward.uvhIterations,'r-.') ;



xlabel('time') ; 
ylabel('uvh iterations')



legend("time step MB","time step LSF","time step ED","#uvh iterations MB","#uvh iterations LSF","#uvh iteration ED")


%% 1dFlowLine example, loading data

Klear
load('RestartExTest-1dAnalyticalIceShelf-CalvingThroughMassBalanceFeedback-MBice0-Adapt1.mat','RunInfo')
RunInfoMB1d=RunInfo; % presribed mass balance term to simulate calving

load('RestartExTest-1dAnalyticalIceShelf-CalvingThroughPrescribedLevelSet-MBice0-Adapt1.mat','RunInfo')
RunInfoLSF1d=RunInfo;  % prescribed ice/ocean mask  (internally treated as mass-balance feedback)

% save("CalvingOptionsRunInfos1d","RunInfoLSF1d","RunInfoMB1d")


%% 1dFlowLine example, plots
Klear
load("CalvingOptionsRunInfos1d","RunInfoMB1d","RunInfoLSF1d")

FindOrCreateFigure("RunInfo uvh: time step and iterations")

yyaxis left
plot(RunInfoMB1d.Forward.time,RunInfoMB1d.Forward.dt,'o-b') ; 
hold on
ylabel('time step') ; 
plot(RunInfoLSF1d.Forward.time,RunInfoLSF1d.Forward.dt,'*-b') ; 

yyaxis right
stairs(RunInfoMB1d.Forward.time,RunInfoMB1d.Forward.uvhIterations,'r-') ;
hold on
stairs(RunInfoLSF1d.Forward.time,RunInfoLSF1d.Forward.uvhIterations,'r--') ;

xlabel('time') ; 
ylabel('uvh iterations')



legend("time step MB","time step LSF","#uvh iterations MB","#uvh iterations LSF")


