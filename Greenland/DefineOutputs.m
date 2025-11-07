function UserVar=DefineOutputs(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo)
%%
% This routine is called during the run and can be used for saving and/or plotting data.
% 
%   UserVar=DefineOutputs(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo)
%
% Write your own version of this routine and put it in you local run directory.
% 
%
%   This is the m-file you use to define/plot your results.
%
%   You will find all the outputs in the variable F
%
%   The variable F is a structure, and has various fields.
%
%   For example:
%
%   F.s             The upper glacier surface%
%   F.b             The lower glacier surface
%   F.B             The bedrock
%   F.rho           The ice density
%   F.C             Basal slipperiness, i.e. the variable C in the basal sliding law
%   F.AGlen         The rate factor, i.e. the variable A in Glen's flow law
%
%   F.ub            basal velocity in x-direction
%   F.vb            basal velocity in y-direction
%
%   All these variables are nodal variables, i.e. these are the corresponding values at the nodes of the computational domain.
%
%   You find information about the computational domain in the variable MUA
%
%   For example, the x and y coordinates of the nodes are in the nx2 array MUA.coordinates, where n is the number of nodes.
%
%   MUA.coordinates(:,1)    are the nodal x coordinates
%   MUA.coordinates(:,y)    are the nodal y coordinates
%
%
%   BCs             Structure with all boundary conditions
%   l               Lagrange parameters related to the enforcement of boundary
%                   conditions.
%   GF              Grounding floating mask for nodes and elements.
%
%   Note: If preferred to work directly with the variables rather than the respective fields of the structure F, thenF can easily be
%   converted into variables using v2struc.
%
%
%
%   Note:  For each call to this m-File, the variable
%
%       CtrlVar.DefineOutputsInfostring
%
%   gives you information about different stages of the run (start, middle
%   part, end, etc.).
%
%   So for example, when Ua calls this m-File for the last time during the
%   run, the variable has the value
%
%     CtrlVar.DefineOutputsInfostring="Last call"
%
%
%%


if F.solution=="-none-"
    
   return

end

% for a lat/lon grid I need to find the lat lon on a grid
x=linspace(min(F.x),max(F.x),100) ; y=linspace(min(F.y),max(F.y),100)  ; [X,Y]=ndgrid(x,y) ; [lat,lon]=psn2ll(X,Y); 
%


CtrlVar.VelPlotIntervalSpacing='log10'; CtrlVar.QuiverColorSpeedLimits=[1 1000] ;  
cbar=UaPlots(CtrlVar,MUA,F,"-uv-",FigureTitle="velocities") ; title("Modelled velocities") 
xlabel("(km)") ;  ylabel("(km)") ;

cbar=UaPlots(CtrlVar,MUA,F,"-speed-",FigureTitle="speed") ; title("Modelled speed") ;  set(gca,'ColorScale','log') ; clim([1 2000])
hold on  ; LatLonGrid(X/1000,Y/1000,lat,lon,LineColor=[0.5 0.5 0.5],LabelSpacing=200)
xlabel("(km)") ;  ylabel("(km)") ;

cbar=UaPlots(CtrlVar,MUA,F,F.h,FigureTitle="h") ; title("Ice thickness") ;  colormap(othercolor("Mlightterrain",25))  ; title(cbar,"(m)") ; set(gca,'ColorScale','lin') ; 
clim([-100 3800])
hold on  ; LatLonGrid(X/1000,Y/1000,lat,lon,LineColor=[0.5 0.5 0.5],LabelSpacing=200)
xlabel("(km)") ;  ylabel("(km)") ;

cbar=UaPlots(CtrlVar,MUA,F,F.B,FigureTitle="B") ; title("Bedrock") ;  clim([-500 2000]) ;  title(cbar,"(m)") ;  colormap(othercolor("Mdarkterrain",25))  ;
hold on  ; LatLonGrid(X/1000,Y/1000,lat,lon,LineColor=[0.5 0.5 0.5],LabelSpacing=200)
xlabel("(km)") ;  ylabel("(km)") ;

cbar=UaPlots(CtrlVar,MUA,F,F.s,FigureTitle="s") ;
title("Ice surface") ;   colormap(othercolor("Mlightterrain",25))  ;  title(cbar,"(m)") ; set(gca,'ColorScale','lin') ;
hold on  ; LatLonGrid(X/1000,Y/1000,lat,lon,LineColor=[0.5 0.5 0.5],LabelSpacing=200) ; ScaleBar(); axis off
xlabel("(km)") ;  ylabel("(km)") ; clim([0 3800])

cbar=UaPlots(CtrlVar,MUA,F,F.as,FigureTitle="as") ;
title("Surface mass balance") ;
title(cbar,"(mWE/yr)") ; set(gca,'ColorScale','lin') ;
hold on  ; LatLonGrid(X/1000,Y/1000,lat,lon,LineColor=[0.5 0.5 0.5],LabelSpacing=200) ; ScaleBar(); axis off
clim([-7 5]) ; CM=cmocean('-balanced',25,'pivot',0) ; colormap(CM);
xlabel("(km)") ;  ylabel("(km)") ;

if ~(F.solution=="-uv-")
    UaPlots(CtrlVar,MUA,F,F.dhdt,FigureTitle="dh/dt")
    title("Modelled dh/dt") ;    title(cbar,"(m/yr)") ; set(gca,'ColorScale','lin') ;
    hold on  ; LatLonGrid(X/1000,Y/1000,lat,lon,LineColor=[0.5 0.5 0.5],LabelSpacing=200) ; ScaleBar(); axis off
    xlabel("(km)") ;  ylabel("(km)") ;
    clim([-10 10])
    CM=cmocean('balanced',25,'pivot',0) ; colormap(CM);
end


end