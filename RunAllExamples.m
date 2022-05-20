%% Alpha 20 May 2022

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

% UserVar.RunType='Inverse-UaOpt' ; Ua(UserVar) ;  % 08/09/2021 convergnece issues with the new Bedmachine based outline of Thwaites
UserVar.RunType='Inverse-MatOpt' ;    CtrlVar.Inverse.MinimisationMethod="MatlabOptimization-HessianBased"; Ua(UserVar,CtrlVar) ;

UserVar.RunType='Inverse-MatOpt' ;    CtrlVar.Inverse.MinimisationMethod="MatlabOptimization-GradientBased"; Ua(UserVar,CtrlVar) ;  
                                     % Note on 2022-05-20. For some reason this no longer runs using the Matlab optimization toolbox with MATLAB2022a.
                                     % This DOES work with MATLAB2021b
                                     % The reasons are unclear, but for the time being gradient-based optimisation with the Matlab toolbox can not be done with MATLAB2022a.
                                     % This is not too much of an issue as the default option is the HessianBased approach anyhonw, which is also the better option.


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

