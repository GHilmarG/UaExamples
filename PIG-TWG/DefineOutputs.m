function  UserVar=DefineOutputs(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo)

v2struct(F);  % create seperate variables for each subfield in F, so we for example get a variable "s" that is the same as the field "F.s" 


CtrlVar.DefineOutputs='-sbB-ubvb-BCs-';


%%
if ~isfield(CtrlVar,'DefineOutputs')
    CtrlVar.uvPlotScale=[];
    %plots='-ubvb-udvd-log10(C)-log10(Surfspeed)-log10(DeformationalSpeed)-log10(BasalSpeed)-log10(AGlen)-';
    plots='-ubvb-log10(BasalSpeed)-sbB-ab-log10(C)-log10(AGlen)-';
    plots='-save-';
else
    plots=CtrlVar.DefineOutputs;
end



CtrlVar.QuiverColorPowRange=2; 

%%
GLgeo=GLgeometry(MUA.connectivity,MUA.coordinates,GF,CtrlVar);
TRI=[]; DT=[]; xGL=[] ; yGL=[] ;
x=MUA.coordinates(:,1);  y=MUA.coordinates(:,2);

%%

if contains(plots,'-save-')

    % save data in files with running names
    % check if folder 'ResultsFiles' exists, if not create
   if strcmp(CtrlVar.DefineOutputsInfostring,'First call ') && exist(fullfile(cd,'ResultsFiles'),'dir')~=7 ;
        mkdir('ResultsFiles') ;
    end
    
    if strcmp(CtrlVar.DefineOutputsInfostring,'Last call')==0
                
        FileName=sprintf('ResultsFiles/%07i-Nodes%i-Ele%i-Tri%i-kH%i-%s.mat',...
            round(100*CtrlVar.time),MUA.Nnodes,MUA.Nele,MUA.nod,1000*CtrlVar.kH,CtrlVar.Experiment);
        fprintf(' Saving data in %s \n',FileName)
        save(FileName,"CtrlVar","MUA","F")
        
    end
end



% only do plots at end of run
if ~strcmp(CtrlVar.DefineOutputsInfostring,'Last call') ; return ; end

if contains(plots,'-BCs-')
    %%
    figure ;
    PlotBoundaryConditions(CtrlVar,MUA,BCs)
    hold on ;
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL,'r');
    PlotMuaBoundary(CtrlVar,MUA,'b')
    %%
end


if contains(plots,'-sbB-')
%%
    figure
    hold off
    AspectRatio=3; 
    ViewAndLight(1)=-40 ;  ViewAndLight(2)=20 ;
    ViewAndLight(3)=30 ;  ViewAndLight(4)=50;
    [TRI,DT]=Plot_sbB(CtrlVar,MUA,s,b,B,TRI,DT,AspectRatio,ViewAndLight);
%%   
end

if contains(plots,'-B-')
    figure ;
    PlotMeshScalarVariable(CtrlVar,MUA,B);
    hold on ;
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL,'g');
    PlotMuaBoundary(CtrlVar,MUA,'b')
end


if contains(plots,'-ubvb-')
    % plotting horizontal velocities
%%
    figure
    N=1;
    %speed=sqrt(ub.*ub+vb.*vb);
    %CtrlVar.MinSpeedWhenPlottingVelArrows=0; CtrlVar.MaxPlottedSpeed=max(speed); %
    CtrlVar.VelPlotIntervalSpacing='log10';
    %CtrlVar.VelColorMap='hot';
    %CtrlVar.RelativeVelArrowSize=10;
    
    QuiverColorGHG(x(1:N:end),y(1:N:end),ub(1:N:end),vb(1:N:end),CtrlVar);
    hold on ; 
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL,'k');
    PlotMuaBoundary(CtrlVar,MUA,'b')
    title(sprintf('(ub,vb) t=%-g ',CtrlVar.time)) ; xlabel('x (km)') ; ylabel('y (km)')
    %%
    
end

