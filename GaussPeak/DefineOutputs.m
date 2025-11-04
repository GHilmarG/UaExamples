
function  UserVar=DefineOutputs(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo);







plots='-ubvb-e-save-';
plots='-sbB-udvd-ubvb-ub-';
%plots='-mesh-';

UserVar.CreateVideo=1;
TRI=[];
x=MUA.coordinates(:,1);  y=MUA.coordinates(:,2);

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

% 
% if contains(plots,'-mesh-')
%     
%     
%     if isempty(fig100)
%         fig100=figure(100) ;
%         %fig100.Position=[0 0 figsWidth 3*figHeights];
%         fig100.Position=[1 1 2190 1160];% full laptop window
%         
%         if UserVar.CreateVideo
%             Video100=VideoWriter('Video100.avi');
%             open(Video100);
%         end
%     else
%         fig100=figure(100) ;
%         hold off
%     end
%     
%     
%     
%     PlotMuaMesh(CtrlVar,MUA)
%     title('')
%     
%     if UserVar.CreateVideo
%         frame = getframe(gcf);
%         writeVideo(Video100,frame);
%         
%         if strcmp(CtrlVar.DefineOutputsInfostring,'Last call')
%             close(Video100)
%         end
%     end
%     
% end
% 


% only do plots at end of run
if ~strcmp(CtrlVar.DefineOutputsInfostring,'Last call') ; return ; end


if contains(plots,'-sbB-')
    FindOrCreateFigure("-sbB-")
    hold off
    if isempty(TRI) ;  TRI = delaunay(x,y); end
    trisurf(TRI,F.x/CtrlVar.PlotXYscale,F.y/CtrlVar.PlotXYscale,F.s,'EdgeColor','none') ; hold on
    trisurf(TRI,F.x/CtrlVar.PlotXYscale,F.y/CtrlVar.PlotXYscale,F.b,'EdgeColor','none') ;
    trisurf(TRI,F.x/CtrlVar.PlotXYscale,F.y/CtrlVar.PlotXYscale,F.B,'EdgeColor','none') ;
    view(50,20); lightangle(-45,30) ; lighting phong ;
    xlabel('y') ; ylabel('x') ;
    colorbar ; title(colorbar,'(m)')
    hold on
    
    title(sprintf('sbB at t=%#5.1g ',F.time))
    axis equal ; tt=daspect ; daspect([mean(tt(1)+tt(2)) mean(tt(1)+tt(2)) tt(3)*CtrlVar.PlotXYscale]); axis tight
    hold off
end


if contains(plots,'-ubvb-')
    % plotting horizontal velocities
    FindOrCreateFigure("-ubvb-")
    N=1;
    %speed=sqrt(ub.*ub+vb.*vb);
    %CtrlVar.MinSpeedWhenPlottingVelArrows=0; CtrlVar.MaxPlottedSpeed=max(speed); %CtrlVar.VelPlotIntervalSpacing='log10';
    %CtrlVar.VelColorMap='hot';
    %CtrlVar.RelativeVelArrowSize=10;
    QuiverColorGHG(F.x(1:N:end),F.y(1:N:end),F.ub(1:N:end),F.vb(1:N:end),CtrlVar);
    hold on
    title(sprintf('(ub,vb) t=%-g ',F.time)) ; xlabel('xps (km)') ; ylabel('yps (km)')
    axis equal tight
    
end

if contains(plots,'-udvd-')
    % plotting horizontal velocities
    FindOrCreateFigure("-udvd-")
    N=1;
    %speed=sqrt(ud.*ud+vd.*vd);
    %CtrlVar.VelPlotIntervalSpacing='log10';
    %CtrlVar.RelativeVelArrowSize=10;
    %CtrlVar.VelColorMap='hot';
    QuiverColorGHG(F.x(1:N:end),F.y(1:N:end),F.ud(1:N:end),F.vd(1:N:end),CtrlVar);
    hold on
    title(sprintf('(ud,vd) t=%-g ',F.time)) ; xlabel('xps (km)') ; ylabel('yps (km)')
    axis equal tight
    
end

if contains(plots,'-e-')
    % plotting effective strain rates
    
    % first get effective strain rates, e :
    [etaInt,xint,yint,exx,eyy,exy,Eint,e,txx,tyy,txy]=calcStrainRatesEtaInt(CtrlVar,MUA,F.ub,F.vb,F.AGlen,F.n);
    % all these variables are are element variables defined on integration points
    % therefore if plotting on nodes, must first project these onto nodes
    eNod=ProjectFintOntoNodes(MUA,e);
    
    FindOrCreateFigure("-e-")
    [FigHandle,ColorbarHandel,tri]=PlotNodalBasedQuantities(MUA.connectivity,MUA.coordinates,eNod,CtrlVar)    ;
    title(sprintf('e t=%-g ',F.time)) ; xlabel('x (km)') ; ylabel('y (km)')
    
end

if contains(plots,'-ub-')
    
    FindOrCreateFigure("-ub-")
    [FigHandle,ColorbarHandel,tri]=PlotNodalBasedQuantities(MUA.connectivity,MUA.coordinates,F.ub,CtrlVar)    ;
    title(sprintf('ub t=%-g ',F.time)) ; xlabel('x (km)') ; ylabel('y (km)')
    
end


end
