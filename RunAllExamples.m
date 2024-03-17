%%  Master 17 March 2024
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

cd IceShelf\
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

cd PIG-TWG\
UserVar.RunType='Inverse-MatOpt'; Ua(UserVar) ;                                                                                         % working 06/03/2023
UserVar.RunType='Inverse-UaOpt' ; Ua(UserVar) ;                                                                                         % working 06/03/2023
UserVar.RunType='Inverse-MatOpt' ;    CtrlVar.Inverse.MinimisationMethod="MatlabOptimization-HessianBased"; Ua(UserVar,CtrlVar) ;       % working 06/03/2023
% UserVar.RunType='Inverse-MatOpt' ;    CtrlVar.Inverse.MinimisationMethod="MatlabOptimization-GradientBased"; Ua(UserVar,CtrlVar) ;    % no-longer working as of Matlab 2021...?
UserVar.RunType='TestingMeshOptions' ; Ua(UserVar) ;                                                                                    % working 06/03/2023
cd ..                   
close all

cd MassBalanceFeedback\
Ua
cd ..

cd Calving\

UserVar.RunType="Test-1dAnalyticalIceShelf-CalvingThroughMassBalanceFeedback-";               Ua(UserVar) ;    % working 06/03/2023
UserVar.RunType="Test-1dAnalyticalIceShelf-CalvingThroughPrescribedLevelSet-" ;               Ua(UserVar) ;    % working 06/03/2023
UserVar.RunType="Test-ManuallyDeactivateElements-" ;                                          Ua(UserVar) ;    % working 06/03/2023
UserVar.RunType="Test-CalvingThroughMassBalanceFeedback-";                                    Ua(UserVar) ;    % working 06/03/2023
UserVar.RunType="Test-CalvingThroughPrescribedLevelSet-"  ;                                   Ua(UserVar) ;    % working 06/03/2023
cd ..

