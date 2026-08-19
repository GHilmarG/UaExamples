
function  UserVar=DefineOutputs(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo);


persistent t sMax sMin s0 iCounter


if isempty(t)
    iCounter=0;
    t=nan(1000,1);
    sMax=nan(1000,1);
    sMin=nan(1000,1);
    s0=nan(1000,1);
end

if F.time==0
   
    % Make sure to reset if there is a new run
    iCounter=0; 
    t=nan(1000,1);
    sMax=nan(1000,1);
    sMin=nan(1000,1);
    s0=nan(1000,1);

end

iCounter=iCounter+1;
t(iCounter)=F.time;

r=sqrt(F.x.*F.x+F.y.*F.y);
[rMin,iR]=min(r);

s0(iCounter)=F.s(iR);
sMax(iCounter)=max(F.s);
sMin(iCounter)=min(F.s);


plots='-ubvb-e-save-';
plots='-udvd-ubvb-speed-';
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
        %FileName=['ResultsFiles/',sprintf('%07i',round(100*F.time)),'-TransPlots-',CtrlVar.Experiment]; good for transient runs

        FileName=['ResultsFiles/',sprintf('%07i',CtrlVar.DefineOutputsCounter),'-TransPlots-',CtrlVar.Experiment];

        fprintf(' Saving data in %s \n',FileName)
        save(FileName,'CtrlVar','MUA','F')

    end
end




% only do plots at end of run

if strcmp(CtrlVar.DefineOutputsInfostring,'Last call') 
    
    sFig=FindOrCreateFigure("s(t)") ; clf(sFig) 
    yyaxis left
    plot(t,sMin,"o-",DisplayName="min(s)")
    ylabel("$\min(s)$ (m)",Interpreter="latex")
    yyaxis right
    plot(t,sMax,"s-",DisplayName="max(s)")
    lg=legend;
    xlabel("time (yr)")
    ylabel("$\max(s)$ (m)",Interpreter="latex")

    if CtrlVar.ForwardTimeIntegration=="-uvh-"
        FileName="SurfaceTime"+CtrlVar.ForwardTimeIntegration+"Theta"+num2str(CtrlVar.theta)+"_dt"+num2str(F.dt);
    else
        FileName="SurfaceTime"+CtrlVar.ForwardTimeIntegration+"uv_h_MaxIt"+num2str(CtrlVar.uv2h.MaxIterations)+"_Theta"+num2str(CtrlVar.hTheta)+"_dt"+num2str(F.dt);
    end


    
    FileName=replace(FileName,".","k")+".mat" ;
    fprintf("Saving s(t) data in the file:  %s \n",FileName)

    save(FileName,"CtrlVar","t","sMax","sMin","s0")
end

if ~strcmp(CtrlVar.DefineOutputsInfostring,'Last call') 

  return

end

%% perturbations
cbar=UaPlots(CtrlVar,MUA,F,F.s,FigureTitle="Upper Surface")  ;
CM=cmocean('balanced',25,'pivot',mean(F.s)) ; colormap(CM);
title(cbar,"(m)")

cbar=UaPlots(CtrlVar,MUA,F,F.b,FigureTitle="Lower Surface")  ;
CM=cmocean('balanced',25,'pivot',mean(F.b)) ; colormap(CM);
title(cbar,"(m)")

FindOrCreateFigure("vel pert")
QuiverColorGHG(F.x,F.y,F.ub-mean(F.ub),F.vb,CtrlVar)  ;
title("Velocity pertubations (ub,vb)")
axis equal

if contains(plots,'-sbB-')
    FindOrCreateFigure("-sbB-")
    hold off
    if isempty(TRI) ;  TRI = delaunay(x,y); end
    trisurf(TRI,F.x/CtrlVar.PlotXYscale,F.y/CtrlVar.PlotXYscale,s,'EdgeColor','none') ; hold on
    trisurf(TRI,F.x/CtrlVar.PlotXYscale,F.y/CtrlVar.PlotXYscale,b,'EdgeColor','none') ;
    trisurf(TRI,F.x/CtrlVar.PlotXYscale,F.y/CtrlVar.PlotXYscale,B,'EdgeColor','none') ;
    view(50,20); lightangle(-45,30) ; lighting phong ;
    xlabel('y') ; ylabel('x') ;
    colorbar ; title(colorbar,'(m)')
    hold on

    title(sprintf('sbB at t=%#5.1g ',F.time))
    axis equal ; tt=daspect ; daspect([mean(tt(1)+tt(2)) mean(tt(1)+tt(2)) tt(3)*CtrlVar.PlotXYscale]); axis tight
    hold off
end


if contains(plots,'-ubvb-')

    figubvb=FindOrCreateFigure("-ubvb-") ; clf(figubvb)
    % plotting horizontal velocities
    UaPlots(CtrlVar,MUA,F,"-ubvb-",CreateNewFigure=false);

    title(sprintf('(ub,vb) t=%-g ',F.time)) ; xlabel('xps (km)') ; ylabel('yps (km)')
    axis equal tight

end


if contains(plots,'-udvd-')

    figudvd=FindOrCreateFigure("-udvd-") ; clf(figudvd)
    % plotting horizontal velocities
    UaPlots(CtrlVar,MUA,F,"-udvd-",CreateNewFigure=false);

    title(sprintf('(ud,vd) t=%-g ',F.time)) ; xlabel('xps (km)') ; ylabel('yps (km)')
    axis equal tight

end


if contains(plots,'-e-')
    % plotting effective strain rates

    % first get effective strain rates, e :
    [etaInt,xint,yint,exx,eyy,exy,Eint,e,txx,tyy,txy]=calcStrainRatesEtaInt(CtrlVar,MUA,u,v,AGlen,n);
    % all these variables are are element variables defined on integration points
    % therfore if plotting on nodes, must first project these onto nodes
    eNod=ProjectFintOntoNodes(MUA,e);

    figure
    [FigHandle,ColorbarHandel,tri]=PlotNodalBasedQuantities(MUA.connectivity,MUA.coordinates,eNod,CtrlVar)    ;
    title(sprintf('e t=%-g ',F.time)) ; xlabel('x (km)') ; ylabel('y (km)')

end

if contains(plots,'-speed-')

    figspeed=FindOrCreateFigure("-speed-") ; clf(figspeed)
    % plotting horizontal velocities
    UaPlots(CtrlVar,MUA,F,"-speed-",CreateNewFigure=false,logColorbar=true);
    CM=cmocean('balanced',25,'pivot',mean(F.ub)) ; colormap(CM);
    xlabel('x (km)') ; ylabel('y (km)')
    axis equal tight

end


end
