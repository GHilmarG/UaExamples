
function  UserVar=DefineOutputs(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo)

v2struct(F);

time=CtrlVar.time; 


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
        %FileName=['ResultsFiles/',sprintf('%07i',round(100*time)),'-TransPlots-',CtrlVar.Experiment]; good for transient runs
        
        FileName=['ResultsFiles/',sprintf('%07i',CtrlVar.DefineOutputsCounter),'-TransPlots-',CtrlVar.Experiment];
        
        fprintf(' Saving data in %s \n',FileName)
        save(FileName,'CtrlVar','MUA','time','s','b','S','B','h','u','v','dhdt','dsdt','dbdt','C','AGlen','m','n','rho','rhow','as','ab','GF')
        
    end
end

% only do plots at end of run
if ~strcmp(CtrlVar.DefineOutputsInfostring,'Last call') ; return ; end

[~,I]=sort(x) ;

if contains(plots,'-txzb(x)-')
    
    [txzb,tyzb]=CalcNodalStrainRatesAndStresses(CtrlVar,MUA,AGlen,n,C,m,GF,s,b,ub,vb);
    
    figure ;  plot(x/CtrlVar.PlotXYscale,txzb) ; title('txzb(x)')
    
end


if contains(plots,'-ub(x)-')
    figure
    plot(x(I)/CtrlVar.PlotXYscale,ub(I)) ;
    title(sprintf('u_b(x) at t=%-g ',time)) ; xlabel('x') ; ylabel('u_b')
    drawnow
end


if contains(plots,'-dhdt(x)-')
    figure
    plot(x(I)/CtrlVar.PlotXYscale,dhdt(I)) ;
    title(sprintf("$dh/dt$ at $t$=%-g ",time),Interpreter="latex") ; xlabel("$x$ (km)",Interpreter='latex') ; ylabel("$dh/dt$ (m/yr)",Interpreter='latex')
    drawnow
end


if contains(plots,'-h(x)-')
    fig=figure;
    yyaxis left

    plot(x(I)/CtrlVar.PlotXYscale,h(I),DisplayName="$h$")
    ylabel("ice thickness, $h$ (m)",Interpreter="latex")

    yyaxis right 
    plot(x(I)/CtrlVar.PlotXYscale,GF.node(I),DisplayName="$\mathcal{G}$") ;
    ylabel("flotation mask, $\mathcal{G}$",Interpreter="latex")
    
    if CtrlVar.Implicituvh
        title(sprintf("fully-implicit: $h(x)$ at $t$=%-g, %s, $\\theta$=%g",time,CtrlVar.uvhImplicitTimeSteppingMethod,CtrlVar.theta),interpreter="latex") ;
    else
          title(sprintf("semi-implicit: $h(x)$ at $t$=%-g, %s, $\\theta$=%g",time,CtrlVar.uvhImplicitTimeSteppingMethod,CtrlVar.theta),interpreter="latex") ;
    end
    xlabel('$x$ (km)',Interpreter='latex') ; 
    legend(Interpreter="latex")
    fig.Position=[50 800 800 450];
    drawnow
end

if contains(plots,'-ud(x)-')
    figure
   plot(x/CtrlVar.PlotXYscale,ud) ;
    title(sprintf('u_d(x) at t=%-g ',time)) ; xlabel('x') ; ylabel('u_d')
end


if contains(plots,'-sbSB(x)-')
    figure
    
    plot(x(I)/CtrlVar.PlotXYscale,S(I),'k--') ; hold on
    plot(x(I)/CtrlVar.PlotXYscale,B(I),'k') ; 
    plot(x(I)/CtrlVar.PlotXYscale,b(I),'b') ; 
    plot(x(I)/CtrlVar.PlotXYscale,s(I),'b') ;
    
    title(sprintf('sbSB(x) at t=%-g ',time)) ; xlabel('x') ; ylabel('z')
    drawnow
end


if contains(plots,'-sbB-')
    figure(5)
    hold off
    if isempty(TRI) ;  TRI = delaunay(x,y); end
    trisurf(TRI,x/CtrlVar.PlotXYscale,y/CtrlVar.PlotXYscale,s,'EdgeColor','none') ; hold on
    trisurf(TRI,x/CtrlVar.PlotXYscale,y/CtrlVar.PlotXYscale,b,'EdgeColor','none') ;
    trisurf(TRI,x/CtrlVar.PlotXYscale,y/CtrlVar.PlotXYscale,B,'EdgeColor','none') ;
    view(50,20); lightangle(-45,30) ; lighting phong ;
    xlabel('y') ; ylabel('x') ;
    colorbar ; title(colorbar,'(m)')
    hold on
    
    title(sprintf('sbB at t=%#5.1g ',time))
    axis equal ; tt=daspect ; daspect([mean(tt(1)+tt(2)) mean(tt(1)+tt(2)) tt(3)*CtrlVar.PlotXYscale]); axis tight
    hold off
end


if contains(plots,'-ubvb-')
    % plotting horizontal velocities
    figure
    N=1;
    %speed=sqrt(ub.*ub+vb.*vb);
    %CtrlVar.VelPlotIntervalSpacing='log10';
    %CtrlVar.VelColorMap='hot';
    %CtrlVar.RelativeVelArrowSize=10;
    QuiverColorGHG(x(1:N:end),y(1:N:end),ub(1:N:end),vb(1:N:end),CtrlVar);
    hold on
    title(sprintf('(ub,vb) t=%-g ',time)) ; xlabel('xps (km)') ; ylabel('yps (km)')
    axis equal tight
    
end

if contains(plots,'-udvd-')
    % plotting horizontal velocities
    figure
    N=1;
    %speed=sqrt(ud.*ud+vd.*vd);
    %CtrlVar.VelPlotIntervalSpacing='log10';
    %CtrlVar.RelativeVelArrowSize=10;
    %CtrlVar.VelColorMap='hot';
    QuiverColorGHG(x(1:N:end),y(1:N:end),ud(1:N:end),vd(1:N:end),CtrlVar);
    hold on
    title(sprintf('(ud,vd) t=%-g ',time)) ; xlabel('xps (km)') ; ylabel('yps (km)')
    axis equal tight
    
end

if contains(plots,'-e-')
    % plotting effectiv strain rates
    
    % first get effective strain rates, e :
    [etaInt,xint,yint,exx,eyy,exy,Eint,e,txx,tyy,txy]=calcStrainRatesEtaInt(CtrlVar,MUA,u,v,AGlen,n);
    % all these variables are are element variables defined on integration points
    % therfore if plotting on nodes, must first project these onto nodes
    eNod=ProjectFintOntoNodes(MUA,e);
    
    figure
    [FigHandle,ColorbarHandel,tri]=PlotNodalBasedQuantities(MUA.connectivity,MUA.coordinates,eNod,CtrlVar)    ;
    title(sprintf('e t=%-g ',time)) ; xlabel('x (km)') ; ylabel('y (km)')
    
end

if contains(plots,'-ub-')
    
    figure
    [FigHandle,ColorbarHandel,tri]=PlotNodalBasedQuantities(MUA.connectivity,MUA.coordinates,ub,CtrlVar)    ;
    title(sprintf('ub t=%-g ',time)) ; xlabel('x (km)') ; ylabel('y (km)')
    
end


end
