




function  UserVar=DefineOutputs(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo)


persistent cyMax ctime icCounter iGLCounter GLMax GLtime    


if isempty(cyMax)

    icCounter=0 ;
    cyMax=NaN(10000,1) ; 
    ctime=NaN(10000,1) ;
    iGLCounter=0 ;
    GLMax=NaN(10000,1) ; 
    GLtime=NaN(10000,1) ; 

end

if icCounter > numel(cyMax)
   
    cyMax=[cyMax;cyMax+NaN];
    ctime=[ctime;ctime+NaN];

end

if iGLCounter > numel(GLMax)
   
    GLMax=[GLMax;GLMax+NaN];
    GLtime=[GLtime;GLtime+NaN];

end


% f=gcf; exportgraphics(f,'VAF-VC1k1.pdf')


%%
if ~isfield(UserVar,'DefineOutputs')
    
    UserVar.DefineOutputs="-ubvb-LSF-h-sbB-s-";
    plots=UserVar.DefineOutputs  ; 
    % plots='-ubvb-log10(BasalSpeed)-sbB-ab-log10(C)-log10(AGlen)-save-';
    % plots='-save-';
else
    plots=UserVar.DefineOutputs;
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


    if CtrlVar.DefineOutputsInfostring == "First call" && ~isfolder(UserVar.ResultsFileDirectory)
        mkdir(UserVar.ResultsFileDirectory)
    end


    if strcmp(CtrlVar.DefineOutputsInfostring,'Last call')==0

        FileName=sprintf('%s%07i-Nodes%i-Ele%i-Tri%i-kH%i-%s.mat',...
            UserVar.ResultsFileDirectory,...
            round(100*CtrlVar.time),MUA.Nnodes,MUA.Nele,MUA.nod,1000*CtrlVar.kH,CtrlVar.Experiment);
        FileName=replace(FileName,"--","-");
        fprintf(' Saving data in %s \n',FileName)
        save(FileName,"CtrlVar","MUA","F")

    end
end



% only do plots at end of run
% if ~strcmp(CtrlVar.DefineOutputsInfostring,'Last call') ; return ; end

if contains(plots,'-BCs-')
    %%
    FindOrCreateFigure("BCs");
    PlotBoundaryConditions(CtrlVar,MUA,BCs);
    hold on ;
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,'r');
    PlotMuaBoundary(CtrlVar,MUA,'b')
    %%
end


if contains(plots,'-LSF-')

    FLSF=FindOrCreateFigure("LSF") ;
    clf(FLSF) ; 
    hold off
    [~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,F.LSF/1000);
    title(sprintf('LSF at t=%g (yr)',CtrlVar.time)) ;
    hold on
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,"color","r");
    [xc,yc]=PlotCalvingFronts(CtrlVar,MUA,F,'b',LineWidth=2);
    title(cbar,"(km)")
    axis tight
    hold off


    FindOrCreateFigure("Calving Rate") ;
    hold off
    [~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,F.c);
    title(sprintf('Calving Rate at t=%g (yr)',CtrlVar.time)) ;
    hold on
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,"color","r");
    [xc,yc]=PlotCalvingFronts(CtrlVar,MUA,F,'b',LineWidth=2);
    title(cbar,"(km)")
    axis tight
    hold off


    if ~isempty(yc)
        icCounter=icCounter+1;
        cyMax(icCounter)=max(yc) ;
        ctime(icCounter)=F.time ;


        FindOrCreateFigure(" yc(t)")
        hold off
        plot(ctime,cyMax/1000,'or')
        xlabel("t (yr)")
        ylabel(" y-calving front (km) ")

    end


    if ~isempty(yGL)

        iGLCounter=iGLCounter+1;
        GLMax(iGLCounter)=max(yGL) ;
        GLtime(iGLCounter)=F.time ;


        FindOrCreateFigure(" yGL(t)")
        hold off
        plot(GLtime,GLMax/1000,'or')
        xlabel("t (yr)")
        ylabel(" y-GL  (km) ")

    end




   

   FindOrCreateFigure("sbB")




%    [xp,yp,d]=CreatePIGprofile(2);
% 
%    Fs=scatteredInterpolant() ; 
%    Fs.Points=[F.x(:) ,F.y(:)];
%    Fb=Fs;
%    FB=Fs;
%    Fs.Values=F.s;
%    Fb.Values=F.b;
%    FB.Values=F.B;
%    sp=Fs(xp,yp) ; 
%    bp=Fb(xp,yp) ; 
%    Bp=FB(xp,yp) ; 
%    
%    FindOrCreateFigure("profile")
%    plot(d/1000,sp,'-b')
%    hold on
%    plot(d/1000,bp,'-b')
%    plot(d/1000,Bp,'-k')
%    title(sprintf('PIG profile at t=%g (yr)',CtrlVar.time),Interpreter="latex") ;
%    xlabel(" distance (km) ",Interpreter="latex")
%    ylabel("$s$, $b$ and $B$ (m) ",Interpreter="latex")

end

if contains(plots,'-sbB-')
%%
    FIGsbB=FindOrCreateFigure("sbB"); clf(FIGsbB);
    hold off
    AspectRatio=3; 
    ViewAndLight(1)=-40 ;  ViewAndLight(2)=20 ;
    ViewAndLight(3)=30 ;  ViewAndLight(4)=50;
    sCol=[1 1 1]; bCol=[0 0 1]; BCol=[0.5 0.5 0.5] ; 
    [TRI,DT]=Plot_sbB(CtrlVar,MUA,F.s,F.b,F.B,TRI,DT,AspectRatio,ViewAndLight,[],sCol,bCol,BCol);
%%   
end



