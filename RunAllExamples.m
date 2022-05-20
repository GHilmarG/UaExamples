%%  Beta 20/05/2022
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
UserVar.RunType='Inverse-MatOpt'; Ua(UserVar) ;   % working 08/09/2021
% UserVar.RunType='Inverse-UaOpt' ; Ua(UserVar) ;  % 08/09/2021 convergnece issues with the new Bedmachine based outline of Thwaites
UserVar.RunType='Inverse-MatOpt' ;    CtrlVar.Inverse.MinimisationMethod="MatlabOptimization-HessianBased"; Ua(UserVar,CtrlVar) ;
UserVar.RunType='Inverse-MatOpt' ;    CtrlVar.Inverse.MinimisationMethod="MatlabOptimization-GradientBased"; Ua(UserVar,CtrlVar) ;
UserVar.RunType='TestingMeshOptions' ; Ua(UserVar) ;
cd ..
close all

cd MassBalanceFeedback\
Ua
cd ..

cd Calving\

UserVar.RunType="Test-1dAnalyticalIceShelf-CalvingThroughMassBalanceFeedback-";               Ua(UserVar) ;
UserVar.RunType="Test-1dAnalyticalIceShelf-CalvingThroughPrescribedLevelSet-" ;               Ua(UserVar) ;
UserVar.RunType="Test-ManuallyDeactivateElements-" ;                                          Ua(UserVar) ;
UserVar.RunType="Test-CalvingThroughMassBalanceFeedback-";                                    Ua(UserVar) ;
UserVar.RunType="Test-CalvingThroughPrescribedLevelSet-"  ;                                   Ua(UserVar) ;
cd ..

