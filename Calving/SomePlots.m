%%
Klear
load('RestartExTest-CalvingThroughMassBalanceFeedback-MBice0-Adapt1.mat','RunInfo')
RunInfoMB=RunInfo; % presribed mass balance term to simulate calving

load('RestartExTest-CalvingThroughPrescribedLevelSet-MBice0-Adapt1.mat','RunInfo')
RunInfoLSF=RunInfo;  % prescribed ice/ocean mask  (internally treated as mass-balance feedback)

load('RestartExTest-ManuallyDeactivateElements-MBice0-Adapt1.mat','RunInfo') 
RunInfoED=RunInfo;  % element deactivation

% save("CalvingOptionsRunInfos","RunInfoMB","RunInfoLSF","RunInfoED")

%%
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