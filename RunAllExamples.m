
%% Example Alpha 17 March 2024 : all working with Ua Alpha
%% Example Alpha 01 August2024 : all working with Ua Alpha

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

cd Inverse
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


UserVar.RunType='Inverse-MatOpt'; Ua(UserVar) ;                                                                                         % working 06/03/2023
UserVar.RunType='Inverse-UaOpt' ; Ua(UserVar) ;                                                                                         % working 06/03/2023
UserVar.RunType='Inverse-MatOpt' ;    CtrlVar.Inverse.MinimisationMethod="MatlabOptimization-HessianBased"; Ua(UserVar,CtrlVar) ;       % working 06/03/2023

% UserVar.RunType='Inverse-MatOpt' ;    CtrlVar.Inverse.MinimisationMethod="MatlabOptimization-GradientBased"; Ua(UserVar,CtrlVar) ;    % no-longer working as of Matlab 2021b...?
                                                                                                                                        % The reasons are unclear, but for the time being gradient-based optimisation 
                                                                                                                                        % with the Matlab toolbox can not be done with MATLAB2022a.
                                                                                                                                        % This is not too much of an issue as the default option is the HessianBased approach anyhonw, 
                                                                                                                                        % which is also the better option.
                                                                                                                                        
                                                                                                                                       
UserVar.RunType='TestingMeshOptions' ; Ua(UserVar) ;                                                                                    % working 06/03/2023

cd ..                   
close all



cd MassBalanceFeedback
Ua
cd ..

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
% DefineElementsToDeactivate.m). No level-set calculations/initialisatons are required.
%
UserVar.RunType="Test-ManuallyDeactivateElements-" ;                                          Ua(UserVar) ;

cd ..

