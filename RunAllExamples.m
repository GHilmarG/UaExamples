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


cd Inverse
Ua
cd ..
close all

cd MismipPlus
Ua
cd ..

cd PIG-TWG\
UserVar.RunType='Inverse-MatOpt'; Ua(UserVar) ;
UserVar.RunType='Inverse-ConjGrad' ; Ua(UserVar) ;
UserVar.RunType='Inverse-SteepestDesent' ; Ua(UserVar) ;
UserVar.RunType='Inverse-ConjGrad-FixPoint'; Ua(UserVar) ;
UserVar.RunType='TestingMeshOptions' ; Ua(UserVar) ;
cd ..

cd MassBalanceFeedback\
Ua
cd ..

cd Calving\

UserVar.RunType="Test-1dAnalyticalIceShelf-";               Ua(UserVar) ;
UserVar.RunType="Test-ManuallyDeactivateElements-" ;        Ua(UserVar) ;
UserVar.RunType="Test-CalvingThroughMassBalanceFeedback-";  Ua(UserVar) ;

cd ..

