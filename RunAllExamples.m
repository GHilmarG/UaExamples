
%% Alpha 27 July, 2025

%% Example Alpha 17 March 2024      : all working with Ua Alpha
%% Example Alpha 01 August 2024     : all working with Ua Alpha
%% Example Alpha 29 Dec 2024        : all working with Ua Alpha
%% Example Alpha 2 March 2025       : all working with Ua Alpha
%% Example Alpha 5 May 2025         : all working with Ua Alpha
%% Example Alpha 19 July 2025       : all working with Ua Alpha with R2024b, but inverse example stalls with R2025a
%% Example Alpha 24 Sept 2025       : With R2025a and R2025b the matrix solution produces several "almost singular" messages, whereas the same problem run fine with R2024b and earlier... 
%% Example Alpha 3 Nov   2025       : all working with Ua Alpha under R2025b

cd RadialIceCap\
Ua
cd ..
close all

cd 1dIceShelf
Ua
cd ..
close all


cd 1dIceStream
Ua
cd ..
close all

cd Crack
Ua
cd ..

cd GaussPeak
Ua
cd ..
close all

cd IceShelf
Ua
cd ..
close all



cd MismipPlus
Ua
cd ..

cd IceBerg
Ua
cd ..


cd PIG-TWG


UserVar.RunType='Inverse-MatOpt'; Ua(UserVar) ;                                                                                         %  01/03/2025, 19/07/2025
UserVar.RunType='Inverse-UaOpt' ; Ua(UserVar) ;                                                                                         %  01/03/2025, 19/07/2025
UserVar.RunType='Inverse-MatOpt' ;    CtrlVar.Inverse.MinimisationMethod="MatlabOptimization-HessianBased"; Ua(UserVar,CtrlVar) ;       %  01/03/2025, 19/07/2025

Klear
UserVar.RunType='Inverse-MatOpt' ;    CtrlVar.Inverse.MinimisationMethod="MatlabOptimization-GradientBased"; Ua(UserVar,CtrlVar) ;      % no-longer working as of Matlab 2021b...?
                                                                                                                                        % The reasons are unclear, but for the time being gradient-based optimization 
                                                                                                                                        % with the Matlab toolbox can not be done with MATLAB R2022a.
                                                                                                                                        % This is not too much of an issue as the default option is the Hessian-based approach anyhow, 
                                                                                                                                        % which is also the better option.
                                                                                                                                        % But as of R2024b, and possibly earlier, this is again working... 01/03/2024                                                                                                                                 
                                                                                                                                       
UserVar.RunType='TestingMeshOptions' ; Ua(UserVar) ;                                                                                    %  01/03/2025, 19/07/2025

cd ..                   
close all



cd MassBalanceFeedback
Ua
cd ..

%%

cd Calving



% A few examples: 

% 1) Here calving is implemented by the user using a user-defined mass balance feedback as defined in DefineMassBalance.m
%    This does not involve the level-set method implementation in Ua
UserVar.RunType="Test-1dAnalyticalIceShelf-CalvingThroughMassBalanceFeedback-";               Ua(UserVar) ;

% 2) Level-set is prescribed directly (in DefineCalving.m). This example shows how the user can 
%   define directly/manually the position of the calving front over time. 
%   No calving law is used and the calving rate is not specified.
UserVar.RunType="Test-1dAnalyticalIceShelf-CalvingThroughPrescribedLevelSet-" ;               Ua(UserVar) ;


% 3) Similar to case 1) above but done for a MismipPlus style geometry.
UserVar.RunType="Test-CalvingThroughMassBalanceFeedback-";                                    Ua(UserVar) ;

% 4) Similar to case 2) above but done for a MismipPlus style geometry.
UserVar.RunType="Test-CalvingThroughPrescribedLevelSet-"  ;                                   Ua(UserVar) ;


% 5) Calving through element deactivation:  Here calving is simulated by deactivating elements (done in
% DefineElementsToDeactivate.m). No level-set calculations/initialization are required.
%
UserVar.RunType="Test-ManuallyDeactivateElements-" ;                                          Ua(UserVar) ;

cd ..


%%


cd Inverse   
Ua           
cd ..
close all

%%

cd Greenland\
Ua
cd ..


%%