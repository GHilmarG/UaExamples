function UserVar=DefineOutputs(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo)
    
    time=CtrlVar.time;
    
    if ~isfield(UserVar,'Plots')
        
        plots='-plot-flowline-mapplane-';
        plots='-plot-mapplane-flowline-';
        plots='-plot-flowline-save-';
    else
        
        plots=UserVar.Plots;
    end
    
    if contains(plots,'-save-')
        
        % save data in files with running names
        % check if folder 'ResultsFiles' exists, if not create
        
        if exist(fullfile(cd,UserVar.Outputsdirectory),'dir')~=7
            mkdir(UserVar.Outputsdirectory) ;
        end
        
        if strcmp(CtrlVar.DefineOutputsInfostring,'Last call')==0
            
            
            FileName=sprintf('%s/%07i-Nodes%i-Ele%i-Tri%i-kH%i-%s.mat',...
                UserVar.Outputsdirectory,round(100*time),MUA.Nnodes,MUA.Nele,MUA.nod,1000*CtrlVar.kH,CtrlVar.Experiment);
            fprintf(' Saving data in %s \n',FileName)
            save(FileName,'UserVar','CtrlVar','MUA','F')
            
        end
        
    end
    
    
    if ~contains(plots,'-plot-')
        
        return
    end
    

if ~(isfield(MUA,'Deriv') && isfield(MUA,'DetJ') && ~isempty(MUA.Deriv) && ~isempty(MUA.DetJ)  && ~isfield(MUA,'TR') && ~isempty(MUA.TR))
    fprintf("DefineOutputs: MUA updated to include fields that were deleted previously to reduce its size. \n")
    fprintf("             MUA=UpdateMUA(CtrlVar,MUA)   \n")
    MUA=UpdateMUA(CtrlVar,MUA) ;
