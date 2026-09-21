


%% Beta merge with Alpha on 21/09/2026


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
cd 
cd IceBerg
Ua
cd ..

%%
cd PIG-TWG



UserVar.RunType="Inverse-MatlabOptimisation-GradientBased-"   ;  Ua(UserVar) ;       %  01/03/2025, 19/07/2025 , 20/09/2026
UserVar.RunType="Inverse-UaOptimisation-GradientBased-"       ;  Ua(UserVar) ;       %  01/03/2025, 19/07/2025 , 20/09/2026
UserVar.RunType="Inverse-MatlabOptimisation-HessianBased-"    ;  Ua(UserVar) ;       %  01/03/2025, 19/07/2025 , 20/09/2026
UserVar.RunType="Inverse-UaOptimisation-HessianBased-"        ;  Ua(UserVar) ;       %  01/03/2025, 19/07/2025 , 20/09/2026


UserVar.RunType='TestingMeshOptions' ; Ua(UserVar) ;                                 %  01/03/2025, 19/07/2025

cd ..                   
close all

%%

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
close all

cd Inverse   
Ua           
cd ..

close all

%%

cd Greenland\
Ua
cd ..

