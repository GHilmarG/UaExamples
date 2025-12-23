function  UserVar=DefineOutputs(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo)





switch CtrlVar.DefineOutputsInfostring
    
    case 'Start of Inverse Run'
        
        plots='-meas-';
        
    otherwise
        
        return;
        
end



%plots='-sbB-udvd-ubvb-ub-';

TRI=[];


  
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
        save(FileName,'CtrlVar','MUA','F')
        
    end
end



if contains(plots,'-sbB-')
    figure(5)
    hold off
    if isempty(TRI) ;  TRI = delaunay(F.x,F.y); end
    trisurf(TRI,F.x/CtrlVar.PlotXYscale,F.y/CtrlVar.PlotXYscale,s,'EdgeColor','none') ; hold on
    trisurf(TRI,F.x/CtrlVar.PlotXYscale,F.y/CtrlVar.PlotXYscale,b,'EdgeColor','none') ;
    trisurf(TRI,F.x/CtrlVar.PlotXYscale,F.y/CtrlVar.PlotXYscale,B,'EdgeColor','none') ;
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
    speed=sqrt(F.ub.*F.ub+F.vb.*F.vb);
    CtrlVar.MinSpeedWhenPlottingVelArrows=0; CtrlVar.MaxPlottedSpeed=max(speed); %CtrlVar.VelPlotIntervalSpacing='log10';
    %CtrlVar.VelColorMap='hot';
    CtrlVar.RelativeVelArrowSize=10;
    QuiverColorGHG(F.x(1:N:end),F.y(1:N:end),F.ub(1:N:end),F.vb(1:N:end),CtrlVar);
    hold on
    title(sprintf('(ub,vb) t=%-g ',CtrlVar.time)) ; xlabel('xps (km)') ; ylabel('yps (km)')
    axis equal tight
    
end


%%
if contains(plots,'-meas-')
    % plotting horizontal velocities
    figure
    N=1;
    CtrlVar.VelPlotIntervalSpacing='log10';
    QuiverColorGHG(F.x(1:N:end),F.y(1:N:end),Meas.us(1:N:end),Meas.vs(1:N:end),CtrlVar);
    hold on
    title(sprintf('(ub,vb) t=%-g ',F.time)) ; xlabel('xps (km)') ; ylabel('yps (km)')
    axis equal tight
    
end
%%

if contains(plots,'-udvd-')
    % plotting horizontal velocities
    figure
    N=1;
    speed=sqrt(ud.*ud+vd.*vd);
    CtrlVar.MinSpeedWhenPlottingVelArrows=0; CtrlVar.MaxPlottedSpeed=max(speed); CtrlVar.VelPlotIntervalSpacing='log10';
    CtrlVar.RelativeVelArrowSize=10;
    %CtrlVar.VelColorMap='hot';
    QuiverColorGHG(F.x(1:N:end),F.y(1:N:end),F.ud(1:N:end),F.vd(1:N:end),CtrlVar);
    hold on
    title(sprintf('(ud,vd) t=%-g ',F.time)) ; xlabel('xps (km)') ; ylabel('yps (km)')
    axis equal tight
    
end

if contains(plots,'-e-')
    % plotting effective strain rates
    
    % first get effective strain rates, e :
    [etaInt,xint,yint,exx,eyy,exy,Eint,e,txx,tyy,txy]=calcStrainRatesEtaInt(CtrlVar,MUA,F.ub,F.vb,AGlen,n);
    % all these variables are are element variables defined on integration points
    % therefore if plotting on nodes, must first project these onto nodes
    eNod=ProjectFintOntoNodes(MUA,e);
    
    figure
    [FigHandle,ColorbarHandel,tri]=PlotNodalBasedQuantities(MUA.connectivity,MUA.coordinates,eNod,CtrlVar)    ;
    title(sprintf('e t=%-g ',F.time)) ; xlabel('x (km)') ; ylabel('y (km)')
    
end

if contains(plots,'-ub-')
    
    figure
    [FigHandle,ColorbarHandel,tri]=PlotNodalBasedQuantities(MUA.connectivity,MUA.coordinates,F.ub,CtrlVar)    ;
    title(sprintf('ub t=%-g ',F.time)) ; xlabel('x (km)') ; ylabel('y (km)')
    
end


end