end


    figsWidth=1000 ; figHeights=300;
    GLgeo=[]; xGL=[] ; yGL=[];
    %%
    if contains(plots,'-mapplane-')
        
        FigureName='map plane view'; Position=[50 50 figsWidth 3*figHeights];
        fig100=FindOrCreateFigure(FigureName,Position) ;
        clf(fig100)
        
        
        subplot(4,1,1)
        hold off
        [~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,F.h); 
        title(sprintf('h at t=%g',time))
        hold on
        [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,'b');
        %Plot_sbB(CtrlVar,MUA,s,b,B) ; title(sprintf('time=%g',time))
        title(cbar,'(m)')
        [xc,yc]=PlotCalvingFronts(CtrlVar,MUA,F,'r') ;
        xlabel('x (km)') ; ylabel('y (km)')
        
        subplot(4,1,2)
        hold off
        QuiverColorGHG(MUA.coordinates(:,1),MUA.coordinates(:,2),F.ub,F.vb,CtrlVar);
        hold on
        [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,'b');
        [xc,yc]=PlotCalvingFronts(CtrlVar,MUA,F,'r') ;
        xlabel('x (km)') ; ylabel('y (km)')
        hold off
        
        subplot(4,1,3)
        hold off
        if CtrlVar.LevelSetMethod
            PlotMeshScalarVariable(CtrlVar,MUA,F.c);   title(sprintf('Calving Rate Field at t=%g',time))
        else
          
            [~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,F.dhdt);  
            hold on ; PlotMuaMesh(CtrlVar,MUA,[],'w');
            title(sprintf('dh/dt at t=%g',time))
            title(cbar,'(m/yr)')
        end
        hold on
        [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,'b');
        [xc,yc]=PlotCalvingFronts(CtrlVar,MUA,F,'r') ;
        xlabel('x (km)') ; ylabel('y (km)')
        subplot(4,1,4)
        hold off
        
        if CtrlVar.LevelSetMethod
            [~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,F.LSF);   title(sprintf('Level Set Field at t=%g',time))
            ModifyColormap ;
        else
            [~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,F.ab);   title(sprintf('ab at t=%g',time))
            title(cbar,'(m/yr)')
        end
        hold on
        
        [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,'b');
        [xc,yc]=PlotCalvingFronts(CtrlVar,MUA,F,'r') ;
        colormap(othercolor('BuOr_12',2048)); ModifyColormap();
        xlabel('x (km)') ; ylabel('y (km)')
        hold off
        
    end
    
    
    if contains(plots,'-Speed-')
        
        FindOrCreateFigure("Speed") ;
        speed=sqrt(F.ub.*F.ub+F.vb*F.vb) ;
        PlotMeshScalarVariable(CtrlVar,MUA,speed);   title(sprintf('speed at t=%g',time))
        [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,'b');
        [xc,yc]=PlotCalvingFronts(CtrlVar,MUA,F,'r') ;
        colormap(othercolor('BuOr_12',2048)); ModifyColormap();
        hold off
        
    end
    
    
    if contains(plots,'-speedcalving-')
        
        if isempty(F.c)
            F.c=0;
        end
        
        FindOrCreateFigure("Speed-Calving") ;
        speed=sqrt(F.ub.*F.ub+F.vb.*F.vb) ;
        PlotMeshScalarVariable(CtrlVar,MUA,speed-F.c);
        title(sprintf('speed-calving rate at t=%g',time))
        hold on
        [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,'b');
        [xc,yc]=PlotCalvingFronts(CtrlVar,MUA,F,'r') ;
        colormap(othercolor('Blues6',2048)); % ModifyColormap();
        hold off
        
        
    end
    
    
    if contains(plots,'-flowline-')  || contains(plots,"-Calving1dIceShelf-")
        %%
        
        if exist('CtrlVarInRestartFile','var') && ~exist('CtrlVar','var')
            CtrlVar=CtrlVarInRestartFile;
        end
        
        yProfile=0e3 ;
        if contains(UserVar.RunType,"-1dAnalyticalIceShelf-")
            [s,b,u,x]=AnalyticalOneDimentionalIceShelf(CtrlVar,MUA);
            yProfile=0 ;
        end
        
        FigureName='flowline';
        fig=FindOrCreateFigure(FigureName) ;
        clf(fig);
        
        % point selection
        Iy=abs(MUA.coordinates(:,2)-yProfile)< 1000 ;
        
        xProfile=MUA.coordinates(Iy,1) ;
        [xProfile,Ix]=sort(xProfile) ;
        
        sProfile=F.s(Iy);
        bProfile=F.b(Iy);
        BProfile=F.B(Iy);
        uProfile=F.ub(Iy) ;
        if isfield(F,'c') &&  ~isnan(F.c)  &&  ~isempty(F.c)
            cProfile=F.c(Iy);
            cProfile=cProfile(Ix);
        else
            cProfile=[];
        end
        if isfield(F,'LSF') && ~isempty(F.LSF)
            LSFProfile=F.LSF(Iy);
            LSFProfile=LSFProfile(Ix);
        else
            LSFProfile=[] ;
        end
        
        
        
        
        uProfile=uProfile(Ix) ;
        sProfile=sProfile(Ix);
        bProfile=bProfile(Ix);
        BProfile=BProfile(Ix);
        
        %
        % GFProfile=GFProfile(I);
        %  Interpolation
        %         Fb=scatteredInterpolant(x,y,F.b);
        %         Fs=Fb ; Fs.Values=F.s;
        %         xProfile=min(x):1000:max(x);
        %         yCentre=yProfile+xProfile*0;
        %         sProfile=Fs(xProfile,yCentre);
        %         bProfile=Fb(xProfile,yCentre);
        %         BProfile=MismBed(xProfile,yCentre);
        
        yyaxis left
        plot(xProfile/1000,sProfile,'b-o')
        hold on
        plot(xProfile/1000,bProfile,'g-o')
        
        if contains(UserVar.RunType,"-1dAnalyticalIceShelf-")
            plot(x/1000,s,'b-','LineWidth',2)
            plot(x/1000,b,'g-','LineWidth',2)
            % plot(xProfile/1000,BProfile,'k-o')
        end
        ylabel('$z$ (m)','interpreter','latex')
        
        
        yyaxis right
        
        %  plot(xProfile/1000,LSFProfile>0,'r-+')
        %  plot(xProfile/1000,GFProfile,'g-o')
        
        
        plot(xProfile/1000,uProfile,'r-o')
        hold on
        
        if contains(UserVar.RunType,"-1dAnalyticalIceShelf-")
            plot(x/1000,u,'r-','LineWidth',2)
        end
        
        if contains(plots,"-plot-Calving1dIceShelf-")  && ~isempty(cProfile)

            [s,b,u,x]=AnalyticalOneDimentionalIceShelf(CtrlVar,MUA);
            plot(xProfile/1000,cProfile,'-k')
            plot(x/1000,u,'r','LineWidth',2)
        end
        
        CompareWithAnalyticalVelocities=true;
        if CompareWithAnalyticalVelocities
            
            [s,b,u]=AnalyticalOneDimentionalIceShelf(CtrlVar,MUA) ; 
            
            if ~isempty(F.LSF)
                Mask=F.LSF>0 ;
            else
                Mask=u*0+1;
            end
            FERMSE=FE_RootMeanSquareError(u.*Mask,F.ub.*Mask,MUA.M,u.*Mask);
            fprintf(' Finite-Element Root-Mean-Square-Deviation between u analytical and numerical is %g \n',FERMSE)
        end
        
        
        ylabel('$u$ (m/a)','interpreter','latex')
        
        if contains(UserVar.RunType,"-1dAnalyticalIceShelf-")
            ylim([round(ceil(min(u)),2,'significant') round(ceil(max(u)),2,'significant')]) ;
        end
        
        title(sprintf('Profile along the medial line at t=%g',CtrlVar.time))
        xlabel('$x$ (km)','interpreter','latex') ;
        
        if contains(UserVar.RunType,"-1dAnalyticalIceShelf-")
            legend('$s$ numerical','$b$ numerical','$s$ analytical ','$b$ analytical','$u$ numerical','$u$ analytical',...
                'interpreter','latex','location','east')
        end
        
        hold off
        
        if isfield(F,'LSF') && ~isempty(F.LSF)
            FigureName='LSF profile';
            fig=FindOrCreateFigure(FigureName) ;
            clf(fig);
            yyaxis left
            plot(xProfile/1000,LSFProfile/1000,'b-o')
            xlabel('$x$ (km)','interpreter','latex') ;
            ylabel('LSF (km)','interpreter','latex') ;
            yyaxis right
            plot(xProfile/1000,sProfile-bProfile,'r-o')
            ylabel('ice thickness (m)','interpreter','latex') ;
            ax=gca;
            ax.XAxisLocation = 'origin';
            title(sprintf('Profile along the medial line at t=%g',CtrlVar.time))
        end
        
        
        
        
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



