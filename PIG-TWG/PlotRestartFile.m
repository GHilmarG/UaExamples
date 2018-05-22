function PlotRestartFile(filename)
    
load(filename)


       %%
    %plots=' q uv dhdt h qgrad ';
    plots='-uv-dhdt-';
    %plots=' uv ab ';

    CtrlVar=CtrlVarInRestartFile;
    coordinates=MUA.coordinates ; connectivity=MUA.connectivity;
     GF=GL2d(B,S,h,rhow,rho,MUA.connectivity,CtrlVar);
     
    speed=sqrt(u.*u+v.*v);
    x=coordinates(:,1); y=coordinates(:,2);
    %[GLx,GLy,GLxUpper,GLyUpper,GLxLower,GLyLower] = FindGL(DTxy,GF.node,CtrlVar);
    
    
    
    GLgeo=GLgeometry(connectivity,coordinates,GF,CtrlVar);
    
    if ~isempty(strfind(plots,'-mesh-'))
        CtrlVar.PlotMesh=1;
        figure ; PlotFEmesh(MUA.coordinates,MUA.connectivity,CtrlVar)
        hold on
         plot(GLgeo(:,[3 4])'/CtrlVar.PlotXYscale,GLgeo(:,[5 6])'/CtrlVar.PlotXYscale,'r','LineWidth',2);
        
    end
    
        
    if ~isempty(strfind(plots,'-uv-'))
        figure(10)
        N=1;
        CtrlVar.MinSpeedWhenPlottingVelArrows=1; CtrlVar.MaxPlottedSpeed=max(speed); CtrlVar.VelPlotIntervalSpacing='log10';
        %CtrlVar.VelColorMap='hot';
        QuiverColorGHG(x(1:N:end),y(1:N:end),u(1:N:end),v(1:N:end),CtrlVar);
        hold on
        %plot(xglc/CtrlVar.PlotXYscale,yglc/CtrlVar.PlotXYscale,'k','LineWidth',2) ;
        %plot(xGL/CtrlVar.PlotXYscale,yGL/CtrlVar.PlotXYscale,'r') ;
        %plot(GLx/CtrlVar.PlotXYscale,GLy/CtrlVar.PlotXYscale,'k') ;
        plot(GLgeo(:,[3 4])'/CtrlVar.PlotXYscale,GLgeo(:,[5 6])'/CtrlVar.PlotXYscale,'r','LineWidth',2);
        plot(x(MUA.Boundary.EdgeCornerNodes)/CtrlVar.PlotXYscale,y(MUA.Boundary.EdgeCornerNodes)/CtrlVar.PlotXYscale,'k')
        
        title(sprintf('t=%-g ',time)) ; xlabel('xps (km)') ; ylabel('yps (km)')
        
    end
    
    % speed
    if ~isempty(strfind(plots,'-speed-'))
        figure(20)
        trisurf(TRIxy,x/CtrlVar.PlotXYscale,y/CtrlVar.PlotXYscale,log10(speed),'EdgeColor','none') ;
        view(0,90); lightangle(-45,30) ; lighting phong ;
        xlabel('xps (km)') ; ylabel('yps (km)') ;
        title(sprintf('log10(speed) at t=%#5.1f ',time))
        colorbar ; caxis([0 4]) ; title(colorbar,'log_{10}(m/a)')
        hold on
        
        plot3(GLgeo(:,[3 4])'/CtrlVar.PlotXYscale,GLgeo(:,[5 6])'/CtrlVar.PlotXYscale,0*GLgeo(:,[3 4])'+10000,'r','LineWidth',2)
        %Draftz=Grid1toGrid2(DTxy,h,Draftx,Drafty); plot3(Draftx/CtrlVar.PlotXYscale,Drafty/CtrlVar.PlotXYscale,Draftz,'m','LineWidth',2)
        %GLz=Grid1toGrid2(DTxy,h,GLx,GLy); plot3(GLx/CtrlVar.PlotXYscale,GLy/CtrlVar.PlotXYscale,GLz,'r','LineWidth',2);
        
        %tt=daspect ; daspect([mean(tt(1)+tt(2)) mean(tt(1)+tt(2)) tt(3)]);
        axis equal tight
        hold off
    end
    
    
     % speed
    if ~isempty(strfind(plots,'-ab-'))
        figure(25)
        trisurf(TRIxy,x/CtrlVar.PlotXYscale,y/CtrlVar.PlotXYscale,ab,'EdgeColor','none') ;
        view(0,90); lightangle(-45,30) ; lighting phong ;
        xlabel('xps (km)') ; ylabel('yps (km)') ;
        title(sprintf('Basal melting at t=%#5.1f ',time))
        colorbar  ; title(colorbar,'a_b (m/a)')
        hold on
        
        plot3(GLgeo(:,[3 4])'/CtrlVar.PlotXYscale,GLgeo(:,[5 6])'/CtrlVar.PlotXYscale,0*GLgeo(:,[3 4])'+10000,'r','LineWidth',2)
        %Draftz=Grid1toGrid2(DTxy,h,Draftx,Drafty); plot3(Draftx/CtrlVar.PlotXYscale,Drafty/CtrlVar.PlotXYscale,Draftz,'m','LineWidth',2)
        %GLz=Grid1toGrid2(DTxy,h,GLx,GLy); plot3(GLx/CtrlVar.PlotXYscale,GLy/CtrlVar.PlotXYscale,GLz,'r','LineWidth',2);
        
        %tt=daspect ; daspect([mean(tt(1)+tt(2)) mean(tt(1)+tt(2)) tt(3)]);
        axis equal tight
        hold off
    end
    
    
        
    
    if ~isempty(strfind(plots,'-dhdt-'))
        figure(252)
        hold off
        [hPatch]=PlotNodalBasedQuantities(MUA.connectivity,MUA.coordinates,dhdt,CtrlVar);
         xlabel('xps (km)') ; ylabel('yps (km)') ;
         title(sprintf('dhdt at t=%#5.1f ',time))
         title(colorbar,'dh/dt (m/a))')
         hold on
        plot(GLgeo(:,[3 4])'/CtrlVar.PlotXYscale,GLgeo(:,[5 6])'/CtrlVar.PlotXYscale,'r','LineWidth',2);
        
        hold off
    end
    

    
     % C
    if ~isempty(strfind(plots,'-C-'))
        figure(25)
        hold off
        [hPatch]=PlotElementBasedQuantities(coordinates/CtrlVar.PlotXYscale,connectivity,log10(C));
        
        
        xlabel('xps (km)') ; ylabel('yps (km)') ;
        title(sprintf('log10(Slipperiness) at t=%#5.1f ',time))
        colorbar  ; title(colorbar,'log_{10}(C) (m/(kPa^3 a))')
        hold on
        
        plot3(GLgeo(:,[3 4])'/CtrlVar.PlotXYscale,GLgeo(:,[5 6])'/CtrlVar.PlotXYscale,0*GLgeo(:,[3 4])'+10000,'r','LineWidth',2)
        %Draftz=Grid1toGrid2(DTxy,h,Draftx,Drafty); plot3(Draftx/CtrlVar.PlotXYscale,Drafty/CtrlVar.PlotXYscale,Draftz,'m','LineWidth',2)
        %GLz=Grid1toGrid2(DTxy,h,GLx,GLy); plot3(GLx/CtrlVar.PlotXYscale,GLy/CtrlVar.PlotXYscale,GLz,'r','LineWidth',2);
        
        %tt=daspect ; daspect([mean(tt(1)+tt(2)) mean(tt(1)+tt(2)) tt(3)]);
        axis equal tight
        hold off
    end
    
    
    % ice thickness
    if ~isempty(strfind(plots,'-h-'))
        figure(30)
        hold off
        trisurf(TRIxy,x/CtrlVar.PlotXYscale,y/CtrlVar.PlotXYscale,h,'EdgeColor','none') ;
        view(0,90); lightangle(-45,30) ; lighting phong ;
        xlabel('xps (km)') ; ylabel('yps (km)') ;
        colorbar ; title(colorbar,'(m)')
        hold on
        
        plot3(GLgeo(:,[3 4])'/CtrlVar.PlotXYscale,GLgeo(:,[5 6])'/CtrlVar.PlotXYscale,0*GLgeo(:,[3 4])'+10000,'r','LineWidth',2)
        %Draftz=Grid1toGrid2(DTxy,h,Draftx,Drafty); plot3(Draftx/CtrlVar.PlotXYscale,Drafty/CtrlVar.PlotXYscale,Draftz,'m','LineWidth',2)
        %GLz=Grid1toGrid2(DTxy,h,GLx,GLy); plot3(GLx/CtrlVar.PlotXYscale,GLy/CtrlVar.PlotXYscale,GLz,'r','LineWidth',2);
        title(sprintf('h at t=%#5.1f ',time))
        %tt=daspect ; daspect([mean(tt(1)+tt(2)) mean(tt(1)+tt(2)) tt(3)]);
        axis equal tight
        hold off
    end
    
    if ~isempty(strfind(plots,'-b-'))
        %  lower surface
        figure(40)
        hold off
        trisurf(TRIxy,x/CtrlVar.PlotXYscale,y/CtrlVar.PlotXYscale,b,'EdgeColor','none') ;
        view(0,90); lightangle(-45,30) ; lighting phong ;
        xlabel('xps (km)') ; ylabel('yps (km)') ;
        colorbar ; title(colorbar,'(m)')
        hold on
        
        plot3(GLgeo(:,[3 4])'/CtrlVar.PlotXYscale,GLgeo(:,[5 6])'/CtrlVar.PlotXYscale,0*GLgeo(:,[3 4])'+10000,'r','LineWidth',2)
        %Draftz=Grid1toGrid2(DTxy,h,Draftx,Drafty); plot3(Draftx/CtrlVar.PlotXYscale,Drafty/CtrlVar.PlotXYscale,Draftz,'m','LineWidth',2)
        %GLz=Grid1toGrid2(DTxy,h,GLx,GLy); plot3(GLx/CtrlVar.PlotXYscale,GLy/CtrlVar.PlotXYscale,GLz,'r','LineWidth',2);
        title(sprintf('b at t=%#5.1f ',time))
        %tt=daspect ; daspect([mean(tt(1)+tt(2)) mean(tt(1)+tt(2)) tt(3)]);
        axis equal tight
        hold off
        
    end
    
    if ~isempty(strfind(plots,' mesh '))
        
        figure(50) ; hold off
        PlotFEmesh(coordinates,connectivity,CtrlVar) ; 
        hold on
        plot(GLgeo(:,[3 4])'/CtrlVar.PlotXYscale,GLgeo(:,[5 6])'/CtrlVar.PlotXYscale,'r','LineWidth',2);
        xlabel('xps (km)') ; ylabel('yps (km)') ;
    end
    
    
      % AGlen
    if ~isempty(strfind(plots,'-AGlen-'))
        figure(55)
        hold off
        [hPatch]=PlotElementBasedQuantities(coordinates/CtrlVar.PlotXYscale,connectivity,log10(AGlen));
        
       
        xlabel('xps (km)') ; ylabel('yps (km)') ;
        title(sprintf('log10(A) at t=%#5.1f ',time))
        colorbar  ; title(colorbar,'log_{10}(A) (kPa^{-3} a^{-1})')
        hold on
        
        plot3(GLgeo(:,[3 4])'/CtrlVar.PlotXYscale,GLgeo(:,[5 6])'/CtrlVar.PlotXYscale,0*GLgeo(:,[3 4])'+10000,'r','LineWidth',2)
        %Draftz=Grid1toGrid2(DTxy,h,Draftx,Drafty); plot3(Draftx/CtrlVar.PlotXYscale,Drafty/CtrlVar.PlotXYscale,Draftz,'m','LineWidth',2)
        %GLz=Grid1toGrid2(DTxy,h,GLx,GLy); plot3(GLx/CtrlVar.PlotXYscale,GLy/CtrlVar.PlotXYscale,GLz,'r','LineWidth',2);
        
        %tt=daspect ; daspect([mean(tt(1)+tt(2)) mean(tt(1)+tt(2)) tt(3)]);
        axis equal tight
        hold off
    end
    
    
    
    %%
end  
 