if contains(plots,'-B-')
    FindOrCreateFigure("B");
    hold off
    [~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,F.B);
    hold on ;
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,'r');
    [xc,yc]=PlotCalvingFronts(CtrlVar,MUA,F,'w',LineWidth=2);
    PlotMuaBoundary(CtrlVar,MUA,'b')
    title(colorbar,'(m)')
    title("Bedrock")

end



if contains(plots,'-dhdt-')
    Fdhdt=FindOrCreateFigure("dh/dt");  clf(Fdhdt); 
    hold off
    [~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,F.dhdt);
    hold on ;
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,'r');
    [xc,yc]=PlotCalvingFronts(CtrlVar,MUA,F,'w',LineWidth=2);
    PlotMuaBoundary(CtrlVar,MUA,'b')
    title(colorbar,'(m/yr)')
    title("$dh/dt$",Interpreter="latex")

end



if contains(plots,'-s-')
    FIGs=FindOrCreateFigure("s");  clf(FIGs)  ; hold off
    [~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,F.s);
    hold on ;
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,'r');
    [xc,yc]=PlotCalvingFronts(CtrlVar,MUA,F,'w',LineWidth=2);
    PlotMuaBoundary(CtrlVar,MUA,'b')
    title(colorbar,'(m)')
    title("upper surface")
end



if contains(plots,'-ubvb-')
    % plotting horizontal velocities
%%
    FIGubvb=FindOrCreateFigure("(ub,vb)") ; clf(FIGubvb);
    hold off
    N=1;
    %speed=sqrt(ub.*ub+vb.*vb);
    %CtrlVar.MinSpeedWhenPlottingVelArrows=0; CtrlVar.MaxPlottedSpeed=max(speed); %
    CtrlVar.VelPlotIntervalSpacing='log10';
    %CtrlVar.VelColorMap='hot';
    %CtrlVar.RelativeVelArrowSize=10;
    
    % I=F.LSF<0 ; F.ub(I)=0; F.vb(I)=0; 
    QuiverColorGHG(F.x(1:N:end),F.y(1:N:end),F.ub(1:N:end),F.vb(1:N:end),CtrlVar);
    hold on ; 
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,'k');
    [xc,yc]=PlotCalvingFronts(CtrlVar,MUA,F,'b',LineWidth=2);
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
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,'k');
    PlotMuaBoundary(CtrlVar,MUA,'b')
    title(sprintf('(ud,vd) t=%-g ',CtrlVar.time)) ; xlabel('xps (km)') ; ylabel('yps (km)')
    axis equal tight
    
end

% if contains(plots,'-log10speed-')
%     FindOrCreateFigure("-log10speed-")
%     cbar=UaPlots(CtrlVar,MUA,F,"-log10speed-") ;
%     title(sprintf('log10(speed) at t=%-g ',CtrlVar.time)) ; xlabel('xps (km)') ; ylabel('yps (km)')
%     title(cbar,"$\log_{10}(\| \mathbf{v} \|)$",Interpreter="latex")
%   
% end

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
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,'k');
    PlotMuaBoundary(CtrlVar,MUA,'b')
    title(sprintf('e t=%-g ',CtrlVar.time)) ; xlabel('x (km)') ; ylabel('y (km)')
    
end


if contains(plots,'-log10(AGlen)-')
%%    
    figure
    PlotMeshScalarVariable(CtrlVar,MUA,log10(AGlen));
    hold on ; 
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,'k');
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
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,'k');
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
    
    FindOrCreateFigure("SurfSpeed") ; 
    PlotNodalBasedQuantities(MUA.connectivity,MUA.coordinates,log10(SurfSpeed),CtrlVar);
    hold on ;
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,'k');
    [xc,yc]=PlotCalvingFronts(CtrlVar,MUA,F,'b',LineWidth=2);
    PlotMuaBoundary(CtrlVar,MUA,'b')
    
    title(sprintf('log_{10}(Surface speed) t=%-g ',CtrlVar.time)) ; xlabel('x (km)') ; ylabel('y (km)')
    title(colorbar,'log_{10}(m/yr)')
end



if contains(plots,'-log10(BasalSpeed)-')
    BasalSpeed=sqrt(ub.*ub+vb.*vb); 
    FindOrCreateFigure("Basal Speed")  ;  
    PlotNodalBasedQuantities(MUA.connectivity,MUA.coordinates,log10(BasalSpeed),CtrlVar);
    hold on
    plot(GLgeo(:,[3 4])'/CtrlVar.PlotXYscale,GLgeo(:,[5 6])'/CtrlVar.PlotXYscale,'k','LineWidth',1);
    title(sprintf('log_{10}(Basal speed) t=%-g ',CtrlVar.time)) ; xlabel('x (km)') ; ylabel('y (km)') ; title(colorbar,'log_{10}(m/yr)')
end






if contains(plots,'-h-')
%%
  
    UaPlots(CtrlVar,MUA,F,F.h,FigureTitle="Ice thickness")
    hold on

    % Plot nodes where ice thickness below min value in red
    %I=F.h<=CtrlVar.ThickMin;
    %plot(MUA.coordinates(I,1)/CtrlVar.PlotXYscale,MUA.coordinates(I,2)/CtrlVar.PlotXYscale,'.r')

    title(sprintf('h t=%-g ',CtrlVar.time)) ; 
    xlabel('x (km)') ; ylabel('y (km)') ; 
    title(colorbar,'(m)')
    axis equal
    colormap(othercolor("Mdarkterrain",25))  ; % reasonably good for topography
%%
end
%%
if contains(plots,'-stresses-')
    
    figure

    [txzb,tyzb,txx,tyy,txy,exx,eyy,exy,e]=CalcNodalStrainRatesAndStresses(CtrlVar,MUA,AGlen,n,C,m,F.GF,s,b,ub,vb,ud,vd);
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

drawnow limitrate 

end
