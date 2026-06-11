






%%
load("Restart-Thule-P-SSmax-ES50km-Cxy-taus.mat")
%load("Restart-Thule-P-SSmax-ES50km-Cxy-taut.mat")

CtrlVar=CtrlVarInRestartFile; UserVar=UserVarInRestartFile;

UserVar.DefineOutputs="-dhdt-ubvb-s-"; 
switch CtrlVar.uvh.SUPG.tau
    case "taus"
        CtrlVar.FigTitleText=", $\tau_{\mathrm{SUPG}}=\tau_s$";
    case "taut"
        CtrlVar.FigTitleText=", $\tau_{\mathrm{SUPG}}=\tau_t$";
    case "tau1"
        CtrlVar.FigTitleText=", $\tau_{\mathrm{SUPG}}=\tau_1$";
    case "tau2"
        CtrlVar.FigTitleText=", $\tau_{\mathrm{SUPG}}=\tau_2$";
    otherwise
        error("case not found")
end

DefineOutputs(UserVar,CtrlVar,MUA,BCs,F,l,F.GF);

fig=FindOrCreateFigure("(ub,vb)") ; fig.Position=[2600 450 800 700];
fig=FindOrCreateFigure("s") ; fig.Position=[3400 450 800 700];
fig=FindOrCreateFigure("dh/dt") ; fig.Position=[4200 450 800 700];
%%