if contains(plots,'-udvd-')
    % plotting horizontal velocities
    figure
    N=1;
    %speed=sqrt(ud.*ud+vd.*vd);
    %CtrlVar.MinSpeedWhenPlottingVelArrows=0; CtrlVar.MaxPlottedSpeed=max(speed); 
    CtrlVar.VelPlotIntervalSpacing='log10';
    %CtrlVar.RelativeVelArrowSize=10;
    %CtrlVar.VelColorMap='hot';
    QuiverColorGHG(x(1:N:end),y(1:N:end),ud(1:N:end),vd(1:N:end),CtrlVar);
    hold on ;
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL,'k');
    PlotMuaBoundary(CtrlVar,MUA,'b')
    title(sprintf('(ud,vd) t=%-g ',CtrlVar.time)) ; xlabel('xps (km)') ; ylabel('yps (km)')
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
    hold on ; 
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL,'k');
    PlotMuaBoundary(CtrlVar,MUA,'b')
    title(sprintf('e t=%-g ',CtrlVar.time)) ; xlabel('x (km)') ; ylabel('y (km)')
    
end

if contains(plots,'-ub-')
    
    figure
    [FigHandle,ColorbarHandel,tri]=PlotNodalBasedQuantities(MUA.connectivity,MUA.coordinates,ub,CtrlVar)    ;
    hold on ;
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL,'k');
    PlotMuaBoundary(CtrlVar,MUA,'b')
    title(sprintf('ub t=%-g ',CtrlVar.time)) ; xlabel('x (km)') ; ylabel('y (km)')
    
end


if contains(plots,'-log10(AGlen)-')
%%    
    figure
    PlotMeshScalarVariable(CtrlVar,MUA,log10(AGlen));
    hold on ; 
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL,'k');
    PlotMuaBoundary(CtrlVar,MUA,'b')
    title(sprintf('log_{10}(AGlen) t=%-g ',CtrlVar.time)) ; xlabel('x (km)') ; ylabel('y (km)')
    title(colorbar,'log_{10}(yr^{-1} kPa^{-3})')
%%
end


if contains(plots,'-log10(C)-')
%%    
    figure
    PlotMeshScalarVariable(CtrlVar,MUA,log10(C));
    hold on 
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL,'k');
    PlotMuaBoundary(CtrlVar,MUA,'b')
    title(sprintf('log_{10}(C) t=%-g ',CtrlVar.time)) ; xlabel('x (km)') ; ylabel('y (km)')
    title(colorbar,'log_{10}(m yr^{-1} kPa^{-3})')
%%
end


if contains(plots,'-C-')
    
    figure
    PlotElementBasedQuantities(MUA.connectivity,MUA.coordinates,C,CtrlVar);
    title(sprintf('C t=%-g ',CtrlVar.time)) ; xlabel('x (km)') ; ylabel('y (km)')
    
end


if contains(plots,'-log10(SurfSpeed)-')
    
    us=ub+ud;  vs=vb+vd;
    SurfSpeed=sqrt(us.*us+vs.*vs);
    
    figure
    PlotNodalBasedQuantities(MUA.connectivity,MUA.coordinates,log10(SurfSpeed),CtrlVar);
    hold on ;
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL,'k');
    PlotMuaBoundary(CtrlVar,MUA,'b')
    
    title(sprintf('log_{10}(Surface speed) t=%-g ',CtrlVar.time)) ; xlabel('x (km)') ; ylabel('y (km)')
    title(colorbar,'log_{10}(m/yr)')
end



if contains(plots,'-log10(BasalSpeed)-')
    BasalSpeed=sqrt(ub.*ub+vb.*vb); 
    figure
    PlotNodalBasedQuantities(MUA.connectivity,MUA.coordinates,log10(BasalSpeed),CtrlVar);
    hold on
    plot(GLgeo(:,[3 4])'/CtrlVar.PlotXYscale,GLgeo(:,[5 6])'/CtrlVar.PlotXYscale,'k','LineWidth',1);
    title(sprintf('log_{10}(Basal speed) t=%-g ',CtrlVar.time)) ; xlabel('x (km)') ; ylabel('y (km)') ; title(colorbar,'log_{10}(m/yr)')
