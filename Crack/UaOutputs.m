function  UserVar=UaOutputs(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo)


%%
% UaOutputs(CtrlVar,MUA,time,s,b,S,B,h,ub,vb,ud,vd,dhdt,dsdt,dbdt,C,AGlen,m,n,rho,rhow,g,as,ab,GF,BCs,l)
%
%  This routine is called during the run and can be used for saving and/or
%  plotting data.
%  
%  Write your own version of this routine and put it in you local run directory.
%  
%%

v2struct(F);
time=CtrlVar.time;

CtrlVar.UaOutputs='-Speed-e-stresses-profile-';


%%
if ~isfield(CtrlVar,'UaOutputs')
    CtrlVar.uvPlotScale=[];
    %plots='-ubvb-udvd-log10(C)-log10(Surfspeed)-log10(DeformationalSpeed)-log10(BasalSpeed)-log10(AGlen)-';
    plots='-ubvb-log10(BasalSpeed)-sbB-';
    plots='-save-';
else
    plots=CtrlVar.UaOutputs;
end



CtrlVar.QuiverColorPowRange=2; 

%%
GLgeo=GLgeometry(MUA.connectivity,MUA.coordinates,GF,CtrlVar);
TRI=[]; DT=[]; xGL=[] ; yGL=[] ;
x=MUA.coordinates(:,1);  y=MUA.coordinates(:,2);



if contains(plots,'-save-')

    % save data in files with running names
    % check if folder 'ResultsFiles' exists, if not create

   if strcmp(CtrlVar.UaOutputsInfostring,'First call ') && exist(fullfile(cd,'ResultsFiles'),'dir')~=7 ;
        mkdir('ResultsFiles') ;
    end
    
    if strcmp(CtrlVar.UaOutputsInfostring,'Last call')==0
                
        FileName=sprintf('ResultsFiles/%07i-Nodes%i-Ele%i-Tri%i-kH%i-%s.mat',...
            round(100*time),MUA.Nnodes,MUA.Nele,MUA.nod,1000*CtrlVar.kH,CtrlVar.Experiment);
        fprintf(' Saving data in %s \n',FileName)
        save(FileName,'CtrlVar','MUA','time','s','b','S','B','h','ub','vb','C','dhdt','AGlen','m','n','rho','rhow','as','ab','GF')
        
    end
end



% only do plots at end of run
if ~strcmp(CtrlVar.UaOutputsInfostring,'Last call') ; return ; end

if contains(plots,'-BCs-')
    figure ;
    PlotBoundaryConditions(CtrlVar,MUA,BCs)
    hold on ;
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL,'k');
    PlotMuaBoundary(CtrlVar,MUA,'b')
end


if contains(plots,'-sbB-')
%%
    figure
    hold off
    AspectRatio=3; 
    ViewAndLight(1)=-40 ;  ViewAndLight(2)=20 ;
    ViewAndLight(3)=90 ;  ViewAndLight(4)=50;
    [TRI,DT]=Plot_sbB(CtrlVar,MUA,s,b,B,TRI,DT,AspectRatio,ViewAndLight);
%%   
end

if contains(plots,'-ubvb-')
    % plotting horizontal velocities
%%
    figure
    N=1;
    %speed=sqrt(ub.*ub+vb.*vb);
    %CtrlVar.MinSpeedWhenPlottingVelArrows=0; CtrlVar.MaxPlottedSpeed=max(speed); %
    CtrlVar.VelPlotIntervalSpacing='lin';
    %CtrlVar.VelColorMap='hot';
    %CtrlVar.RelativeVelArrowSize=10;
    
    QuiverColorGHG(x(1:N:end),y(1:N:end),ub(1:N:end),vb(1:N:end),CtrlVar);
    hold on ; 
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL,'k');
    PlotMuaBoundary(CtrlVar,MUA,'b')
    title(sprintf('(ub,vb) t=%-g ',time)) ; xlabel('x (km)') ; ylabel('y (km)')
    %%
    
