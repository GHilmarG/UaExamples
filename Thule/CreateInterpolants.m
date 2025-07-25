%%

%load  SteadyState_Restartfile_NoBasalMelt.mat
load Restart-Thule-P-SSmax-10km-.mat
Fs=scatteredInterpolant(F.x,F.y,F.s);
Fb=scatteredInterpolant(F.x,F.y,F.b);
figure ; UaPlots(CtrlVarInRestartFile,MUA,F,F.s) ;
save("SteadyStateInterpolantsThuleMax10km.mat","Fb","Fs") 

%%
load Restart-Thule-P-SSmin-10km-.mat
Fs=scatteredInterpolant(F.x,F.y,F.s);
Fb=scatteredInterpolant(F.x,F.y,F.b);
figure ; UaPlots(CtrlVarInRestartFile,MUA,F,F.s) ;
save("SteadyStateInterpolantsThuleMin10km.mat","Fb","Fs") 