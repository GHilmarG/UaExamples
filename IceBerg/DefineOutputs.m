function UserVar=DefineOutputs(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo);


time=CtrlVar.time;


UserVar.UaOutputs='-vel-BCs-stresses-s-e-';


%%
if ~isfield(UserVar,'UaOutputs')
    CtrlVar.uvPlotScale=[];
    %plots='-ubvb-udvd-log10(C)-log10(Surfspeed)-log10(DeformationalSpeed)-log10(BasalSpeed)-log10(AGlen)-';
    plots='-ubvb-log10(BasalSpeed)-sbB-ab-log10(C)-log10(AGlen)-';
    plots='-save-';
else
    plots=UserVar.UaOutputs;
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
    
    if strcmp(CtrlVar.UaOutputsInfostring,'First call ') && exist(fullfile(cd,'ResultsFiles'),'dir')~=7
        mkdir('ResultsFiles') ;
    end
    
    if strcmp(CtrlVar.UaOutputsInfostring,'Last call')==0
        
        FileName=sprintf('ResultsFiles/%07i-Nodes%i-Ele%i-Tri%i-kH%i-%s.mat',...
            round(100*time),MUA.Nnodes,MUA.Nele,MUA.nod,1000*CtrlVar.kH,CtrlVar.Experiment);
        fprintf(' Saving data in %s \n',FileName)
        save(FileName,'CtrlVar','BCs','F')
        
    end
end


% Following code is changed by Xianwei
% % only do plots at end of run
% if CtrlVar.DefineOutputsInfostring~="Last call"
%     return
% end
% only do plots at end of run
if CtrlVar.DefineOutputsInfostring~="Last call"
    return
end



if contains(plots,'-BCs-')
    %%
    fBCs=FindOrCreateFigure('Boundary Conditions') ;
    clf(fBCs) ;
    PlotBoundaryConditions(CtrlVar,MUA,BCs)
    hold on ;
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL,'r');
    PlotMuaBoundary(CtrlVar,MUA,'b')
    %%
end

if contains(plots,'-vel-')
    %%
    
    fVel=FindOrCreateFigure('Velocities') ;
    clf(fVel) ;
    [cbar,QuiverHandel,Par]=QuiverColorGHG(MUA.coordinates(:,1),MUA.coordinates(:,2),F.ub,F.vb,CtrlVar);
    title(cbar,"($\mathrm{m \, yr^{-1}}$)","interpreter","latex")   ;
    hold on ;
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL,'r');
    PlotMuaBoundary(CtrlVar,MUA);
    
    xlabel(CtrlVar.PlotsXaxisLabel) ;
    ylabel(CtrlVar.PlotsYaxisLabel) ;
    xlim([min(MUA.coordinates(:,1))-4000, max(MUA.coordinates(:,1))+4000]/CtrlVar.PlotXYscale);
    ylim([min(MUA.coordinates(:,2))-4000, max(MUA.coordinates(:,2))+4000]/CtrlVar.PlotXYscale);
       
    title("Velocity (m/yr)","interpreter","latex")
    xlabel("x (km)","interpreter","latex")
    ylabel("y (km)","interpreter","latex")
  
    
    
end

%%
if contains(plots,'-stresses-')
    
    
    %     figure
    [txzb,tyzb,txx,tyy,txy,exx,eyy,exy,e,eta]=CalcNodalStrainRatesAndStresses(CtrlVar,UserVar,MUA,F);
  
    
    fStress=FindOrCreateFigure('Deviatoric Stresses');
    clf(fStress)
    scale=5e-3;

    N=30;
    [X,Y]=ndgrid(linspace(min(x),max(x),N),linspace(min(y),max(y),N));
    I=nearestNeighbor(MUA.TR,[X(:) Y(:)]);  % find nodes within computational grid closest to the regularly spaced X and Y grid points.
    

    PlotTensor(x(I)/CtrlVar.PlotXYscale,y(I)/CtrlVar.PlotXYscale,txx(I),txy(I),tyy(I),scale);
    hold on
    PlotMuaBoundary(CtrlVar,MUA);
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL,'r');
    title("Deviatoric Stresses","interpreter","latex")
    xlabel("x (km)","interpreter","latex")
    ylabel("y (km)","interpreter","latex")
  
    
end

if contains(plots,'-s-')
    %%
    FindOrCreateFigure('Upper Ice Surface') ;
    [~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,F.s) ;
    hold on ; [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL,'r');
    title(cbar,'(m)')
    title('Upper Ice Surface')
    xlim([min(MUA.coordinates(:,1))-4000, max(MUA.coordinates(:,1))+4000]/CtrlVar.PlotXYscale);
    ylim([min(MUA.coordinates(:,2))-4000, max(MUA.coordinates(:,2))+4000]/CtrlVar.PlotXYscale);
    
    FindOrCreateFigure('Lower Ice Surface') ;
    [~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,F.b) ;
    hold on ; [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL,'r');
    title(cbar,'(m)')
    title('Lower Ice Surface')
    xlim([min(MUA.coordinates(:,1))-4000, max(MUA.coordinates(:,1))+4000]/CtrlVar.PlotXYscale);
    ylim([min(MUA.coordinates(:,2))-4000, max(MUA.coordinates(:,2))+4000]/CtrlVar.PlotXYscale);
    
    FindOrCreateFigure('Ice Thickness') ;
    [~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,F.s-F.b) ;
    hold on ; [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL,'r');
    title(cbar,'(m)')
    title('Ice Thickness')
    xlim([min(MUA.coordinates(:,1))-4000, max(MUA.coordinates(:,1))+4000]/CtrlVar.PlotXYscale);
    ylim([min(MUA.coordinates(:,2))-4000, max(MUA.coordinates(:,2))+4000]/CtrlVar.PlotXYscale);
    
    
end





end
