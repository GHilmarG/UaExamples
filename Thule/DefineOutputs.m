




function  UserVar=DefineOutputs(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo)


persistent cyMax ctime icCounter iGLCounter GLMax GLtime   EastWestVideo NorthSouthVideo dhdtVideo


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

%%
if ~isfield(UserVar,'DefineOutputs')

    UserVar.DefineOutputs="-ubvb-LSF-h-sbB-s-";
    plots=UserVar.DefineOutputs  ; 
    % plots='-ubvb-log10(BasalSpeed)-sbB-ab-log10(C)-log10(AGlen)-save-';
    % plots='-save-';
else
    plots=UserVar.DefineOutputs;
end

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


%%


if ~CtrlVar.doplots
    return
end


%%
if isempty(EastWestVideo)
    EastWestVideo=VideoWriter("EastWest.mp4","MPEG-4");
    open(EastWestVideo)

    NorthSouthVideo=VideoWriter("NorthSouth.mp4","MPEG-4");
    open(NorthSouthVideo)

    dhdtVideo=VideoWriter("dhdt.mp4","MPEG-4");
    open(dhdtVideo)


end

% f=gcf; exportgraphics(f,'VAF-VC1k1.pdf')


%%

if ~isfield(CtrlVar,"FigTitleText")
    CtrlVar.FigTitleText="";
end


CtrlVar.QuiverColorPowRange=2; 

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

    [cbar,xGL,yGL,xCF,yCF]=UaPlots(CtrlVar,MUA,F,F.LSF/1000,GetRidOfValuesDownStreamOfCalvingFronts=false,FigureTitle="LSF");
    title("Level Set Function") ;
    lg=legend;
    CM=cmocean('balanced',50,'pivot',0) ; colormap(CM);
    title(cbar,"")
    axis tight
    hold off


    cbar=UaPlots(CtrlVar,MUA,F,F.c,GetRidOfValuesDownStreamOfCalvingFronts=false,FigureTitle="Calving rate");
    lg=legend;
    title("Calving Rate") 
    title(cbar,"(m/yr)")
    axis tight
    hold off


    if ~isempty(yCF)

        icCounter=icCounter+1;
        cyMax(icCounter)=max(yCF) ;
        ctime(icCounter)=F.time ;

    end

    if ~isempty(yGL)

        iGLCounter=iGLCounter+1;
        GLMax(iGLCounter)=max(yGL) ;
        GLtime(iGLCounter)=F.time ;

    end

    FindOrCreateFigure("yCF(t) & xGL(t)")

    hold off
    yyaxis left
    plot(ctime,cyMax/1000,'o-b',DisplayName="Calving front")
    ylabel(" y-axis calving front (km) ")

    yyaxis right
    plot(GLtime,GLMax/1000,'*-r',DisplayName="Grounding line")
    ylabel(" y-axis grounding line  (km) ")

    xlabel("t (yr)")
    lg=legend();


end

if contains(plots,'-sbB-')
%%   
 FindOrCreateFigure("sbB")

    TRI=[]; DT=[]; xGL=[] ; yGL=[] ;
    FIGsbB=FindOrCreateFigure("sbB"); clf(FIGsbB);
    hold off
    AspectRatio=3; 
    ViewAndLight(1)=-40 ;  ViewAndLight(2)=20 ;
    ViewAndLight(3)=30 ;  ViewAndLight(4)=50;
    sCol=[1 1 1]; bCol=[0 0 1]; BCol=[0.5 0.5 0.5] ;
    [TRI,DT]=Plot_sbB(CtrlVar,MUA,F.s,F.b,F.B,TRI,DT,AspectRatio,ViewAndLight,[],sCol,bCol,BCol);
    %%
end


if contains(plots,"ubvb")
    UaPlots(CtrlVar,MUA,F,"-uv-",FigureTitle="-uv-",GetRidOfValuesDownStreamOfCalvingFronts=false);
    legend;
end

if contains(plots,"speed")

    UaPlots(CtrlVar,MUA,F,"-speed-",FigureTitle="-speed-",logColorbar=true,GetRidOfValuesDownStreamOfCalvingFronts=false);
    legend;
end



if contains(plots,'-B-')
    cbar=UaPlots(CtrlVar,MUA,F,F.B,FigureTitle="B",GetRidOfValuesDownStreamOfCalvingFronts=false,PlotUnderMesh=false,MeshColor="w");
    title(cbar,'(m)')
    CM=cmocean('balanced',25,'pivot',0) ; colormap(CM);
    title("Bedrock")

end



if contains(plots,'-dhdt-')
    %%
    UaPlots(CtrlVar,MUA,F,F.dhdt,FigureTitle="dh/dt",GetRidOfValuesDownStreamOfCalvingFronts=false,PlotUnderMesh=true,MeshColor="w")
    figdhdt=gcf ; 
    figdhdt.Position=[1358	273	1153	1003];
    plot(F.x(BCs.hPosNode)/1000,F.y(BCs.hPosNode)/1000,"or",MarkerSize=2,DisplayName="Active Set")
    CL=clim;
    if CL(1) < 0 && CL(2)> 0
        CM=cmocean('balanced',25,'pivot',0) ; colormap(CM);
    end
    title(colorbar,'(m/yr)')
    ti=title("Rate of thickness change, $\dot{h}$"+CtrlVar.FigTitleText,Interpreter="latex");  ti.FontSize=14;
    subtitle(sprintf("$t$=%g ",F.time),Interpreter="latex")
    xlabel("x (km)") ; ylabel("y (km)")
  
    lg=legend(Interpreter="latex");
    clim([-200 50] ) ; CM=cmocean('-balanced',50,'pivot',0) ; colormap(CM);
    axis off ; ScaleBar(1000,[],[0.10 0.05])
  
    frame=getframe(gcf);
    writeVideo(dhdtVideo,frame)
    

    %%

