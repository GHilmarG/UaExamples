
function UserVar=DefineOutputs(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo)



% v2struct(F);
time=CtrlVar.time;

plots='-plot-flowline-mapplane-';
plots='-plot-mapplane-flowline-';
plots='-plot-mapplane-';

if contains(plots,'-save-')
    
    % save data in files with running names
    % check if folder 'ResultsFiles' exists, if not create
    
    if exist(fullfile(cd,UserVar.Outputsdirectory),'dir')~=7
        mkdir(CtrlVar.Outputsdirectory) ;
    end
    
    if strcmp(CtrlVar.DefineOutputsInfostring,'Last call')==0

        FileName=sprintf('%s/%07i-Nodes%i-Ele%i-Tri%i-kH%i-%s.mat',...
            CtrlVar.Outputsdirectory,round(100*time),MUA.Nnodes,MUA.Nele,MUA.nod,1000*CtrlVar.kH,CtrlVar.Experiment);
        fprintf(' Saving data in %s \n',FileName)
        save(FileName,'CtrlVar','MUA','F')
        
    end
    
end


x=MUA.coordinates(:,1);
y=MUA.coordinates(:,2);


if contains(plots,'-plot-')
    
    figsWidth=1000 ; figHeights=300;
    GLgeo=[]; xGL=[] ; yGL=[];
    %%
    if contains(plots,'-mapplane-')
        
        FigureName='map plane view'; Position=[50 50 figsWidth 3*figHeights];
        fig100=FindOrCreateFigure(FigureName) ;
        clf(fig100) 
        
        I=F.h <= CtrlVar.ThickMin*1.01;
        subplot(4,1,1)
        hold off
        [~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,F.h); title(sprintf('h at t=%g with dt=%g',CtrlVar.time,CtrlVar.dt))
        hold on
        [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL);
        %Plot_sbB(CtrlVar,MUA,s,b,B) ; title(sprintf('time=%g',time))
        plot(x(I)/CtrlVar.PlotXYscale,y(I)/CtrlVar.PlotXYscale,'ow')
        title(cbar,'(m)') ; xlabel('x (km)') ; ylabel('y (km)')
        
        subplot(4,1,2)
        hold off
        QuiverColorGHG(MUA.coordinates(:,1),MUA.coordinates(:,2),F.ub,F.vb,CtrlVar);
        hold on
        [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL);
        xlabel('x (km)') ; ylabel('y (km)')
        hold off
        
        subplot(4,1,3)
        hold off
        [~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,F.dhdt);   title(sprintf('dh/dt at t=%g',time))
        hold on
        [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL);
        plot(x(I)/CtrlVar.PlotXYscale,y(I)/CtrlVar.PlotXYscale,'ow')
        title(cbar,'(m/yr)')
        xlabel('x (km)') ; ylabel('y (km)')
        
        subplot(4,1,4)
        hold off
        [~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,F.ab);   title(sprintf('a_b at t=%g',time))
        hold on
        
        [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL);
        title(cbar,'(m/yr)')
        xlabel('x (km)') ; ylabel('y (km)')
        hold off
        
    end
    
    if contains(plots,'-flowline-')
        
        FigureName='flowline';
        fig200=FindOrCreateFigure(FigureName) ;
        clf(fig200) 
        x=MUA.coordinates(:,1);
        y=MUA.coordinates(:,2);
        
        Fb=scatteredInterpolant(x,y,b);
        Fs=Fb ; Fs.Values=s;
        
        xProfile=min(x):1000:max(x);
        
        yCentre=40e3+xProfile*0;
        sProfile=Fs(xProfile,yCentre);
        bProfile=Fb(xProfile,yCentre);
        
        BProfile=MismBed(xProfile,yCentre);
        
        
        plot(xProfile/1000,sProfile,'b')
        hold on
        plot(xProfile/1000,bProfile,'b')
        plot(xProfile/1000,BProfile,'k')
        title(sprintf('Profile along the medial line at t=%g',time))
        xlabel('x (km)') ; ylabel('z (m)')
        hold off
        
    end
    
    if contains(plots,'-mesh-')
        
        fig300=figure(300);
        fig300.Position=[1200 700 figsWidth figHeights];
        PlotMuaMesh(CtrlVar,MUA)
        hold on
        
        [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL,'r','LineWidth',2);
        title(sprintf('t=%g',time))
        hold off
    end
    
    drawnow
    %%
end

end