end



if contains(plots,'-log10(DeformationalSpeed)-')
    DeformationalSpeed=sqrt(ud.*ud+vd.*vd); 
    figure
    PlotNodalBasedQuantities(MUA.connectivity,MUA.coordinates,log10(DeformationalSpeed),CtrlVar);
    hold on
    plot(GLgeo(:,[3 4])'/CtrlVar.PlotXYscale,GLgeo(:,[5 6])'/CtrlVar.PlotXYscale,'k','LineWidth',1);
    title(sprintf('log_{10}(Deformational speed) t=%-g ',CtrlVar.time)) ; xlabel('x (km)') ; ylabel('y (km)') ; title(colorbar,'log_{10}(m/yr)')
end


if contains(plots,'-ab-')
%%
    figure
    
    PlotMeshScalarVariable(CtrlVar,MUA,ab)
    hold on
    plot(GLgeo(:,[3 4])'/CtrlVar.PlotXYscale,GLgeo(:,[5 6])'/CtrlVar.PlotXYscale,'k','LineWidth',1);
    title(sprintf('ab t=%-g ',CtrlVar.time)) ; xlabel('x (km)') ; ylabel('y (km)') ; title(colorbar,'(m/yr)')
    axis equal
%%
end


if contains(plots,'-as-')
%%
    figure
    PlotMeshScalarVariable(CtrlVar,MUA,as)
    hold on
    plot(GLgeo(:,[3 4])'/CtrlVar.PlotXYscale,GLgeo(:,[5 6])'/CtrlVar.PlotXYscale,'k','LineWidth',1);
    title(sprintf('as t=%-g ',CtrlVar.time)) ; xlabel('x (km)') ; ylabel('y (km)') ; title(colorbar,'(m/yr)')
    axis equal
%%
end

if contains(plots,'-h-')
%%
    figure
    PlotMeshScalarVariable(CtrlVar,MUA,h)
    hold on
    plot(GLgeo(:,[3 4])'/CtrlVar.PlotXYscale,GLgeo(:,[5 6])'/CtrlVar.PlotXYscale,'k','LineWidth',1);
    
    I=h<=CtrlVar.ThickMin;
    plot(MUA.coordinates(I,1)/CtrlVar.PlotXYscale,MUA.coordinates(I,2)/CtrlVar.PlotXYscale,'.r')
    title(sprintf('h t=%-g ',CtrlVar.time)) ; xlabel('x (km)') ; ylabel('y (km)') ; title(colorbar,'(m/yr)')
    axis equal
%%
end
%%
if contains(plots,'-stresses-')
    
    figure

    [txzb,tyzb,txx,tyy,txy,exx,eyy,exy,e]=CalcNodalStrainRatesAndStresses(CtrlVar,MUA,AGlen,n,C,m,GF,s,b,ub,vb,ud,vd);
    N=10;
    
    %xmin=-750e3 ; xmax=-620e3 ; ymin=1340e3 ; ymax = 1460e3 ;
    %I=find(x>xmin & x< xmax & y>ymin & y< ymax) ;
    %I=I(1:N:end);
    I=1:N:MUA.Nnodes;
    
    scale=1e-2;
    PlotTensor(x(I)/CtrlVar.PlotXYscale,y(I)/CtrlVar.PlotXYscale,txx(I),txy(I),tyy(I),scale);
    hold on
    plot(x(MUA.Boundary.Edges)/CtrlVar.PlotXYscale, y(MUA.Boundary.Edges)/CtrlVar.PlotXYscale, 'k', 'LineWidth',2) ;
    hold on ; plot(GLgeo(:,[3 4])'/CtrlVar.PlotXYscale,GLgeo(:,[5 6])'/CtrlVar.PlotXYscale,'k','LineWidth',1);
    axis equal
    axis([xmin xmax ymin ymax]/CtrlVar.PlotXYscale)
    xlabel(CtrlVar.PlotsXaxisLabel) ;
    ylabel(CtrlVar.PlotsYaxisLabel) ;
    
end
end
