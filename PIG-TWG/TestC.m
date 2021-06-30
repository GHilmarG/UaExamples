load TestSave


%%
uErr=sqrt(spdiags(Meas.usCov)); vErr=sqrt(spdiags(Meas.vsCov));
usres=(F.ub-Meas.us)./uErr;  vsres=(F.vb-Meas.vs)./vErr;

dIdCAnalyticalEstimate=2*(usres.*F.ub./uErr+vsres.*F.vb./vErr)./F.C;
dIdCAnalyticalEstimate=dIdCAnalyticalEstimate.*F.GF.node; 

FindOrCreateFigure('dIdC Analytical Estimate') ;
PlotMeshScalarVariable(CtrlVar,MUA,dIdCAnalyticalEstimate) ;
hold on
PlotMuaMesh(CtrlVar,MUA,[],'w');
title('dIdC analytical estimate')

%%