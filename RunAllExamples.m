%%
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
UserVar.RunType='Inverse-MatOpt'; Ua(UserVar) ;
UserVar.RunType='Inverse-UaOpt' ; Ua(UserVar) ;
UserVar.RunType='Inverse-MatOpt' ;    CtrlVar.Inverse.MinimisationMethod="MatlabOptimization-HessianBased"; Ua(UserVar,CtrlVar) ;
UserVar.RunType='Inverse-MatOpt' ;    CtrlVar.Inverse.MinimisationMethod="MatlabOptimization-GradientBased"; Ua(UserVar,CtrlVar) ;
UserVar.RunType='TestingMeshOptions' ; Ua(UserVar) ;
cd ..
close all

cd MassBalanceFeedback\
Ua
cd ..

cd Calving\

UserVar.RunType="Test-1dAnalyticalIceShelf-";               Ua(UserVar) ;
UserVar.RunType="Test-ManuallyDeactivateElements-" ;        Ua(UserVar) ;
UserVar.RunType="Test-CalvingThroughMassBalanceFeedback-";  Ua(UserVar) ;

cd ..

