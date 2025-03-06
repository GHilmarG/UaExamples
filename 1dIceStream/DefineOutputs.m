
function  UserVar=DefineOutputs(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo)






plots='-ubvb-e-save-';
plots='-udvd-ubvb-ub(x)-sbSB(x)-txzb(x)-';
plots='-ub(x)-h(x)-sbSB(x)-';
plots='-h(x)-ub(x)-dhdt(x)-';

TRI=[];
x=MUA.coordinates(:,1);  y=MUA.coordinates(:,2);

if contains(plots,'-save-')

    % save data in files with running names
    % check if folder 'ResultsFiles' exists, if not create

    if strcmp(CtrlVar.DefineOutputsInfostring,'First call ') && exist('ResultsFiles','dir')~=7 ;
        mkdir('ResultsFiles') ;
    end
    
    if strcmp(CtrlVar.DefineOutputsInfostring,'Last call')==0
        
        
        FileName=['ResultsFiles/',sprintf('%07i',CtrlVar.DefineOutputsCounter),'-TransPlots-',CtrlVar.Experiment];
        
        fprintf(' Saving data in %s \n',FileName)
        save(FileName,"CtrlVar","MUA","F","BCs","RunInfo","UserVar")
        
    end
end

% only do plots at end of run
% if ~strcmp(CtrlVar.DefineOutputsInfostring,'Last call') ; return ; end

[~,I]=sort(F.x) ;

if contains(plots,'-txzb(x)-')
    
    [txzb,tyzb]=CalcNodalStrainRatesAndStresses(CtrlVar,UserVar,MUA,F); 
    
    figure ;  plot(F.x/CtrlVar.PlotXYscale,txzb) ; title('txzb(x)')
    
end





Iy0Nodes=abs(F.y)<0.01; % pick out nodes that are very close to have y=0 coordinates

hy0=F.h(Iy0Nodes);
uy0=F.ub(Iy0Nodes);
dhdt0=F.dhdt(Iy0Nodes);
xy0=F.x(Iy0Nodes);
[xSorted,ISorted]=sort(xy0);



% Fh=scatteredInterpolant(F.x,F.y,F.h);
Fu=scatteredInterpolant(F.x,F.y,F.ub);
FG=scatteredInterpolant(F.x,F.y,F.GF.node);
% Fdhdt=scatteredInterpolant(F.x,F.y,F.dhdt);
xProfile=linspace(-100e3,100e3,1000);
yProfile=xProfile*0;
% hProfile=Fh(xProfile,yProfile);
uProfile=Fu(xProfile,yProfile);
% dhdtProfile=Fdhdt(xProfile,yProfile);

if contains(plots,'-ub(x)-')

    figVel=FindOrCreateFigure("Vel");
    plot(xProfile/CtrlVar.PlotXYscale,uProfile/1000,DisplayName="$v_x$ at $y=0$ (interpolated") ;
    hold on
    plot(xSorted/CtrlVar.PlotXYscale,uy0(ISorted)/1000,DisplayName="$v_x$ at $y=0$ (nodal values)",Color="g",LineStyle="none",Marker="o",MarkerFaceColor="b")

    title(sprintf('Velocity at t=%-g ',F.time)) ; 
    xlabel("$x$ (km) ",Interpreter="latex") ; 
    ylabel("Velocity, $u$, (km/yr)",Interpreter="latex")
    legend(Interpreter="latex")
    
end

if contains(plots,'-dhdt(x)-')
    figdhdt=FindOrCreateFigure("dh/dt") ;
    % plot(xProfile/CtrlVar.PlotXYscale,dhdtProfile,DisplayName="$dt/dt$ at $y=0$ (interpolated") ;
    % hold on
    plot(xSorted/CtrlVar.PlotXYscale,dhdt0(ISorted),DisplayName="$dh/dt$ at $y=0$ (nodal values)",Color="r",LineStyle="-",Marker="o",MarkerFaceColor="r")
    hold on 
    title(sprintf("$dh/dt$ at $t$=%-g ",F.time),Interpreter="latex") ; xlabel("$x$ (km)",Interpreter='latex') ; ylabel("$dh/dt$ (m/yr)",Interpreter='latex')
    legend(Interpreter="latex")
end


if contains(plots,'-h(x)-')
    fig=FindOrCreateFigure("h(x)") ; clf(fig)
    yyaxis left
    hold off


 
  %  plot(x(I)/CtrlVar.PlotXYscale,h(I),DisplayName="$h$",Color="b")
    
    % plot(xProfile/CtrlVar.PlotXYscale,hProfile,DisplayName="$h$ profile at $y=0$ (interpolated)",Color="b",LineWidth=1.5)
    % hold on
    plot(xSorted/CtrlVar.PlotXYscale,hy0(ISorted),DisplayName="$h$ at $y=0$ (nodal values)",Color="b",LineStyle="-",Marker="o",MarkerFaceColor="b")
    hold on
    ylabel("ice thickness, $h$ (m)",Interpreter="latex")
    ylim([820 1020])

    yyaxis right 
    G=FG(xProfile,yProfile);
    %plot(x(I)/CtrlVar.PlotXYscale,GF.node(I),DisplayName="$\mathcal{G}$") ;
    plot(xProfile/CtrlVar.PlotXYscale,G,DisplayName="$\mathcal{G}$") ;
    ylabel("flotation mask, $\mathcal{G}$",Interpreter="latex")
    ylim([-0.1 1.1])

    if CtrlVar.Implicituvh

        title(sprintf("fully-implicit: $h(x)$ at $t$=%-g with $\\Delta t$=%g",F.time,F.dt),interpreter="latex") ;
        subtitle(sprintf("%s with $\\beta_0$=%g, $\\theta$=%g",CtrlVar.uvhImplicitTimeSteppingMethod,CtrlVar.SUPG.beta0,CtrlVar.theta),interpreter="latex") ;

    else
     
        title(sprintf("semi-implicit: $h(x)$ at $t$=%-g with $\\Delta t$=%g",F.time,F.dt),interpreter="latex") ;
        subtitle(sprintf("%s with $\\beta_0$=%g, $\\theta$=%g",CtrlVar.uvhImplicitTimeSteppingMethod,CtrlVar.SUPG.beta0,CtrlVar.theta),interpreter="latex") ;


    end
    xlabel('$x$ (km)',Interpreter='latex') ;
    legend(Interpreter="latex")
    %fig.Position=[50 800 800 450];
    drawnow
end

if contains(plots,'-ud(x)-')
    figure
   plot(F.x/CtrlVar.PlotXYscale,ud) ;
    title(sprintf('u_d(x) at t=%-g ',F.time)) ; xlabel('x') ; ylabel('u_d')
end


if contains(plots,'-sbSB(x)-')
    figure
    
    plot(x(I)/CtrlVar.PlotXYscale,S(I),'k--') ; hold on
    plot(x(I)/CtrlVar.PlotXYscale,B(I),'k') ; 
    plot(x(I)/CtrlVar.PlotXYscale,b(I),'b') ; 
    plot(x(I)/CtrlVar.PlotXYscale,s(I),'b') ;
    
    title(sprintf('sbSB(x) at t=%-g ',F.time)) ; xlabel('x') ; ylabel('z')
    drawnow
end







end