end



if contains(plots,'-s-')
    %%
    UaPlots(CtrlVar,MUA,F,F.s,FigureTitle="s",GetRidOfValuesDownStreamOfCalvingFronts=false,PlotUnderMesh=false,MeshColor="w")
    title(colorbar,'(m)')
    ti=title("Upper surface, $s$"+CtrlVar.FigTitleText,Interpreter="latex");  ti.FontSize=14;
    subtitle(sprintf("$t$=%g ",F.time),Interpreter="latex")
    xlabel("x (km)") ; ylabel("y (km)")
    CM=cmocean('-ice',15) ; clim([0 4000]); colormap(CM);
    fig=gcf ; % fig.Position=[3600 450 800 700]; 
    %%
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
    hold on ; 
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,'k');
    PlotMuaBoundary(CtrlVar,MUA,'b')
    title(sprintf('e t=%-g ',CtrlVar.time)) ; xlabel('x (km)') ; ylabel('y (km)')
    
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


if contains(plots,'-EastWestProfile-')

%%
    xProfile=linspace(-1000e3,1000e3); 
    yProfile=xProfile*0;
    Fs=scatteredInterpolant(F.x,F.y,F.s);
    Fb=Fs; Fb.Values=F.b;
    FB=Fs; FB.Values=F.B;
    Fu=Fs; Fu.Values=F.ub;
    Fdhdt=Fs; Fdhdt.Values=F.dhdt ; 
    sProfile=Fs(xProfile,yProfile);
    bProfile=Fb(xProfile,yProfile);
    BProfile=FB(xProfile,yProfile);
    uProfile=Fu(xProfile,yProfile);
    dhdtProfile=Fdhdt(xProfile,yProfile);

    fP=FindOrCreateFigure("EastWestProfile"); clf(fP);
    fP.Position=[2600 70 1600 590];
    % yyaxis left
    plot(xProfile/1000,sProfile,"b-",DisplayName="s",LineWidth=1.5)
    hold on
    plot(xProfile/1000,BProfile,"k-",DisplayName="B",LineWidth=1.5)
    plot(xProfile/1000,bProfile,"b-",DisplayName="b",LineWidth=1.5)
    ylabel("Geometry (m)")
    % yyaxis right
    % plot(xProfile/1000,uProfile,"r-",DisplayName="u")
    % plot(xProfile/1000,100*dhdtProfile,"r--",DisplayName="100 x dh/dt")
    % ylabel("u-velocity (m/yr)")
    % 

    xlabel("x (km)")
    title("East-West Profile")
    subtitle(sprintf("time=%5.2g",F.time))
    lg=legend; 

    frame=getframe(gcf);
    writeVideo(EastWestVideo,frame)
    

%%

end


if contains(plots,'-NorthSouthProfile-')

    %%
    yProfile=linspace(-1000e3,1000e3); 
    xProfile=xProfile*0;
    Fs=scatteredInterpolant(F.x,F.y,F.s);
    Fb=Fs; Fb.Values=F.b;
    FB=Fs; FB.Values=F.B;
    Fu=Fs; Fu.Values=F.ub;
    Fdhdt=Fs; Fdhdt.Values=F.dhdt ; 
    sProfile=Fs(xProfile,yProfile);
    bProfile=Fb(xProfile,yProfile);
    BProfile=FB(xProfile,yProfile);
    uProfile=Fu(xProfile,yProfile);
    dhdtProfile=Fdhdt(xProfile,yProfile);

    fP=FindOrCreateFigure("NorthSouthProfile"); clf(fP);
    fP.Position=[2600 660 1600 590];

   % yyaxis left
    plot(yProfile/1000,sProfile,"b-",DisplayName="s",LineWidth=1.5)
    hold on
    plot(yProfile/1000,BProfile,"k-",DisplayName="B",LineWidth=1.5)
    plot(yProfile/1000,bProfile,"b-",DisplayName="b",LineWidth=1.5)
    ylabel("Geometry (m)")
    % yyaxis right
    % plot(yProfile/1000,uProfile,"r-",DisplayName="u")
    % plot(yProfile/1000,100*dhdtProfile,"r--",DisplayName="100 x dh/dt")
    % ylabel("u-velocity (m/yr)")


    xlabel("x (km)")
    title("North-South Profile")
    subtitle(sprintf("time=%5.2g",F.time))
    lg=legend;

    frame=getframe(gcf);
    writeVideo(NorthSouthVideo,frame)
    %%

end



drawnow limitrate


if CtrlVar.DefineOutputsInfostring=="Last call"
    close(EastWestVideo)
    close(NorthSouthVideo)
    close(dhdtVideo)
end


end
