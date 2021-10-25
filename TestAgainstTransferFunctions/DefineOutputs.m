function  UserVar=DefineOutputs(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo)



time=CtrlVar.time; 

         

plots='-ubvb-e-save-';
plots='-sbB-udvd-ubvb-ub-';
plots='-ubvb-stresses-';
plots='-flowline-';


x=MUA.coordinates(:,1);  y=MUA.coordinates(:,2);
GLgeo=[];
xGL=[];
yGL=[];

if contains(plots,'-save-')

    % save data in files with running names
    % check if folder 'ResultsFiles' exists, if not create

    if strcmp(CtrlVar.DefineOutputsInfostring,'First call ') && exist('ResultsFiles','dir')~=7 
        mkdir('ResultsFiles') ;
    end
    
    if strcmp(CtrlVar.DefineOutputsInfostring,'Last call')==0
        %FileName=['ResultsFiles/',sprintf('%07i',round(100*time)),'-TransPlots-',CtrlVar.Experiment]; good for transient runs
        
        FileName=['ResultsFiles/',sprintf('%07i',CtrlVar.DefineOutputsCounter),'-TransPlots-',CtrlVar.Experiment];
        
        fprintf(' Saving data in %s \n',FileName)
        save(FileName,"CtrlVar","MUA","F")
        
    end
end


%% Transfer



if contains(plots,'-flowline-')
    
    [sAna,uAna,vAna,wAna]=TransferFunctionsGauss(UserVar,CtrlVar,MUA,F) ;
    
    FindOrCreateFigure("-s-ub-")
    hold off
    yyaxis left
    plot(F.x/1000,F.s,"ob")
    hold on
    plot(F.x/1000,sAna,".b")
    ylabel("$s(x,t)$ (m)","interpreter","latex") ;
    ylim([900 1100])
    yyaxis right
    hold off
    plot(F.x/1000,F.ub,"or")
    hold on
    plot(F.x/1000,uAna,".r")
    ylim([900 1100])
    ylabel("$u_b(x,t)$ (m)","interpreter","latex") ;
    xlabel("$x$ (km)","interpreter","latex") ;
    title(sprintf("upper surface and basal velocity at t=%f",F.time),"interpreter","latex")
    legend("$s$ (numerical)","$s$ (analytical)","$u_b$ (numerical)","$u_b$ (analytical)",...
        "interpreter","latex","location","southeast")
    hold off
    
end








% only do these additonal plots at end of run


if ~strcmp(CtrlVar.DefineOutputsInfostring,'Last call') ; return ; end



if contains(plots,'-stresses-')
    %%
    [tbx,tby,tb] = CalcBasalTraction(CtrlVar,UserVar,MUA,F) ;
    
    [txzb,tyzb]=CalcNodalStrainRatesAndStresses(CtrlVar,UserVar,MUA,F);
    FindOrCreateFigure("-stresses-")
    PlotMeshScalarVariable(CtrlVar,MUA,tb) ;
    title(' tb ') ; cbar=colorbar; title(cbar, '(kPa)');
    hold on
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL,'r');
    
    
    FindOrCreateFigure("-txzb-")
    PlotMeshScalarVariable(CtrlVar,MUA,txzb) ;
    title(' txzb ') ; cbar=colorbar; title(cbar, '(kPa)');
    hold on
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL,'r');
    
end



if contains(plots,'-ubvb-')
    % plotting horizontal velocities
    FindOrCreateFigure("-ubvb-")
    N=1;
    speed=sqrt(ub.*ub+vb.*vb);
    CtrlVar.MinSpeedWhenPlottingVelArrows=0; CtrlVar.MaxPlottedSpeed=max(speed); %CtrlVar.VelPlotIntervalSpacing='log10';
    %CtrlVar.VelColorMap='hot';
    CtrlVar.RelativeVelArrowSize=10;
    QuiverColorGHG(x(1:N:end),y(1:N:end),ub(1:N:end),vb(1:N:end),CtrlVar);
    hold on
    title(sprintf('(ub,vb) t=%-g ',time)) ; xlabel('xps (km)') ; ylabel('yps (km)')
    axis equal tight
    
end

if contains(plots,'-udvd-')
    % plotting horizontal velocities
    FindOrCreateFigure("-udvd-")
    N=1;
    speed=sqrt(ud.*ud+vd.*vd);
    CtrlVar.MinSpeedWhenPlottingVelArrows=0; CtrlVar.MaxPlottedSpeed=max(speed); %CtrlVar.VelPlotIntervalSpacing='log10';
    CtrlVar.RelativeVelArrowSize=10;
    %CtrlVar.VelColorMap='hot';
    QuiverColorGHG(x(1:N:end),y(1:N:end),ud(1:N:end),vd(1:N:end),CtrlVar);
    hold on
    title(sprintf('(ud,vd) t=%-g ',time)) ; xlabel('xps (km)') ; ylabel('yps (km)')
    axis equal tight
    
    dsdx=tan(0.1);
    hmean=mean(s-b);
    taud=mean(rho*g*dsdx*hmean);
    udAnalytical=2*mean(AGlen)*taud.^mean(n)*hmean./mean(n+1); 
    
end

if contains(plots,'-e-')
    % plotting effectiv strain rates
    
    % first get effective strain rates, e :
    [etaInt,xint,yint,exx,eyy,exy,Eint,e,txx,tyy,txy]=calcStrainRatesEtaInt(CtrlVar,MUA,u,v,AGlen,n);
    % all these variables are are element variables defined on integration points
    % therfore if plotting on nodes, must first project these onto nodes
    eNod=ProjectFintOntoNodes(MUA,e);
    
    FindOrCreateFigure("-effective strain rate-")
    [FigHandle,ColorbarHandel,tri]=PlotNodalBasedQuantities(MUA.connectivity,MUA.coordinates,eNod,CtrlVar)    ;
    title(sprintf('e t=%-g ',time)) ; xlabel('x (km)') ; ylabel('y (km)')
    
end

if contains(plots,'-ub-')
    
    FindOrCreateFigure("-ud-")
    [FigHandle,ColorbarHandel,tri]=PlotNodalBasedQuantities(MUA.connectivity,MUA.coordinates,ub,CtrlVar)    ;
    title(sprintf('ub t=%-g ',time)) ; xlabel('x (km)') ; ylabel('y (km)')
    
end





end
