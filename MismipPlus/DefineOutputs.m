function UserVar=DefineOutputs(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo)



plots='-plot-';

if contains(plots,'-save-')
    
    % save data in files with running names
    % check if folder 'ResultsFiles' exists, if not create
    
    if exist(fullfile(cd,UserVar.Outputsdirectory),'dir')~=7
        mkdir(CtrlVar.Outputsdirectory) ;
    end
    
    if strcmp(CtrlVar.DefineOutputsInfostring,'Last call')==0
        
        %
        % 
        %
        
        FileName=sprintf('%s/%07i-Nodes%i-Ele%i-Tri%i-kH%i-%s.mat',...
            CtrlVar.Outputsdirectory,round(100*F.time),MUA.Nnodes,MUA.Nele,MUA.nod,CtrlVar.Experiment);
        fprintf(' Saving data in %s \n',FileName)
        save(FileName,'CtrlVar','MUA','F','BCs','RunInfo')
        
    end
    
end

if contains(plots,'-plot-')
   
   %% 
    cbar=UaPlots(CtrlVar,MUA,F,F.h,FigureTitle="h");
    title("$h$",Interpreter="latex")
    title(cbar,"(m)")

    cbar=UaPlots(CtrlVar,MUA,F,"-uv-",FigureTitle="uv");
    title("$uv$",Interpreter="latex")
    title(cbar,"(m/yr)")


    cbar=UaPlots(CtrlVar,MUA,F,F.dhdt,FigureTitle="dh/dt",BalancedColorMap=true);
    title("$\dot{h}$",Interpreter="latex")
    title(cbar,"(m/yr)")

    UaPlots(CtrlVar,MUA,F,F.ab,FigureTitle="ab",BalancedColorMap=true)
    title("$a_b$",Interpreter="latex")
    title(cbar,"(m/yr)")

    UaPlots(CtrlVar,MUA,F,"-mesh-",FigureTitle="mesh")
    title("Mesh",Interpreter="latex")

  
    
    Fb=scatteredInterpolant(F.x,F.y,F.b);
    Fs=Fb ; Fs.Values=F.s;
    
    xProfile=min(F.x):1000:max(F.x);
    
    yCentre=40e3+xProfile*0;
    sProfile=Fs(xProfile,yCentre);
    bProfile=Fb(xProfile,yCentre);
    
    BProfile=MismBed(xProfile,yCentre);
    
    
    figProfile=FindOrCreateFigure("Profile") ; clf(figProfile)
  
    
    plot(xProfile/1000,sProfile,'b')
    hold on
    plot(xProfile/1000,bProfile,'b')
    plot(xProfile/1000,BProfile,'k')
    title(sprintf('t=%g',F.time))
    xlabel("$x$ (km)",Interpreter="latex")
    ylabel("$y$ (m)",Interpreter="latex")

    hold off
    %%
end


end