end


if contains(plots,'-e-')
    % plotting effectiv strain rates
    
    % first get effective strain rates, e :
    [etaInt,xint,yint,exx,eyy,exy,Eint,e,txx,tyy,txy]=calcStrainRatesEtaInt(CtrlVar,MUA,ub,vb,AGlen,n);
    % all these variables are are element variables defined on integration points
    % therfore if plotting on nodes, must first project these onto nodes
    eNod=ProjectFintOntoNodes(MUA,e);
    
    figure
    [FigHandle,ColorbarHandel,tri]=PlotNodalBasedQuantities(MUA.connectivity,MUA.coordinates,eNod,CtrlVar)    ;
    hold on ; 
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL,'k');
    PlotMuaBoundary(CtrlVar,MUA,'b')
    title(sprintf('e t=%-g ',time)) ; xlabel('x (km)') ; ylabel('y (km)')
    
end

if contains(plots,'-stresses-')
    
    figure

    [txzb,tyzb,txx,tyy,txy,exx,eyy,exy,e]=CalcNodalStrainRatesAndStresses(CtrlVar,MUA,AGlen,n,C,m,GF,s,b,ub,vb,ud,vd);
    N=30;
    
    [X,Y]=ndgrid(linspace(min(x),max(x),N),linspace(min(y),max(y),N));
    I=nearestNeighbor(MUA.TR,[X(:) Y(:)]);  % find nodes within computational grid closest to the regularly spaced X and Y grid points.

    
    scale=1e-3;
    PlotTensor(x(I)/CtrlVar.PlotXYscale,y(I)/CtrlVar.PlotXYscale,txx(I),txy(I),tyy(I),scale);
    hold on
    PlotMuaBoundary(CtrlVar,MUA,'k')
 
    axis equal
  
    title(' Deviatoric stresses ' )
    
end

save TestSave
if contains(plots,'-profile-')
    
    
%%
    [txzb,tyzb,txx,tyy,txy,exx,eyy,exy,e]=CalcNodalStrainRatesAndStresses(CtrlVar,MUA,AGlen,n,C,m,GF,s,b,ub,vb,ud,vd);
    
    Fv=scatteredInterpolant(MUA.coordinates(:,1),MUA.coordinates(:,2),F.vb);
    Fexx=scatteredInterpolant(MUA.coordinates(:,1),MUA.coordinates(:,2),exx);
    N=100;
    yProfile=linspace(UserVar.Crack.b+UserVar.Crack.a,max(y)/2,N);  % start a bit away from edge, so use crack width
    vProfile=Fv(0*yProfile,yProfile) ;
    exxProfile=Fexx(0*yProfile,yProfile) ;
    
    
   
    figure 
    yyaxis left
    hold off
    plot(yProfile,vProfile,'o-r')
    axis normal tight
    xlabel('y (m)') ; ylabel('v (m/yr)')
    title(' y velocity ' )
    
    hold on
    yyaxis right
    plot(yProfile,exxProfile,'x-b')
    xlabel('y (m)') ; ylabel('\epsilon_{xx} (1/yr)')
    title(' velocity and strain rates ' )
    
    legend('v_y','\epsilon_{xx}')
    
  
    
    
    
    r=yProfile-UserVar.Crack.b;
    n=3; 
    f=abs(vProfile).^((n+1)/n)./r.^(1/n);
    f=abs(vProfile)./r.^(1/(n+1));
    figure ; loglog(r,abs(vProfile),'x-m')
    hold on
    
    vTheory=abs(vProfile(1)./((r/r(1)).^(1/(n+1))));
    loglog(r,vTheory,'+-r')
    xlabel('log(r)')  ; ylabel('log(v)')
    I=(r>0 & r< (10*UserVar.Crack.a));
    
    Fit=fit(log(r(I))',log(abs(vProfile(I)))','poly1')
    
    
    
    %%
end











end
